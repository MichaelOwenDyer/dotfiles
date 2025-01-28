# NixOS configuration for my laptop

{ nixpkgs, ... } @ inputs: let platform = "x86_64-linux"; in nixpkgs.lib.nixosSystem {

	# Define the system platform
	system = platform;

	# Allow the modules listed below to import any input from the flake
	specialArgs = inputs;

	modules = [

		# Import everything from the modules directory so that all the options exist for us to configure how we want
		../modules

		# Add michael as a user
		../profiles/michael/claptrap.nix

		# Machine-specific module closure. This is the closest thing to a configuration.nix in this setup
		({ lib, nixos-hardware, ... }: {

			imports = [
				./default.nix
				nixos-hardware.nixosModules.dell-xps-13-9360 # Use pre-defined hardware configuration for Dell XPS 13 9360
			];

			networking.hostName = "claptrap";
			system.stateVersion = "24.11";
			time.timeZone = "Europe/Berlin";
			machine.isLaptop = true;
			system.wifi.enable = true; # TODO: Make this automatically enabled by machine.isLaptop

			# Set cpu governor to powersave
			powerManagement.cpuFreqGovernor = "powersave";

			# Sleep for 30 minutes then hibernate when lid is closed
			systemd.sleep.extraConfig = ''
					HibernateDelaySec=1800
			'';
			services.logind.lidSwitch = "suspend-then-hibernate";
			# Hibernate when power button is short-pressed, power off when long-pressed
			services.logind.powerKey = "hibernate";
			services.logind.powerKeyLongPress = "poweroff";
			# TODO: Test without this
			services.logind.extraConfig = ''
					HandlePowerKey=hibernate
			'';

			# Enable touchpad support (enabled default in most desktopManager).
			services.libinput.enable = true;
			services.libinput.touchpad = {
					tapping = true;
					tappingButtonMap = "lrm";
					disableWhileTyping = true;
					clickMethod = "clickfinger";
			};
			services.xserver.synaptics.palmDetect = true;

			## Setting keymap to `us' for this machine.
			# os.keyboard.layout = "us"; TODO: Introduce option

			console = {
				font = "Lat2-Terminus16";
				keyMap = "us"; # TODO: Use os.keyboard.layout
			};

			## Hardware configuration

			boot.initrd.availableKernelModules = [ "xhci_pci" "nvme" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
			boot.initrd.kernelModules = [ ];
			boot.kernelModules = [ "kvm-intel" ];
			boot.extraModulePackages = [ ];

			fileSystems."/" = {
				device = "/dev/disk/by-uuid/3bf7699c-c538-4368-842c-dce257ee819e";
				fsType = "ext4";
			};

			fileSystems."/boot" = {
				device = "/dev/disk/by-uuid/281C-AB23";
				fsType = "vfat";
				options = [ "fmask=0077" "dmask=0077" "umask=0077" ];
			};

			swapDevices = [
				{ device = "/dev/disk/by-uuid/96ea764b-fd7b-4445-b437-ddb55c24ceed"; }
			];

			# networking.interfaces.enp57s0u1u2.useDHCP = lib.mkDefault true;
			# networking.interfaces.wlp58s0.useDHCP = lib.mkDefault true;

			nixpkgs.hostPlatform = lib.mkDefault platform;
			hardware.enableAllFirmware = true;
			hardware.cpu.intel.updateMicrocode = lib.mkDefault true;
		})
	];
}
