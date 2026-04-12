{self, inputs, ...}: {
	flake.nixosModules.homePcConfiguration = { config, lib, pkgs, inputs, ... }: {
		imports = [
			self.nixosModules.homePcHardware
			self.nixosModule.niri
		];

		boot.loader.systemd-boot.enable = true;
		boot.loader.efi.canTouchEfiVariables = true;


		networking.networkmanager.enable = true;
		networking.networkmanager.plugins = with pkgs; [ networkmanager-openconnect ];

		time.timeZone = "Europe/Vienna";

		services.xserver.enable = true;
		services.displayManager.sddm.enable = true;
		services.displayManager.sddm.wayland.enable = true;
		services.system76-scheduler.settings.cfsProfiles.enable = true;

		services.displayManager = {
			enable = true;
			autoLogin = {
				enable = true;
				user = "jay";
			};
		};

		environment.sessionVariables = {
			NIXOS_OZONE_WL = "1";
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

		services.printing = {
			enable = true;
			drivers = with pkgs; [
				gutenprint
				gutenprintBin
				cups-filters
			]; 
		};

		services.avahi = {
			enable = true;
			nssmdns4 = true;
			openFirewall = true;
		};

		services.xserver = { xkb.layout = "us"; xkb.variant = "dvorak"; };
		console.useXkbConfig = true;

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
		users.users.jay = {
			isNormalUser = true; 
			extraGroups = [ "wheel" "networkmanager" "docker" "input" "audio" ];
			shell = pkgs.zsh;
			packages = with pkgs; [
			]; 
		};

		virtualisation.libvirtd.enable = true;

		hardware.uinput.enable = true;
		users.groups.uinput.members = [ "jay" ];
		users.groups.input.members = [ "jay" ];

		programs.zsh.enable = true;

		hardware.keyboard.zsa.enable = true;

		environment.systemPackages = with pkgs; [ 
			alsa-utils
			binutils
			blueman
			firefox 
			gcc
			git 
			home-manager
			jujutsu
			keyd
			pavucontrol
			pulseaudio
			qemu
			tldr
			unzip
			vim
			wget
		];

		nixpkgs.config = {
			allowUnfree = true;
		};

		services.openssh = {
			enable = true;
			extraConfig = ''
			UseDNS no
			'';
		};

		system.stateVersion = "23.11"; # Did you read the comment?

		nix.settings = {
			experimental-features = [ "nix-command" "flakes" ];
			substituters = [
				"https://cache.nixos.org/"
				"https://hyprland.cachix.org"
				"https://nix-community.cachix.org"
			];
		};
	};
}
