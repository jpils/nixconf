{pkgs, ... }:

{
	home.packages = with pkgs; [
		bottles
		wine
		vulkan-tools
		lutris
		libGL
		libGLU
	];
}
