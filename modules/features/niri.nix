{ self, inputs, ... }: {
	flake.nixosModules.niri = { pkgs, lib, ... }: {
		programs.niri = { 
			enable = true;
			package = self.packages.${pkgs.stdenv.hostPlatform.system}.niri;
		};
	};

	perSystem = { pkgs, lib, self', ... }: {
		packages.niri = inputs.wrapper-modules.wrappers.niri.wrap {
			inherit pkgs;
			settings = let 
				noctaliaExe = lib.getExe self'.packages.noctalia;
				zenExe = lib.getExe inputs.zen-browser.packages.${pkgs.system}.default;
				ghosttyExe = lib.getExe self'.packages.ghostty;
			in {
				prefer-no-csd = _: {};
				hotkey-overlay.skip-at-startup = true;

				spawn-at-startup = [
					noctaliaExe
					(lib.getExe (
					    pkgs.writeShellScriptBin "wallpaper"
					    "${lib.getExe pkgs.swaybg} -i ${self.wallpaper} -m fill"
					))
				];

				xwayland-satellite.path = lib.getExe pkgs.xwayland-satellite;

				input = {
					keyboard = {
					xkb.layout = "us";
					xkb.variant = "dvorak";
					};
					touchpad = {
						tap = _: {};              
						natural-scroll = _: {};  
					};
				};

				outputs."eDP-1" = {
					mode = "1920x1200"; 
					scale = 1.0; 
				};

				layout = {
					gaps = 5;
					default-column-width = { proportion = 0.5; }; 
					center-focused-column = "on-overflow";
					always-center-single-column = true;

					focus-ring = {
						width = 2;
					};
				};

				binds = {
					"Mod+S".spawn-sh = "${lib.getExe self'.packages.noctalia} ipc call launcher toggle";
					"Mod+Return".spawn-sh = ghosttyExe;
					"Mod+C".close-window = _: {};
					
					# focus windows
					"Mod+H".focus-column-left = _: {};
					"Mod+L".focus-column-right = _: {};
					"Mod+K".focus-window-up = _: {};
					"Mod+J".focus-window-down = _: {};
					
					# move windows
					"Mod+Ctrl+H".move-column-left = _: {};
					"Mod+Ctrl+L".move-column-right = _: {};
					"Mod+Ctrl+K".move-window-up = _: {};
					"Mod+Ctrl+J".move-window-down = _: {};
					
					# consume / expel
					"Mod+Shift+L".consume-or-expel-window-left = _: {};
					"Mod+Shift+H".consume-or-expel-window-right = _: {};
					
					# workspaces
					"Mod+1".focus-workspace = 1;
					"Mod+2".focus-workspace = 2;
					"Mod+3".focus-workspace = 3;
					"Mod+4".focus-workspace = 4;
					"Mod+5".focus-workspace = 5;
					
					# move window to workspace
					"Mod+Ctrl+1".move-column-to-workspace = 1;
					"Mod+Ctrl+2".move-column-to-workspace = 2;
					"Mod+Ctrl+3".move-column-to-workspace = 3;
					"Mod+Ctrl+4".move-column-to-workspace = 4;
					"Mod+Ctrl+5".move-column-to-workspace = 5;
					
					# relative workspace navigation
					"Mod+Page_Down".focus-workspace-down = _: {};
					"Mod+Page_Up".focus-workspace-up = _: {};
					"Mod+Shift+Page_Down".move-column-to-workspace-down = _: {};
					"Mod+Shift+Page_Up".move-column-to-workspace-up = _: {};
					
					# view modes
					"Mod+F".fullscreen-window = _: {};
					"Mod+Shift+C".center-column = _: {};
					
					# window size presets
					"Mod+7".set-column-width = "33.3%";
					"Mod+8".set-column-width = "50%";
					"Mod+9".set-column-width = "66.6%";
					"Mod+0".set-column-width = "100%"; 

					# audio controls
					"XF86AudioRaiseVolume" = _: {
						props.allow-when-locked = true;
						content.spawn = [ "${pkgs.wireplumber}/bin/wpctl" "set-volume" "-l" "1.5" "@DEFAULT_AUDIO_SINK@" "5%+" ];
					};
					"XF86AudioLowerVolume" = _: {
						props.allow-when-locked = true;
						content.spawn = [ "${pkgs.wireplumber}/bin/wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%-" ];
					};
					"XF86AudioMute" = _: {
						props.allow-when-locked = true;
						content.spawn = [ "${pkgs.wireplumber}/bin/wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle" ];
					};
					"XF86AudioMicMute" = _: {
						props.allow-when-locked = true;
						content.spawn = [ "${pkgs.wireplumber}/bin/wpctl" "set-mute" "@DEFAULT_AUDIO_SOURCE@" "toggle" ];
					};

					# brightness controls
					"XF86MonBrightnessUp" = _: {
						props.allow-when-locked = true;
						content.spawn = [ (lib.getExe pkgs.brightnessctl) "set" "5%+" ];
					};
					"XF86MonBrightnessDown" = _: {
						props.allow-when-locked = true;
						content.spawn = [ (lib.getExe pkgs.brightnessctl) "set" "5%-" ];
					};

					# application shortcuts
					"Mod+W".spawn-sh = zenExe;
					"Mod+D".spawn-sh = "discord";
					"Mod+T".spawn-sh = "telegram-desktop";
					
					# File Manager
					"Mod+E".spawn-sh = "nautilus";
				};

				window-rules = [
					{
						geometry-corner-radius = 8;
						clip-to-geometry = true;
					}
					{
						matches = [{ app-id = "^zen$"; }];
						default-column-width = { proportion = 0.7; };
					}
					{
						matches = [{ app-id = "^discord$"; }];
						default-column-width = { proportion = 0.5; };
					}
					{
						matches = [{ app-id = "^org.telegram.desktop$"; }];
						default-column-width = { proportion = 0.5; };
					}
				];
			};
		};
	};
}
