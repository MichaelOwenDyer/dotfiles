_:

{
  imports = [
    ../common
  ];

  config.profiles.michael = {
    development.ide.cursor = {
      enable = true;
    };
  };
}
