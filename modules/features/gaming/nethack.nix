{
  ...
}:
{
  flake.modules.homeManager.nethack =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.nethack ];

      # NetHack configuration file
      home.file.".nethackrc".text = ''
        # Ask for player name every time
        OPTIONS=name:player
        # number_pad:1 enables arrow keys for movement
        OPTIONS=number_pad:1

        # Display boulders as '0' instead of the default backtick
        OPTIONS=boulder:0

        OPTIONS=autopickup
        # Only autopickup money, scrolls, potions, and wands
        OPTIONS=pickup_types:$?!/
        OPTIONS=color
        OPTIONS=showexp
        OPTIONS=time
        OPTIONS=autodig
        OPTIONS=pushweapon
        OPTIONS=disclose:yi ya yv yg yc yo
      '';
    };
}
