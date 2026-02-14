{ pkgs, lib, ... }:

{
  services.hypridle = {
    enable = true;
    settings = {
      general = {
        # Avoid starting multiple hyprlock instances
        lock_cmd = "pidof hyprlock || hyprlock";
        # Lock before the system goes to sleep
        before_sleep_cmd = "loginctl lock-session";
        # Turn on display when waking up
        after_sleep_cmd = "hyprctl dispatch dpms on";
      };

      listener = [
        {
          # 5 minutes: Lock screen
          timeout = 300;
          on-timeout = "loginctl lock-session";
        }
        {
          # 5.5 minutes: Turn off screen (DPMS)
          timeout = 330;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
        {
          # 30 minutes: Suspend PC
          timeout = 600;
          on-timeout = "systemctl suspend";
        }
      ];
    };
  };
}
