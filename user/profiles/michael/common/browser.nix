{
  pkgs,
  ...
}:

{
  config.profiles.michael = {
    browser.firefox = {
			enable = true;
			extensions = with pkgs.nur.repos.rycee.firefox-addons; [
				ublock-origin
			];
		};
    browser.zen.enable = true;
  };
}