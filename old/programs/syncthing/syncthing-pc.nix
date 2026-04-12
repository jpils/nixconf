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
				"laptop" = { id = "NJ2EMHW-PM3CV5E-UGU5KS6-IWQ6YS4-XC5VWUO-JRU6LFL-2R35DLI-OH7MRQL"; };
			};
			folders = {
				"Documents" = {
					path = "/home/jay/Documents";
					devices = [ "laptop" ];
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
