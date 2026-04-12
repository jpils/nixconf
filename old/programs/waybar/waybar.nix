{ pkgs, lib, inputs, ... }:

{
	programs.waybar = {
		enable = true;
		settings = {
			mainBar = {
				position = "top";
				height = 10;
				modules-left = [ "hyprland/workspaces" ];
				modules-right = [ "network" "battery" "clock" ];
				clock = {
				  format = "<span foreground='#f5c2e7'> </span>{:%a %d | %H:%M}";
				  tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
				};
				battery = {
					states = {
						warning = 25;
						critical = 10;
					};
					format = "<span size='13000' foreground='#a6e3a1'>{icon}</span> {capacity}%";
					format-warning = "<span size='13000' foreground='#B1E3AD'>{icon} </span> {capacity}%";
					format-critical = "<span size='13000' foreground='#E38C8F'> </span> {capacity}%";
					format-charging = "<span size='13000' foreground='#B1E3AD'>󰂄 </span>{capacity}%";
					format-plugged = "<span size='13000' foreground='#B1E3AD'> </span>{capacity}%";
					format-full = "<span size='13000' foreground='#B1E3AD'> </span>{capacity}%";
					format-icons = ["" "" "" "" ""];
					tooltip-format = "{time}";
				};
				network = {
					format-wifi = "<span size='13000' foreground='#f5e0dc'>󰖩 </span>{essid}";
					format-ethernet = "<span size='13000' foreground='#f5e0dc'>󰈁</span> LAN";
					format-linked = "{ifname} (No IP) ";
					format-disconnected = "<span size='13000' foreground='#f5e0dc'>󰖪 </span>Disconnected";
					tooltip-format-wifi = "Signal Strenght: {signalStrength}%";
				};
			};	
		};
	};
}
