{ pkgs, system }:

let
  isLinux = pkgs.stdenv.isLinux;
  lib = pkgs.lib;

  commonNativeBuildInputs = with pkgs; [
    byacc
    ccache
    clang-tools_19
    clang_19
    cmake
    gcc14
    gnum4
    gnumake
    ninja
    pkg-config
    qt6.wrapQtAppsHook
  ];

  linuxNativeBuildInputs = with pkgs; [
    libsystemtap
    linuxPackages.bcc
    linuxPackages.bpftrace
    python312Packages.bcc
  ];

  nativeBuildInputs = commonNativeBuildInputs ++ (if isLinux then linuxNativeBuildInputs else [ ]);

  pythonEnv = pkgs.python312.withPackages (ps: with ps; [
    flake8
    lief
    mypy
    pyzmq
    vulture
  ]);

  commonBuildInputs = with pkgs; [
    boost
    capnproto
    codespell
    db4
    hexdump
    libevent
    qrencode
    qt6.qtbase
    qt6.qttools
    sqlite
    uv
    zeromq
    pythonEnv
  ];

  linuxBuildInputs = with pkgs; [ python312Packages.bcc ];

  buildInputs = commonBuildInputs ++ (if isLinux then linuxBuildInputs else [ ]);

  shellHook = ''
    export CC=clang
    export CXX=clang++
    export CMAKE_GENERATOR=Ninja
  '';
in

pkgs.mkShell {
  LD_LIBRARY_PATH = lib.makeLibraryPath [ pkgs.gcc14.cc pkgs.capnproto ];
  LOCALE_ARCHIVE = "${pkgs.glibcLocales}/lib/locale/locale-archive";
  QT_PLUGIN_PATH = "${pkgs.qt6.qtbase}/${pkgs.qt6.qtbase.qtPluginPrefix}";
  inherit nativeBuildInputs buildInputs shellHook;
}
