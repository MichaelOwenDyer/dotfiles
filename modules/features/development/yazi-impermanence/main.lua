--- @since 25.2.7
-- Yazi plugin for NixOS impermanence
-- Shows persistence status for files and directories
--
-- Features:
-- - Header indicator showing if current directory is persisted
-- - Linemode showing persistence status per file
-- - Cached path lookups for performance

---@class State
---@field paths table<string, boolean> Map of persisted paths
---@field loaded boolean Whether paths have been loaded
---@field marker string Marker to show for persisted items
---@field color string Color for the marker
---@field show_header boolean Whether to show header indicator
---@field show_linemode boolean Whether to show linemode indicator

local PATHS_FILE = "/etc/impermanence-paths.json"

--- Check if a path is persisted (either directly or as a child of a persisted directory)
---@param st State
---@param path string
---@return boolean
local function is_path_persisted(st, path)
	if not st.loaded then
		return false
	end

	-- Direct match
	if st.paths[path] then
		return true
	end

	-- Check if path is under a persisted directory
	for persisted_path, _ in pairs(st.paths) do
		-- Check if path starts with persisted_path/
		if path:sub(1, #persisted_path + 1) == persisted_path .. "/" then
			return true
		end
	end

	-- Check if path is under /persist
	if path:find("^/persist") then
		return true
	end

	return false
end

---@param st State
---@param opts table
local function setup(st, opts)
	opts = opts or {}
	st.marker = opts.marker or " 💾"
	st.ephemeral_marker = opts.ephemeral_marker or ""
	st.color = opts.color or "#83a598"
	st.ephemeral_color = opts.ephemeral_color or "#cc241d"
	st.show_header = opts.show_header ~= false -- default true
	st.show_linemode = opts.show_linemode ~= false -- default true
	st.linemode_order = opts.linemode_order or 500
	st.header_order = opts.header_order or 500
	st.paths = {}
	st.loaded = false

	-- Load paths synchronously on setup
	local file = io.open(PATHS_FILE, "r")
	if file then
		local content = file:read("*a")
		file:close()
		-- Parse JSON manually (yazi doesn't have json module)
		-- Format: {"files":["/path1","/path2"],"directories":["/dir1","/dir2"]}
		for path in content:gmatch('"(/[^"]+)"') do
			st.paths[path] = true
		end
		st.loaded = true
	end

	-- Add header indicator if enabled
	if st.show_header then
		Header:children_add(function(self)
			local cwd = tostring(cx.active.current.cwd)
			local persisted = is_path_persisted(st, cwd)

			if persisted then
				return ui.Span(st.marker):fg(st.color)
			elseif cwd:find("^/persist") then
				-- Inside /persist itself
				return ui.Span(st.marker):fg(st.color)
			elseif cwd:find("^/home") or cwd:find("^/nix") or cwd:find("^/run") then
				-- These are typically persisted or special
				return ""
			else
				-- Potentially ephemeral
				if st.ephemeral_marker ~= "" then
					return ui.Span(st.ephemeral_marker):fg(st.ephemeral_color)
				end
				return ""
			end
		end, st.header_order, Header.RIGHT)
	end

	-- Add linemode indicator if enabled
	if st.show_linemode then
		Linemode:children_add(function(self)
			local url = self._file.url
			local path = tostring(url)
			local persisted = is_path_persisted(st, path)

			if persisted then
				if self._file.is_hovered then
					return ui.Line({ " ", "💾" })
				else
					return ui.Line({ " ", ui.Span("💾"):fg(st.color) })
				end
			end
			return ""
		end, st.linemode_order)
	end
end

--- Fetcher that checks persistence status for files in current directory
--- This is called when entering a directory
---@param job table
---@return boolean
local function fetch(job)
	-- Fetcher is optional - the linemode checks paths directly
	-- This could be used for pre-caching if needed
	return true
end

return { setup = setup, fetch = fetch }
