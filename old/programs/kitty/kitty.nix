{pkgs, ... }:

{ 
	programs.kitty = {
		enable = true;

		settings = {
			scrollback_lines = 10000;
			placement_strategy = "center";

			allow_remote_control = "yes";
			enable_audio_bell = "no";
			visual_bell_duration = "0.0";

			copy_on_select = "clipboard";
		};

		shellIntegration.enableZshIntegration = true;

	};
}
