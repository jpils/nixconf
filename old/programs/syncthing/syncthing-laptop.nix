{ pkgs, ... }: 

{
	services.syncthing = {
		enable = true;
		user = "jay";
		dataDir = "/home/jay/Documents/";
		configDir =	"/home/jay/.config/syncthing";
		overrideDevices = true;
		overrideFolders = true;
		settings = {
			devices = {
				"pc" = { id = "RLN737H-BCBLOGZ-DTHW4Y3-QWFOYBZ-THVPAAC-2OCGZQ2-6TPY5IP-SUKAEAK"; };
			};
			folders = {
				"Documents" = {
					path = "/home/jay/Documents";
					devices = [ "pc" ];
					versioning = {
						type = "staggered";
						fsPath = "/home/jay/.Documents_backup/";
						params = {
							cleanInterval = "3600";
							maxAge = "15552000";
						};
					};
				};
			};
		};
	};
	
	networking.firewall.allowedTCPPorts = [ 8384 22000 ];
	networking.firewall.allowedUDPPorts = [ 22000 21027 ];
}
