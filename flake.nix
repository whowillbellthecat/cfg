{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-22.05";
    nixpkgs_head.url = "nixpkgs";
    impermanence = {
      type = "github";
      owner = "nix-community";
      repo = "impermanence";
    };
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs_head,
    impermanence,
  } @ inputs: {
    formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.alejandra;
    nixosConfigurations.sotto-voce = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs.inputs = inputs;
      modules = [./configuration.nix impermanence.nixosModule];
    };
  };
}
