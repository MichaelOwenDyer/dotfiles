-- Yazi plugin for NixOS impermanence - shows persistence status
-- Statuses: persisted (●), ephemeral (•), untracked (!), separate_mount (no icon)
-- Parent dirs bubble up: untracked > persisted > ephemeral

local PATHS_FILE = "/etc/impermanence-paths.json"
local VIRTUAL_FS = { "/proc", "/sys", "/dev", "/run" }

local function is_virtual_fs(path)
	for _, vfs in ipairs(VIRTUAL_FS) do
		if path == vfs or path:sub(1, #vfs + 1) == vfs .. "/" then
			return true
		end
	end
	return false
end

-- Returns status or nil if path is a parent that needs scanning
local function get_simple_status(st, path)
	if is_virtual_fs(path) then return "separate_mount" end
	if not st.loaded then return "untracked" end

	-- Check separate mounts
	for mount_path in pairs(st.separate_mounts) do
		if path == mount_path or path:sub(1, #mount_path + 1) == mount_path .. "/" then
			return "separate_mount"
		end
	end

	-- Check persist path itself
	if st.persist_path and path:find("^" .. st.persist_path:gsub("([%-%.%+%[%]%(%)%$%^%%%?%*])", "%%%1")) then
		return "persisted"
	end

	-- Check persisted paths
	if st.persisted_paths[path] then return "persisted" end
	for p in pairs(st.persisted_paths) do
		if path:sub(1, #p + 1) == p .. "/" then return "persisted" end
	end

	-- Check ephemeral paths
	if st.ephemeral_paths[path] then return "ephemeral" end
	for p in pairs(st.ephemeral_paths) do
		if path:sub(1, #p + 1) == p .. "/" then return "ephemeral" end
	end

	-- Check if parent of any configured path
	for p in pairs(st.persisted_paths) do
		if p:sub(1, #path + 1) == path .. "/" then return nil end
	end
	for p in pairs(st.ephemeral_paths) do
		if p:sub(1, #path + 1) == path .. "/" then return nil end
	end

	return "untracked"
end

-- Scan directory children, bubble up: untracked > persisted > ephemeral
local function scan_directory_status(st, dir_path)
	local handle = io.popen('ls -A "' .. dir_path:gsub('"', '\\"') .. '" 2>/dev/null')
	if not handle then return "ephemeral" end

	local output = handle:read("*a")
	handle:close()

	local has_persisted = false
	for name in output:gmatch("[^\n]+") do
		local child_path = dir_path .. "/" .. name
		local status = get_simple_status(st, child_path)
		if status == nil then status = scan_directory_status(st, child_path) end

		if status == "untracked" then return "untracked" end
		if status == "persisted" then has_persisted = true end
	end

	return has_persisted and "persisted" or "ephemeral"
end

local function get_path_status(st, path)
	if st.status_cache[path] then return st.status_cache[path] end
	local status = get_simple_status(st, path) or scan_directory_status(st, path)
	st.status_cache[path] = status
	return status
end

local function setup(st, opts)
	opts = opts or {}
	st.persisted_marker = opts.persisted_marker or "●"
	st.ephemeral_marker = opts.ephemeral_marker or "•"
	st.untracked_marker = opts.untracked_marker or "!"
	st.persisted_style = ui.Style():fg(opts.persisted_color or "cyan"):bold()
	st.ephemeral_style = ui.Style():fg(opts.ephemeral_color or "darkgray")
	st.untracked_style = ui.Style():fg(opts.untracked_color or "red"):bold()
	st.show_header = opts.show_header ~= false
	st.show_linemode = opts.show_linemode ~= false
	st.linemode_order = opts.linemode_order or 500
	st.header_order = opts.header_order or 500
	st.persisted_paths, st.ephemeral_paths, st.separate_mounts, st.status_cache = {}, {}, {}, {}
	st.persist_path = "/persist"
	st.loaded = false

	local file = io.open(PATHS_FILE, "r")
	if file then
		local content = file:read("*a")
		file:close()

		local function extract_array(json, key)
			local start_pos = json:find('"' .. key .. '"%s*:%s*%[')
			if not start_pos then return function() end end
			local bracket_pos = json:find("%[", start_pos)
			if not bracket_pos then return function() end end
			local depth, end_pos = 1, bracket_pos + 1
			while depth > 0 and end_pos <= #json do
				local c = json:sub(end_pos, end_pos)
				if c == "[" then depth = depth + 1 elseif c == "]" then depth = depth - 1 end
				end_pos = end_pos + 1
			end
			return json:sub(bracket_pos + 1, end_pos - 2):gmatch('"([^"]+)"')
		end

		st.persist_path = content:match('"path"%s*:%s*"([^"]+)"') or st.persist_path
		for p in extract_array(content, "files") do st.persisted_paths[p] = true end
		for p in extract_array(content, "directories") do st.persisted_paths[p] = true end
		for p in extract_array(content, "ephemeral") do st.ephemeral_paths[p] = true end
		for p in extract_array(content, "separateMounts") do st.separate_mounts[p] = true end
		st.loaded = true
	end

	local function render_status(status, marker, style, is_hovered)
		if is_hovered then
			return ui.Line({ " ", marker })
		else
			return ui.Line({ " ", ui.Span(marker):style(style) })
		end
	end

	if st.show_header then
		Header:children_add(function()
			local cwd = tostring(cx.active.current.cwd)
			if cwd == "/" then return ui.Span("") end
			local status = get_path_status(st, cwd)
			if status == "persisted" then return ui.Span(" " .. st.persisted_marker):style(st.persisted_style)
			elseif status == "ephemeral" then return ui.Span(" " .. st.ephemeral_marker):style(st.ephemeral_style)
			elseif status == "untracked" then return ui.Span(" " .. st.untracked_marker):style(st.untracked_style)
			end
			return ui.Span("")
		end, st.header_order, Header.RIGHT)
	end

	if st.show_linemode then
		Linemode:children_add(function(self)
			local status = get_path_status(st, tostring(self._file.url))
			local h = self._file.is_hovered
			if status == "persisted" then return render_status(status, st.persisted_marker, st.persisted_style, h)
			elseif status == "ephemeral" then return render_status(status, st.ephemeral_marker, st.ephemeral_style, h)
			elseif status == "untracked" then return render_status(status, st.untracked_marker, st.untracked_style, h)
			end
			return ui.Line({})
		end, st.linemode_order)
	end
end

return { setup = setup }
