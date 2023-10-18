{ fetchFromGitLab, cmake, pkg-config, extra-cmake-modules, qt5, libsForQt5, pkgs
}:
pkgs.libsForQt5.callPackage ({ mkDerivation }: mkDerivation) { } rec {
  pname = "xwaylandvideobridge";
  version = "master";
  name = "${pname}-${version}";
  src = fetchFromGitLab {
    #https://invent.kde.org/system/xwaylandvideobridge.git
    domain = "invent.kde.org";
    owner = "system";
    repo = "xwaylandvideobridge";
    rev = "5fc478055607748bdca5f4f0e3b6441900cf2b75";
    hash = "sha256-2AMssUaQoAPEL7yppWkw0Wp9l2ep7SOL7byNCTyuNBY=";
  };

  nativeBuildInputs = [ cmake extra-cmake-modules pkg-config ];

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
