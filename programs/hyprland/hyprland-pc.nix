{pkgs, lib, inputs, ... }:

let
	wallpaper = ../../Wallpapers/mandelbrot.png;
	startupScript = pkgs.pkgs.writeShellScriptBin "start" ''
		swww img ${wallpaper} &
		waybar &
	'';
in {
	home.packages = with pkgs; [
		swww
		bibata-cursors
		hyprshot
	];

	services.swww.enable = true;

	wayland.windowManager.hyprland = {
		enable = true;
		package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;

		settings = {

			exec-once = [
				"${startupScript}/bin/start"
			];

			monitor = [
				", 2560x1440@165, auto, 1"
			];

			"$terminal" = "kitty";
			"$filebrowser" = "thunar";

			env = [
				"QT_QPA_PLATFORM,wayland"
				"QT_QPA_PLATFORMTHEME,qt5ct"
			];
			
			general = { 
				gaps_in = 5;
				gaps_out = 5;

				border_size = 2;

				resize_on_border = false;

				allow_tearing = false;

				layout = "dwindle";
			};

			decoration = {
				rounding = 10;

				active_opacity = 1.0;
				inactive_opacity = 1.0;

				shadow = {
					enabled = true;
					range = 4;
					render_power = 3;
				};

				blur = {
					enabled = true;
					size = 3;
					passes = 1;

					vibrancy = 0.1696;
				};
			};

			animations = {
				enabled = false;

				bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";

				animation = [
					"windows, 1, 7, myBezier"
					"windowsOut, 1, 7, default, popin 80%"
					"border, 1, 10, default"
					"borderangle, 1, 8, default"
					"fade, 1, 7, default"
					"workspaces, 1, 6, default"
				];
			};

			dwindle = {
				pseudotile = true;
				preserve_split = true; 
			};

			master = {
				new_status = "master";
			};

			misc = { 
				disable_hyprland_logo = true;
				vrr = 2;
			};

			input = {
				kb_layout = "us";
				kb_variant = "";

				follow_mouse = 1;

				sensitivity = 0; 

				touchpad = {
					natural_scroll = false;
				};
			};

			device = {
				name = "epic-mouse-v1";
				sensitivity = -0.5;
			};


			"$super" = "SUPER"; 

			bind = [
				"$super, RETURN, exec, $terminal"

				"$super, W, exec, firefox"
				"$super, C, killactive,"
				"$super, E, exec, $fileManager"
				"$super, F, togglefloating,"
				"$super, R, exec, $menu"
				"$super, P, pseudo, # dwindle"
				"$super, J, togglesplit, # dwindle"
				"$super, D, exec, rofi -modi drun -show drun -show-icons -config ~/.config/rofi/rofidmenu.rasi"

				"$super, H, movefocus, l"
				"$super, L, movefocus, r"
				"$super, K, movefocus, u"
				"$super, J, movefocus, d"

				"$super, 1, workspace, 1"
				"$super, 2, workspace, 2"
				"$super, 3, workspace, 3"
				"$super, 4, workspace, 4"
				"$super, 5, workspace, 5"
				"$super, 6, workspace, 6"
				"$super, 7, workspace, 7"
				"$super, 8, workspace, 8"
				"$super, 9, workspace, 9"
				"$super, 0, workspace, 10"

				"$super shift, 1, movetoworkspace, 1"
				"$super shift, 2, movetoworkspace, 2"
				"$super shift, 3, movetoworkspace, 3"
				"$super shift, 4, movetoworkspace, 4"
				"$super shift, 5, movetoworkspace, 5"
				"$super shift, 6, movetoworkspace, 6"
				"$super shift, 7, movetoworkspace, 7"
				"$super shift, 8, movetoworkspace, 8"
				"$super shift, 9, movetoworkspace, 9"
				"$super shift, 0, movetoworkspace, 10"

				"$super shift, H, movewindow, l"
				"$super shift, L, movewindow, r"
				"$super shift, J, movewindow, d"
				"$super shift, K, movewindow, u"

				"$super, M, togglespecialworkspace, magic"
				"$super shift, M, movetoworkspace, special:magic"

				"$super, mouse_down, workspace, e+1"
				"$super, mouse_up, workspace, e-1"

				", F11, fullscreen, 0"

				"$super, PRINT, exec, hyprshot -m window -o ~/PicturesScreenshots"
				", PRINT, exec, hyprshot -m output -o ~/Pictures/Screenshots/"
				"$super shift, PRINT, exec, hyprshot -m region -o ~/Pictures/Screenshots/"
			];

			bindm = [
				"$super, mouse:272, movewindow"
				"$super, mouse:273, resizewindow"
			];

			binde = [
				", XF86AudioRaiseVolume, exec, wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+"
				", XF86AudioLowerVolume, exec, wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%-"
				", XF86AudioMute, exec, wpctl set-mute @DEFAULT_SINK@ toggle"
				", XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_SOURCE@ toggle"
				", XF86MonBrightnessUp, exec, brightnessctl set +10%"
				", XF86MonBrightnessDown, exec, brightnessctl set 10%-"
			];

			bindl = [
				", XF86AudioPlay, exec, playerctl play-pause"
				", XF86AudioPrev, exec, playerctl previous"
				", XF86AudioNext, exec, playerctl next"
			];


			windowrule = [
				"suppressevent maximize, class:.*"
				"workspace 1, class:(kitty)$, title:(kitty)$"
				"workspace 2, initialTitle:(Mozilla Firefox)$"
				"workspace 5, class:(org.telegram.desktop)$, initialTitle:(Telegram)$"
				"float, class:(org.telegram.desktop)$, initialTitle:^(?!.*Telegram*.)$"
				"workspace 5, class:(whatsapp-for-linux)$"
				"workspace 7, class:(webcord)$, title:(webcord)$"
				"workspace 9, initialTitle:^(Spotify( Premium)?)$"

				"opacity 0.0 override, class:^(xwaylandvideobridge)$"
				"noanim, class:^(xwaylandvideobridge)$"
				"noinitialfocus, class:^(xwaylandvideobridge)$"
				"maxsize 1 1, class:^(xwaylandvideobridge)$"
				"noblur, class:^(xwaylandvideobridge)$"
			];
		};

		extraConfig = ''
			bind = $super, R, submap, resize

			submap = resize
			binde = , L, resizeactive, 20 0
			binde = , H, resizeactive, -20 0
			binde = , J, resizeactive, 0 20
			binde = , K, resizeactive, 0 -20
			bind = , escape, submap, reset
			submap = reset
		'';
	};
}
