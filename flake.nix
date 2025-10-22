{
  description = "devazoa - a collection of bitcoin development environments";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/25.05";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        ./modules/devshells.nix
        ./modules/formatter.nix
      ];
    };
}
