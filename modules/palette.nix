let
theme = {
	bg = "#2e3440";
	fg = "#e5e9f0";
	selectionBg = "#434c5e";

	base00 = "#2e3440";
	base01 = "#bf616a";
	base02 = "#a3be8c";
	base03 = "#ebcb8b";
	base04 = "#81a1c1";
	base05 = "#b48ead";
	base06 = "#88c0d0";
	base07 = "#e5e9f0";
	base08 = "#4c566a";
	base09 = "#bf616a";
	base10 = "#a3be8c";
	base11 = "#ebcb8b";
	base12 = "#81a1c1";
	base13 = "#b48ead";
	base14 = "#88c0d0";
	base15 = "#8fbcbb";
};

stripHash = str:
if builtins.substring 0 1 str == "#"
then builtins.substring 1 (builtins.stringLength str - 1) str
else str;

themeNoHash = builtins.mapAttrs (_: v: stripHash v) theme;
in {
	flake = {
		inherit theme themeNoHash;
	};
}
