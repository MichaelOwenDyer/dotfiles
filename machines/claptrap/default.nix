{ nixpkgs, home-manager, nur, nixos-hardware, ... }: let

	system = "x86_64-linux";
	
in nixpkgs.lib.nixosSystem {

	inherit system;

	modules = [

		../../system # Include default system configuration

		../../home # Include default home configuration

		../../home/profiles/michael

		# ../../home/development/ide/vscode.nix

		# ../../home/browser/firefox.nix

		# ../../home/shell/zsh.nix

		# ../../system/io/wifi.nix

		## This module will return a `home-manager' object that can be used
		## in other modules (including this one).
		home-manager.nixosModules.home-manager

		## This module will return a `nur' object that can be used to access
		## NUR packages.
		nur.modules.nixos.default

		# Use pre-defined hardware configuration for Dell XPS 13 9360
		nixos-hardware.nixosModules.dell-xps-13-9360

		## System specific
		##
		## Closure that returns the module containing configuration specific to this machine
		({ lib, config, pkgs, ... }: {

			networking.hostName = "claptrap";
			time.timeZone = "Europe/Berlin";
			machine.isLaptop = true;
			system.io.wifi.enable = true; # TODO: Make this automatically enabled by machine.isLaptop

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
					
			# Use the latest kernel
			# boot.kernelPackages = (lib.mkDefault pkgs.linux_latest); TODO: Reintroduce this

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

			nixpkgs.hostPlatform = lib.mkDefault system;
			hardware.enableAllFirmware = true;
			hardware.cpu.intel.updateMicrocode = lib.mkDefault true;
		})
	];
}
