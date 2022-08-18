{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-22.05";
    nixpkgs_head.url = "nixpkgs";
    myConfig.url = "git+file:///data/src/config.git";
    impermanence = {
      type = "github";
      owner = "nix-community";
      repo = "impermanence";
    };
  };

  outputs = { self, nixpkgs, impermanence, ...}@inputs: {
    nixosConfigurations.sotto-voce = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs.inputs = inputs;
      modules = [ ./configuration.nix impermanence.nixosModule ];
    };
  };
}
