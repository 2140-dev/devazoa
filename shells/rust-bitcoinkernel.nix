{ pkgs, system }:

let
  bitcoinCoreShell = import ./bitcoin-core.nix { inherit pkgs system; };
in

pkgs.mkShell {
  nativeBuildInputs = bitcoinCoreShell.nativeBuildInputs ++ (with pkgs; [
    rustc
    cargo
    clippy
    rustfmt
    llvmPackages_19.libclang
  ]);

  buildInputs = bitcoinCoreShell.buildInputs;

  shellHook = ''
    ${bitcoinCoreShell.shellHook}

    export LIBCLANG_PATH="${pkgs.llvmPackages_19.libclang.lib}/lib"
  '';
}
