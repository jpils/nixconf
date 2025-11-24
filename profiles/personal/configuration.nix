
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, inputs, ... }:
let 
	inherit (lib) mkIf mkDefault;
	inherit (inputs.hyprland.packages.${pkgs.system}) hyprland xdg-desktop-portal-hyprland;
in {
	# Use the systemd-boot EFI boot loader.
	boot.loader.systemd-boot.enable = true;
	boot.loader.efi.canTouchEfiVariables = true;

	# networking.hostName = "nixos"; # Define your hostname.
	# Pick only one of the below networking options.
	# networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
	networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.
	networking.networkmanager.plugins = with pkgs; [ networkmanager-openconnect ];


	# Set your time zone.
	time.timeZone = "Europe/Vienna";

	# Configure network proxy if necessary
	# networking.proxy.default = "http://user:password@proxy:port/";
	# networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

	# Select internationalisation properties.
	# i18n.defaultLocale = "en_US.UTF-8";
	# console = {
	#   font = "Lat2-Terminus16";
	#   keyMap = "us";
	#   useXkbConfig = true; # use xkb.options in tty.  };

	# Enable the X11 windowing system.
	services.xserver.enable = true;
	services.displayManager.sddm.enable = true;
	services.displayManager.sddm.wayland = {
		enable = true;
	};

	programs = {
		hyprland = {
			enable = true;
			xwayland.enable = true;
			package = inputs.hyprland.packages.${pkgs.system}.hyprland;
			portalPackage = inputs.hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland;
		};
	};

		#xdg.portal = {
		#	enable = true;
		#	config = {
		#		sway = {
		#			"org.freedesktop.impl.portal.Screenshot.PickColor" = [ "${pkgs.hyprpicker}/bin/hyprpicker" ];
		#		};
		#		common.default = "*";
		#	};

		#	# gtk portal needed to make gtk apps happy
		#	extraPortals = [
		#		xdg-desktop-portal-hyprland
		#		pkgs.xdg-desktop-portal-gtk
		#	];
		#};

	services.displayManager = {
		enable = true;
		autoLogin = {
			enable = true;
			user = "jay"; # Replace 'yourUserName' with your actual username
		};
	};

	environment.sessionVariables = {
		NIXOS_OZONE_WL = "1";
	};

	services.tlp = {
		enable = true;
		settings = {
			START_CHARGE_THRESH_BAT0 = 75;
			STOP_CHARGE_THRESH_BAT0 = 80;

		};
	};

	services.auto-cpufreq.enable = true; 
	services.auto-cpufreq.settings = {
		battery = {
			governor = "powersave";
			turbo = "never";
		};
		charger = {
			governor = "performance";
			turbo = "auto";
		};
	};

	services.keyd = {
		enable = true;
		keyboards = {
			default = {
				ids = [ "*" ];
				settings = {
					global = {
						overload_tap_timeout = "500";
					};
					main = {
						capslock = "overload(control, esc)";
					};
				};
			};
		};
	};

	# Configure keymap in X11 services.xserver.xkb.layout = "us";
	# services.xserver.xkb.options = "eurosign:e,caps:escape";

	# Set the keyboard layout
	services.xserver = { xkb.layout = "us"; xkb.variant = "dvorak"; };
	console.useXkbConfig = true;

	# Enable CUPS to print documents.  services.printing.enable = true;

	# Enable sound.
	security.rtkit.enable = true;
	services.pipewire = {
		enable = true;
		alsa.enable = true;
		alsa.support32Bit = true;
		pulse.enable = true;
		jack.enable = true;
	};

	hardware.bluetooth.enable = true;
	hardware.bluetooth.powerOnBoot = true;

	systemd.user.services.mpris-proxy = {
		description = "Mpris proxy";
		after = [ "network.target" "sound.target" ];
		wantedBy = [ "default.target" ];
		serviceConfig.ExecStart = "${pkgs.bluez}/bin/mpris-proxy";
	};

	virtualisation.docker.enable = true;
	# Define a user account. Don't forget to set a password with ‘passwd’.
	users.users.jay = {
		isNormalUser = true; 
		extraGroups = [ "wheel" "networkmanager" "docker" "input" ]; # Enable ‘sudo’ for the user.  
		shell = pkgs.zsh;
		packages = with pkgs; [
		]; 
	};

	virtualisation.libvirtd.enable = true;

	hardware.uinput.enable = true;
	users.groups.uinput.members = [ "jay" ];
	users.groups.input.members = [ "jay" ];

	programs.zsh.enable = true;


	nixpkgs.config = {
		allowUnfree = true;
	};

    environment.pathsToLink = [
      "/share/xdg-desktop-portal"
      "/share/applications"
    ];
	

	hardware.keyboard.zsa.enable = true;

	environment.systemPackages = with pkgs; [ 
		pulseaudio
		pavucontrol
		alsa-utils
		auto-cpufreq
		blueman
		firefox 
		git 
		jujutsu
		home-manager
		qemu
		tldr
		binutils
		gcc
		keyd
		unzip
		vim
		wget
		xdg-desktop-portal-gtk
	];



	# Some programs need SUID wrappers, can be configured further or are
	# started in user sessions.
	# programs.mtr.enable = true;
	# programs.gnupg.agent = {
	#   enable = true;
	#   enableSSHSupport = true;
	# };

	# List services that you want to enable:

	# Enable the OpenSSH daemon.
	services.openssh = {
		enable = true;
		extraConfig = ''
		UseDNS no
		'';
	};
	# Open ports in the firewall.
	#	networking.firewall.allowedTCPPorts = [ 8384 22000 ];
	#	networking.firewall.allowedUDPPorts = [ 22000 21027 ];
	# Or disable the firewall altogether.
	#networking.firewall.enable = false;

	# Copy the NixOS configuration file and link it from the resulting system
	# (/run/current-system/configuration.nix). This is useful in case you
	# accidentally delete configuration.nix.
	# system.copySystemConfiguration = true;

	# This option defines the first version of NixOS you have installed on this particular machine,
	# and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
	#
	# Most users should NEVER change this value after the initial install, for any reason,
	# even if you've upgraded your system to a new NixOS release.
	#
	# This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
	# so changing it will NOT upgrade your system.
	#
	# This value being lower than the current NixOS release does NOT mean your system is
	# out of date, out of support, or vulnerable.
	#
	# Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
	# and migrated your data accordingly.
	#
	# For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
	system.stateVersion = "23.11"; # Did you read the comment?

	nix.settings = {
		experimental-features = [ "nix-command" "flakes" ];
		substituters = [
			"https://cache.nixos.org/"
			"https://hyprland.cachix.org"
			"https://nix-community.cachix.org"
		];
		trusted-public-keys = [
			"hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
			"nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
		];
	};
}

