{ config, pkgs, lib, ... }:

{
	xdg.configFile = {
		"cosmic/com.system76.CosmicSettings.Wallpaper/v1/custom-images".text = ''
			[
				"/home/jay/.dotfiles/Wallpapers/mandelbrot.png",
			]
		'';

		"cosmic/com.system76.CosmicBackground/v1/all".text = ''
			(
				output: "all",
				source: Path("/home/jay/.dotfiles/Wallpapers/mandelbrot.png"),
				filter_by_theme: true,
				rotation_frequency: 300,
				filter_method: Lanczos,
				scaling_mode: Zoom,
				sampling_method: Alphanumeric,
			)
		'';

		"cosmic/com.system76.CosmicComp/v1/autotile".text = ''
			(
			 true
			)
		'';

		"cosmic/com.system76.CosmicComp/v1/autotile_behavior".text = ''
			(
			 PerWorkspace
			)
		'';

		"cosmic/com.system76.CosmicComp/v1/pinned_workspaces".text = ''
[
    (
        output: (
            name: "eDP-1",
            edid: Some((
                manufacturer: ('A', 'U', 'O'),
                product: 53905,
                serial: None,
                manufacture_week: 22,
                manufacture_year: 2020,
                model_year: None,
            )),
        ),
        tiling_enabled: true,
        id: Some("380be"),
    ),
    (
        output: (
            name: "eDP-1",
            edid: Some((
                manufacturer: ('A', 'U', 'O'),
                product: 53905,
                serial: None,
                manufacture_week: 22,
                manufacture_year: 2020,
                model_year: None,
            )),
        ),
        tiling_enabled: true,
        id: Some("7b340c"),
    ),
    (
        output: (
            name: "eDP-1",
            edid: Some((
                manufacturer: ('A', 'U', 'O'),
                product: 53905,
                serial: None,
                manufacture_week: 22,
                manufacture_year: 2020,
                model_year: None,
            )),
        ),
        tiling_enabled: true,
        id: Some("589e03"),
    ),
    (
        output: (
            name: "eDP-1",
            edid: Some((
                manufacturer: ('A', 'U', 'O'),
                product: 53905,
                serial: None,
                manufacture_week: 22,
                manufacture_year: 2020,
                model_year: None,
            )),
        ),
        tiling_enabled: true,
        id: Some("182019f"),
    ),
    (
        output: (
            name: "eDP-1",
            edid: Some((
                manufacturer: ('A', 'U', 'O'),
                product: 53905,
                serial: None,
                manufacture_week: 22,
                manufacture_year: 2020,
                model_year: None,
            )),
        ),
        tiling_enabled: true,
        id: Some("171f7f5"),
    ),
    (
        output: (
            name: "eDP-1",
            edid: Some((
                manufacturer: ('A', 'U', 'O'),
                product: 53905,
                serial: None,
                manufacture_week: 22,
                manufacture_year: 2020,
                model_year: None,
            )),
        ),
        tiling_enabled: true,
        id: Some("b0a086"),
    ),
    (
        output: (
            name: "eDP-1",
            edid: Some((
                manufacturer: ('A', 'U', 'O'),
                product: 53905,
                serial: None,
                manufacture_week: 22,
                manufacture_year: 2020,
                model_year: None,
            )),
        ),
        tiling_enabled: true,
        id: Some("f3271"),
    ),
    (
        output: (
            name: "eDP-1",
            edid: Some((
                manufacturer: ('A', 'U', 'O'),
                product: 53905,
                serial: None,
                manufacture_week: 22,
                manufacture_year: 2020,
                model_year: None,
            )),
        ),
        tiling_enabled: true,
        id: Some("177e7db"),
    ),
    (
        output: (
            name: "eDP-1",
            edid: Some((
                manufacturer: ('A', 'U', 'O'),
                product: 53905,
                serial: None,
                manufacture_week: 22,
                manufacture_year: 2020,
                model_year: None,
            )),
        ),
        tiling_enabled: false,
        id: Some("8b6af5"),
    ),
]
		'';

		"cosmic/com.system76.CosmicTerm/v1/show_headerbar".text = ''
			false
		'';

		"cosmic/com.system76.CosmicPanel.Panel/v1/plugins_wings".text = ''
			Some(([
				"com.system76.CosmicAppletWorkspaces",
			], [
				"com.system76.CosmicAppletInputSources",
				"com.system76.CosmicAppletStatusArea",
				"com.system76.CosmicAppletTiling",
				"com.system76.CosmicAppletAudio",
				"com.system76.CosmicAppletBluetooth",
				"com.system76.CosmicAppletNetwork",
				"com.system76.CosmicAppletBattery",
				"com.system76.CosmicAppletNotifications",
				"com.system76.CosmicAppletPower",
			]))
		'';

		"cosmic/com.system76.CosmicPanel.Dock/v1/anchor".text = ''
			Left
		'';

		"cosmic/com.system76.CosmicPanel.Dock/v1/autohide".text = ''
			Some((
				wait_time: 500,
				transition_time: 200,
				handle_size: 2,
				unhide_delay: 200,
			))
		'';
	};

}
