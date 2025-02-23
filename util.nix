{
  mkProfileOption =
    lib: option:
    {
      profiles = with lib.types; lib.mkOption {
        type = attrsOf (submodule {
          options = option;
        });
      };
    };
}
