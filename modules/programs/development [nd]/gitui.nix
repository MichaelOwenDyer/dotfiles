{
  ...
}:
{
  flake.modules.homeManager.gitui = {
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
  };
}
