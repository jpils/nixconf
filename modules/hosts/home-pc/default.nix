{self, inputs, ... }: {
	flake.nixosConfigurations.homePc = inputs.nixpkgs.lib.nixosSystem {
		modules = [ 
			self.nixosModules.homePcConfiguration
		];
	};
}
