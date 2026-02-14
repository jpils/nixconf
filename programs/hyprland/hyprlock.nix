{ config, pkgs, lib, ... }:

let
  wallpaper = ../../Wallpapers/mandelbrot.png;
in {
  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        disable_loading = true;
        grace = 0;
        hide_cursor = false;
        # These ensure the fade happens
        no_fade_in = false;
        no_fade_out = false;
      };

      # Animation configuration
      animations = {
        enabled = true;
        bezier = "linear, 1, 1, 0, 0";
        animation = [
          "fadeIn, 1, 7, linear"
          "fadeOut, 1, 7, linear"
        ];
      };

      background = lib.mkForce [
        {
          monitor = "";
          path = "${wallpaper}";
          blur_passes = 2; 
          blur_size = 7;
          noise = 0.0117;
          contrast = 0.8916;
          brightness = 0.7; # Slightly darker to make the UI pop
          vibrancy = 0.1696;
          vibrancy_darkness = 0.0;
        }
      ];

      input-field = lib.mkForce [
        {
          monitor = "";
          size = "250, 60";
          outline_thickness = 2;
          dots_size = 0.2;
          dots_spacing = 0.2;
          dots_center = true;
          outer_color = "rgba(0, 0, 0, 0)";
          inner_color = "rgba(255, 255, 255, 0.1)";
          font_color = "rgb(200, 200, 200)";
          fade_on_empty = false;
          placeholder_text = "<i>Password...</i>";
          hide_input = false;
          position = "0, -120";
          halign = "center";
          valign = "center";
        }
      ];

      label = lib.mkForce [
        {
          monitor = "";
          text = "$TIME";
          font_size = 120;
          font_family = "Sans Bold";
          position = "0, 80";
          halign = "center";
          valign = "center";
        }
      ];
    };
  };
}
