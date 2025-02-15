{
  lib,
	stylix,
	...
}:

{
  imports = [
    # Import Stylix as a NixOS module
    stylix.nixosModules.stylix
  ];

	options = {
		# No additional options, just configure Stylix directly
	};

	config = {
		# No default configuration
	};
}