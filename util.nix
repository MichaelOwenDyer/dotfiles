{
  # This is a helper function to create an option in the form profiles.<username>.<option>,
  # e.g. an option which can be configured independently for each user profile.
  # For now, it requires "lib" to be passed as an argument.
  # TODO: Investigate how to make this function available without passing "lib" as an argument
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
