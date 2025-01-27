# NixOS configuration for my desktop PC

{ nixpkgs, home-manager, nur, ... }: let platform = "x86_64-linux"; in nixpkgs.lib.nixosSystem {

	# Define the system platform
	system = platform;

	# Allow the modules listed below to import these modules
	specialArgs = { inherit home-manager nur };

	modules = [

		../modules

		../profiles/michael/rustbucket.nix

		# Machine-specific module closure. This is the closest thing to a configuration.nix in this setup.
		({ lib, ... }: {

			imports = [
				./default.nix
			];

			networking.hostName = "rustbucket";
			system.stateVersion = "24.11";
			time.timeZone = "Europe/Berlin";

			# Enable automatic login for the user
			services.displayManager.autoLogin.enable = true;
			services.displayManager.autoLogin.user = "michael";
			# Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
			systemd.services."getty@tty1".enable = false;
			systemd.services."autovt@tty1".enable = false;

			# Nvidia drivers for Xorg and Wayland
			services.xserver.videoDrivers = [ "nvidia" ];

			hardware.nvidia = {
				modesetting.enable = true;
				powerManagement.enable = false;
				powerManagement.finegrained = false;
				open = false;
				nvidiaSettings = true;
				package = boot.kernelPackages.nvidiaPackages.stable;
			};

			boot.initrd.availableKernelModules = [ "xhci_pci" "ehci_pci" "ahci" "nvme" "usb_storage" "usbhid" "sd_mod" "sr_mod" ];
			boot.initrd.kernelModules = [ ];
			boot.kernelModules = [ "kvm-intel" ];
			boot.extraModulePackages = [ ];

			fileSystems."/" = {
					device = "/dev/disk/by-uuid/130acd15-8d64-4c32-a670-bc954b945594";
					fsType = "ext4";
			};

			fileSystems."/boot" = {
					device = "/dev/disk/by-uuid/4595-D8A1";
					fsType = "vfat";
					options = [ "fmask=0077" "dmask=0077" "umask=0077" ];
			};

			swapDevices = [ ];

			# Enables DHCP on each ethernet and wireless interface. In case of scripted networking
			# (the default) this is the recommended approach. When using systemd-networkd it's
			# still possible to use this option, but it's recommended to use it in conjunction
			# with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
			networking.useDHCP = false;
			# networking.interfaces.enp4s0.useDHCP = lib.mkDefault true;

			nixpkgs.hostPlatform = lib.mkDefault platform;
			hardware.enableRedistributableFirmware = true;
			hardware.cpu.intel.updateMicrocode = true;

		})
	];
}
