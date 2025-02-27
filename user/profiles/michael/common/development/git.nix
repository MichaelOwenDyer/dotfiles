{
  config,
  ...
}:

{
  config.profiles.michael = {
    development.git = {
      enable = true;
      name = config.profiles.michael.fullName;
      email = config.profiles.michael.email;
      config = {
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
  };
}