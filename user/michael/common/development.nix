{
  name,
  email,
}:

{
  pkgs,
  ...
}:

{
  programs.git = {
    enable = true;
    userName = name;
    userEmail = email;
    extraConfig = {
      init = {
        defaultBranch = "main";
      };
      pull = {
        rebase = true;
      };
      url = {
        "https://github.com" = {
          insteadOf = [
            "gh:"
            "github:"
          ];
        };
      };
    };
  };
  # Terminal
  programs.ghostty.enable = true;
  # Run commands when entering a directory
  programs.direnv = {
    enable = true;
    silent = true;
    nix-direnv.enable = true;
  };
  # Better cd
  programs.zoxide.enable = true;
  # Fuzzy file search https://github.com/junegunn/fzf
  programs.fzf.enable = true;
  # Enhanced cat https://github.com/sharkdp/bat
  programs.bat.enable = true;
  # Terminal file browser https://github.com/sxyazi/yazi
  programs.yazi.enable = true;
  # Modern VCS https://github.com/jj-vcs/jj
  programs.jujutsu = {
    enable = true;
    settings = {
      user = { inherit name email; };
    };
  };
  # Git UI https://github.com/gitui-org/gitui
  programs.gitui = {
    enable = true;
    keyConfig = ''
      move_left: Some(( code: Char('h'), modifiers: ( bits: 0,),)),
      move_right: Some(( code: Char('l'), modifiers: ( bits: 0,),)),
      move_up: Some(( code: Char('k'), modifiers: ( bits: 0,),)),
      move_down: Some(( code: Char('j'), modifiers: ( bits: 0,),)),

      stash_open: Some(( code: Char('l'), modifiers: ( bits: 0,),)),
      open_help: Some(( code: F(1), modifiers: "")),

      status_reset_item: Some(( code: Char('U'), modifiers: "SHIFT")),

      exit: Some(( code: Char('c'), modifiers: ( bits: 2,),)),
      quit: Some(( code: Char('q'), modifiers: ( bits: 0,),)),
      exit_popup: Some(( code: Esc, modifiers: ( bits: 0,),)),
    '';
  };
  home.packages = with pkgs; [
    nixd # https://github.com/nix-community/nixd
    nixfmt-rfc-style # https://github.com/NixOS/nixfmt
    # rustup # https://github.com/rust-lang/rustup
    ripgrep # rg: Rust grep https://github.com/BurntSushi/ripgrep
    ripgrep-all # rga: Rust grep with deep search https://github.com/phiresky/ripgrep-all
    fd # Find files https://github.com/sharkdp/fd
    eza # Replace ls https://github.com/eza-community/eza
    xh # Send HTTP requests https://github.com/ducaale/xh
    dust # Disk space analyzer https://github.com/bootandy/dust
    dysk # Disk space overview https://github.com/Canop/dysk
    # hyperfine # Benchmark terminal commands https://github.com/sharkdp/hyperfine
    # fselect # Query files like SQL https://github.com/jhspetersson/fselect
    # rusty-man # Rustdoc terminal viewer https://crates.io/crates/rusty-man
    # delta # Git differ https://github.com/dandavison/delta
    # wiki-tui # Wikipedia terminal viewer https://github.com/Builditluc/wiki-tui
    # mprocs # Run multiple commands in parallel https://github.com/pvolok/mprocs
    wl-clipboard # Wayland clipboard lib https://github.com/bugaevc/wl-clipboard/
    # wl-clipboard-rs # Wayland clipboard lib (wlroots-based window managers only) https://github.com/YaLTeR/wl-clipboard-rs
    lazyjj # Terminal UI for Jujutsu https://github.com/Cretezy/lazyjj
    # alacritty # GPU-accelerated terminal emulator written in Rust https://github.com/alacritty/alacritty
    zellij # Terminal multiplexer written in Rust https://github.com/zellij-org/zellij
    # devenv
  ];
  home.shellAliases = {
    cd = "z";
    ls = "eza";
  };
}
