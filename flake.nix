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

		# Nix JetBrains plugins
		nix-jetbrains-plugins.url = "github:theCapypara/nix-jetbrains-plugins";
	};

	outputs = { nixpkgs, ... } @ inputs : let
		machines = {
			claptrap = import ./machines/claptrap.nix inputs;
			rustbucket = import ./machines/rustbucket.nix inputs;
		};
	in {
		nixosConfigurations = machines;
		homeConfigurations = let lib = nixpkgs.lib; in lib.listToAttrs (
			lib.flatten (
				lib.mapAttrsToList (systemName: machine:
					lib.mapAttrsToList (username: user:
						lib.nameValuePair "${systemName}-${username}" user
					) machine.config.home-manager.users
				) machines
			)
		);
	};
}
