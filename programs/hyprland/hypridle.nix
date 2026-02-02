{ pkgs, lib, ... }:

{
  services.hypridle = {
    enable = true;
    settings = {
      general = {
        # Avoid starting multiple hyprlock instances
        lock_cmd = "pidof hyprlock --grace 5 || hyprlock --grace 5";
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
          # 6 minutes: Turn off screen (DPMS)
          timeout = 360;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
        {
          # 30 minutes: Suspend PC
          timeout = 1800;
          on-timeout = "systemctl suspend";
        }
      ];
    };
  };
}
