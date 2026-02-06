{
	description = "main setup";

	inputs = {
		nixpkgs.url = "nixpkgs/nixos-unstable";
		home-manager.url = "github:nix-community/home-manager/master";
		home-manager.inputs.nixpkgs.follows = "nixpkgs";
		hyprland = {
			url = "github:hyprwm/Hyprland";
		};
		hyprland-plugins = {
			url = "github:hyprwm/hyprland-plugins";
			inputs.hyprland.follows = "hyprland";
		};
		stylix.url = "github:danth/stylix";
		matugen.url = "github:InioX/matugen?ref=v2.2.0";
		flake-utils.url  = "github:numtide/flake-utils";
	    astal.url = "github:aylur/astal";
		ags.url = "github:aylur/ags"; 
	};

	outputs = { self, nixpkgs, home-manager, flake-utils, ... }@inputs: 
		let 
			lib = nixpkgs.lib;
			system = "x86_64-linux";
			pkgs = import nixpkgs { 
				system = "x86_64-linux"; 
				config = { allowUnfree = true; }; 
			};
			commonConfiguration = ./profiles/personal/configuration.nix;
			commonHomeConfiguration = ./profiles/personal/home.nix;
		in {
			nixosConfigurations = {
				pc = lib.nixosSystem {
					specialArgs = { inherit inputs; };
					inherit system; 
					modules = [
						commonConfiguration
						./hardware/hardware-configuration-pc.nix
						./hardware/data_drive/data_drive_home.nix
						./programs/syncthing/syncthing-pc.nix
						./profiles/personal/is-pc.nix
						./nvidia/gaming.nix
						./programs/openrgb/openrgb.nix
					];
				};
				laptop = lib.nixosSystem {
					specialArgs = { inherit inputs; };
					inherit system; 
					modules = [
						commonConfiguration
						./hardware/hardware-configuration-laptop.nix
						./programs/syncthing/syncthing-laptop.nix
						./suspend-then-hibernate.nix
						./profiles/personal/is-laptop.nix
						./programs/tlp/tlp.nix
					];
				};
				office-pc = lib.nixosSystem {
					specialArgs = { inherit inputs; };
					inherit system; 
					modules = [
						commonConfiguration
						./hardware/hardware-configuration-office.nix
						./hardware/data_drive/data_drive_office.nix
						./profiles/personal/is-pc.nix
						./nvidia/office_nvidia.nix
					];
				};
			};
			homeConfigurations = {
				jay-pc = home-manager.lib.homeManagerConfiguration {
					inherit pkgs;
					extraSpecialArgs = { inherit inputs; };
					modules = [ 
						commonHomeConfiguration
						./programs/gaming/proton/proton.nix
						./programs/gaming/bottles/bottles.nix
						./programs/gaming/waydroid/waydroid.nix
						./programs/hyprland/hyprland-pc.nix
					];
				};
				jay-laptop = home-manager.lib.homeManagerConfiguration {
					inherit pkgs;
					extraSpecialArgs = { inherit inputs; };
					modules = [ 
						commonHomeConfiguration
						./programs/hyprland/hyprland-laptop.nix
					];
				};
				office-pc = home-manager.lib.homeManagerConfiguration {
					inherit pkgs;
					extraSpecialArgs = { inherit inputs; };
					modules = [ 
						./profiles/office/home.nix 
						./programs/hyprland/hyprland-pc-office.nix
					];
				};
			};
		};

}
