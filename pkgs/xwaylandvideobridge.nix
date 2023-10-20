{ stdenv, fetchFromGitLab, cmake, extra-cmake-modules, pkg-config, qtbase
, qtquickcontrols2, qtx11extras, kdelibs4support, kpipewire, wrapQtAppsHook }:

stdenv.mkDerivation (finalAttrs: {
  pname = "xwaylandvideobridge";
  version = "master";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "system";
    repo = "xwaylandvideobridge";
    rev = "5fc478055607748bdca5f4f0e3b6441900cf2b75";
    hash = "sha256-2AMssUaQoAPEL7yppWkw0Wp9l2ep7SOL7byNCTyuNBY=";
  };

  nativeBuildInputs = [ cmake extra-cmake-modules pkg-config wrapQtAppsHook ];

  buildInputs =
    [ qtbase qtquickcontrols2 qtx11extras kdelibs4support kpipewire ];
})
