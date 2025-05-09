{ lib, ... }:

{
  systems = [
    "x86_64-linux"
    "aarch64-darwin"
  ];

  perSystem = { system, pkgs, ... }: {
    devShells = {
      default = pkgs.mkShell {
        packages = with pkgs; [ nix git ];
      };

      bitcoin-core = import ../shells/bitcoin-core.nix { inherit pkgs system; };
      rust-bitcoinkernel = import ../shells/rust-bitcoinkernel.nix { inherit pkgs system; };
    };
  };
}
