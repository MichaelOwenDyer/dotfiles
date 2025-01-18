{
	description = "Michael's flake";

	inputs = {
		# Unstable and stable nixpkgs channels
		nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
		nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-24.11";

		# Home manager
		home-manager.url = "github:nix-community/home-manager/master";
		home-manager.inputs.nixpkgs.follows = "nixpkgs";

		# Nix User Repository
		nur.url = "github:nix-community/NUR";
		nur.inputs.nixpkgs.follows = "nixpkgs";

		# NixOS hardware configuration
		nixos-hardware.url = "github:NixOS/nixos-hardware/master";
	};

	outputs = { nixpkgs, home-manager, nur, nixos-hardware, ... }: let 
		machines = {
			claptrap = import ./machines/claptrap.nix { inherit nixpkgs home-manager nur nixos-hardware; };
			rustbucket = import ./machines/rustbucket.nix { inherit nixpkgs home-manager nur nixos-hardware; };
		};
	in {
		nixosConfigurations = machines;
		# Flatten the list of lists and reconstruct an attribute set using the name-value pairs
		homeConfigurations = let lib = nixpkgs.lib; in lib.listToAttrs (lib.flatten (
			# Map machines to a list of lists of name-value pairs containing each user config under a unique name
			lib.mapAttrsToList (systemName: machine:
				lib.mapAttrsToList (username: user:
					lib.nameValuePair "${systemName}-${username}" user
				) machine.config.home-manager.users
			) machines
		));
	};
}
