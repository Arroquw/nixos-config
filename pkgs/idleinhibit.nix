{ stdenv, fetchFromGitHub, meson, gcc, git, ninja, wayland-protocols, pkg-config
, lib, cmake, wayland, pulseaudio, ... }:
stdenv.mkDerivation (finalAttrs: {
  pname = "SwayAudioIdleInhibit";
  version = "c850bc4";

  src = fetchFromGitHub {
    owner = "ErikReider";
    repo = "SwayAudioIdleInhibit";
    rev = "c850bc4812216d03e05083c69aa05326a7fab9c7";
    hash = "sha256-MKzyF5xY0uJ/UWewr8VFrK0y7ekvcWpMv/u9CHG14gs=";
  };

  nativeBuildInputs = [ meson ninja gcc git pkg-config cmake ];

  buildInputs = [ wayland-protocols wayland pulseaudio ];

  meta = {
    description = "";
    homepage = "";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ ];
  };
})
