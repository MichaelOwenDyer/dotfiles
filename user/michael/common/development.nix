{
  pkgs,
  name,
  email,
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
  programs.neovim.enable = true;
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
  # Git UI https://github.com/gitui-org/gitui
  programs.gitui = {
    enable = true;
    keyConfig = ''
      exit: Some(( code: Char('c'), modifiers: ( bits: 2,),)),
      quit: Some(( code: Char('q'), modifiers: ( bits: 0,),)),
      exit_popup: Some(( code: Esc, modifiers: ( bits: 0,),)),
    '';
  };
  home.packages = with pkgs; [
    nixd # https://github.com/nix-community/nixd
    nixfmt-rfc-style # https://github.com/NixOS/nixfmt
    rustup # https://github.com/rust-lang/rustup
    ripgrep # rg: Rust grep https://github.com/BurntSushi/ripgrep
    ripgrep-all # rga: Rust grep with deep search https://github.com/phiresky/ripgrep-all
    fd # Find files https://github.com/sharkdp/fd
    eza # Replace ls https://github.com/eza-community/eza
    xh # Send HTTP requests https://github.com/ducaale/xh
    dust # Disk space analyzer https://github.com/bootandy/dust
    hyperfine # Benchmark terminal commands https://github.com/sharkdp/hyperfine
    fselect # Query files like SQL https://github.com/jhspetersson/fselect
    rusty-man # Rustdoc terminal viewer https://crates.io/crates/rusty-man
    delta # Git differ https://github.com/dandavison/delta
    wiki-tui # Wikipedia terminal viewer https://github.com/Builditluc/wiki-tui
    mprocs # Run multiple commands in parallel https://github.com/pvolok/mprocs
  ];
  home.shellAliases = {
    cd = "z";
    ls = "eza";
    rebuild = "(cd ~/.dotfiles && git add --all && sudo nixos-rebuild switch --flake . --show-trace)";
  };
}