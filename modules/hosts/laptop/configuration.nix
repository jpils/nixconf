{self, inputs, ...}: {
	flake.nixosModules.laptopConfiguration = { config, lib, pkgs, inputs, ... }: let
		graphiteXkbSymbols = pkgs.writeText "graphite-xkb-symbols" ''
			default partial alphanumeric_keys
			xkb_symbols "basic" {
				include "us(basic)"
				name[Group1]= "Graphite";

				key <AE11> { [ bracketleft, braceleft ] };
				key <AE12> { [ bracketright, braceright ] };

				key <AD01> { [ b, B ] };
				key <AD02> { [ l, L ] };
				key <AD03> { [ d, D ] };
				key <AD04> { [ w, W ] };
				key <AD05> { [ z, Z ] };
				key <AD06> { [ apostrophe, underscore ] };
				key <AD07> { [ f, F ] };
				key <AD08> { [ o, O ] };
				key <AD09> { [ u, U ] };
				key <AD10> { [ j, J ] };
				key <AD11> { [ semicolon, colon ] };
				key <AD12> { [ equal, plus ] };
				key <BKSL> { [ backslash, bar ] };
				key <LSGT> { [ less, greater, bar ] };

				key <AC01> { [ n, N ] };
				key <AC02> { [ r, R ] };
				key <AC03> { [ t, T ] };
				key <AC04> { [ s, S ] };
				key <AC05> { [ g, G ] };
				key <AC06> { [ y, Y ] };
				key <AC07> { [ h, H ] };
				key <AC08> { [ a, A ] };
				key <AC09> { [ e, E ] };
				key <AC10> { [ i, I ] };
				key <AC11> { [ comma, question ] };

				key <AB01> { [ q, Q ] };
				key <AB02> { [ x, X ] };
				key <AB03> { [ m, M ] };
				key <AB04> { [ c, C ] };
				key <AB05> { [ v, V ] };
				key <AB06> { [ k, K ] };
				key <AB07> { [ p, P ] };
				key <AB08> { [ period, greater ] };
				key <AB09> { [ minus, quotedbl ] };
				key <AB10> { [ slash, less ] };
			};
		'';
		sddm-blurred-wallpaper = pkgs.runCommand "sddm-blurred-wallpaper.png" { nativeBuildInputs = [ pkgs.imagemagick ]; } ''
			magick ${self.wallpaper} -blur 0x7 -blur 0x7 -blur 0x7 $out
		'';
		custom-sddm-theme = pkgs.sddm-astronaut.override {
			themeConfig = {
				Background = "${sddm-blurred-wallpaper}";
				PartialBlur = "false";
				FullBlur = "false";
			};
		};
	in {
		imports = [
			# hardware
			self.nixosModules.laptopHardware
			self.nixosModules.laptopDisko
			self.nixosModules.preservation

			# system programs
			self.nixosModules.ghostty
			self.nixosModules.niri
			self.nixosModules.noctalia
			self.nixosModules.neovim
			self.nixosModules.cursor
			self.nixosModules.tmux-nu
			self.nixosModules.nushell
			self.nixosModules.gnome-integration
			self.nixosModules.nix-ld
			self.nixosModules.sops
			self.nixosModules.userSecurity
			self.nixosModules.userSsh
			self.nixosModules.scanner
			self.nixosModules.swaylock-effects

			# user programs
			self.nixosModules.user-apps
			self.nixosModules.scientific-suite
		];

		jay.userSecurity = {
			sudo.u2f = {
				enable = true;
				unixFallback = false;
			};

			ssh.hosts."github.com".identities = [
				"github_yk2"
				"github_yk_nfc"
			];
		};

		services.logind.settings.Login = {
			HandleLidSwitch = "hibernate";
			HandleLidSwitchExternalPower = "suspend-then-hibernate";
			HandleLidSwitchDocked = "ignore";
		};

		systemd.sleep.settings.Sleep = {
			HibernateDelaySec = 240;
		};

		jay.swaylock-effects = {
			lockTimeout = 300;
			suspendTimeout = 360;
			suspend = true;
			hibernate = true;
		};

		boot.initrd.systemd.enable = true;

		boot.initrd.luks.devices.cryptroot = {
			device = "/dev/disk/by-partlabel/disk-main-root";
			crypttabExtraOpts = [
				"fido2-device=auto"
			];
		};
		boot.loader.systemd-boot.enable = true;
		boot.loader.efi.canTouchEfiVariables = true;

		networking.networkmanager.enable = true;
		networking.networkmanager.plugins = with pkgs; [ networkmanager-openconnect ];

		time.timeZone = "Europe/Vienna";


		services.power-profiles-daemon.enable = true;
		services.upower.enable = true;
		services.system76-scheduler.settings.cfsProfiles.enable = true;

		services.xserver.enable = true;
		services.displayManager.sddm = {
			enable = true;
			wayland.enable = true;
			theme = "sddm-astronaut-theme";
			extraPackages = [ custom-sddm-theme ];
		};
		services.displayManager = {
			enable = true;
			autoLogin = {
				enable = false;
				user = "jay";
			};
		};


		programs.niri = {
			enable = true;
		};
		programs.niri.custom = {
			outputMonitorName = "eDP-1";        # or "AU Optronics 0xD291 Unknown"
			outputMode        = "1920x1200@60.026";
			outputScaling     = 1.0;
			keyboardLayout     = "graphite";
			keyboardVariant    = "";
			keyboardModel      = "pc105";
			modKey             = "Alt";
		};
		programs.noctalia.systemMonitorBar.widthPercent = 30;

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
							rightalt = "leftalt";
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

		services.xserver.xkb = {
			layout = "graphite";
			variant = "";
			model = "pc105";
			extraLayouts.graphite = {
				description = "Graphite";
				languages = [ "eng" ];
				symbolsFile = graphiteXkbSymbols;
			};
		};
		console.useXkbConfig = true;

		hardware.pulseaudio.enable = false;
		security.rtkit.enable = true;
		services.pipewire = {
			enable = true;
			alsa.enable = true;
			alsa.support32Bit = true;
			pulse.enable = true;
		};

		hardware.bluetooth = {
			enable = true;
			powerOnBoot = false;
			settings = {
				General = {
					Experimental = true;
					FastConnectable = true;
				};
				Policy = {
					AutoEnable = true;
				};
			};
		};
		services.blueman.enable = true;
		hardware.enableAllFirmware = true;

		systemd.user.services.mpris-proxy = {
			description = "Mpris proxy";
			after = [ "network.target" "sound.target" ];
			wantedBy = [ "default.target" ];
			serviceConfig.ExecStart = "${pkgs.bluez}/bin/mpris-proxy";
		};

		virtualisation.docker.enable = true;
		users.users.jay = {
			hashedPasswordFile = config.sops.secrets.jay-password.path;
			isNormalUser = true; 
			extraGroups = [ "wheel" "networkmanager" "input" "audio" ];
			shell = self.packages.${pkgs.system}.zsh;
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
			gcc
			git 
			jujutsu
			keyd
			pavucontrol
			qemu
			tldr
			unzip
			ripgrep
			wget
			custom-sddm-theme
		];

		fonts.packages = with pkgs; [
			iosevka
			noto-fonts-color-emoji
		];

		nixpkgs.config = {
			allowUnfree = true;
		};

		services.openssh = {
			enable = true;
			settings = {
				PasswordAuthentication = false;
				KbdInteractiveAuthentication = false;
				PermitRootLogin = "no";
				X11Forwarding = false;
				AllowTcpForwarding = false;
			};
			extraConfig = ''
			UseDNS no
			'';
		};

		system.stateVersion = "26.05";

		nix.settings = {
			experimental-features = [ "nix-command" "flakes" ];
			substituters = [
				"https://cache.nixos.org/"
				"https://hyprland.cachix.org"
				"https://nix-community.cachix.org"
			];
			trusted-public-keys = [
				"nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
			];
		};
	};
}
