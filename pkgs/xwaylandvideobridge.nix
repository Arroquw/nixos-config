{ stdenv, fetchFromGitLab, cmake, pkg-config, extra-cmake-modules, qt5
, libsForQt5, pkgs }:
pkgs.libsForQt5.callPackage({mkDerivation}: mkDerivation) {} rec {
  pname = "xwaylandvideobridge";
  version = "master";
  name = "${pname}-${version}";
  src = fetchFromGitLab {
    #https://invent.kde.org/system/xwaylandvideobridge.git
    domain = "invent.kde.org";
    owner = "system";
    repo = "xwaylandvideobridge";
    rev = "0698f6a95588222bb1ab6a9c5d760b1f6aaee5e0";
    hash = "sha256-gKkkwBPUpy6eN5MWk/5ivynxHuaFRClPdQkWBJytijI=";
  };

  nativeBuildInputs = [ cmake extra-cmake-modules pkg-config ];
  patches = [
    (pkgs.fetchpatch {
      url =
        "https://aur.archlinux.org/cgit/aur.git/plain/cursor-mode.patch?h=xwaylandvideobridge-cursor-mode-2-git";
      hash = "sha256-649kCs3Fsz8VCgGpZ952Zgl8txAcTgakLoMusaJQYa4=";
    })
  ];

  buildInputs = [
    qt5.qtbase
    qt5.qtquickcontrols2
    qt5.qtx11extras
    libsForQt5.kdelibs4support
    (libsForQt5.kpipewire.overrideAttrs (oldAttrs: {
      version = "unstable-2023-03-28";

      src = fetchFromGitLab {
        domain = "invent.kde.org";
        owner = "plasma";
        repo = "kpipewire";
        rev = "ed99b94be40bd8c5b7b2a2f17d0622f11b2ab7fb";
        hash = "sha256-KhmhlH7gaFGrvPaB3voQ57CKutnw5DlLOz7gy/3Mzms=";
      };
    }))
  ];
}
