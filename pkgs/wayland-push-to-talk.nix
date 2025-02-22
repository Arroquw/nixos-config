{ stdenv, fetchFromGitHub, lib, gcc, libevdev, xdotool, pkg-config, libX11, ...
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "wayland-push-to-talk-fix";
  version = "490f430";

  src = fetchFromGitHub {
    owner = "Rush";
    repo = "wayland-push-to-talk-fix";
    rev = "490f43054453871fe18e7d7e9041cfbd0f1d9b7d";
    hash = "sha256-ZRSgrQHnNdEF2PyaflmI5sUoKCxtZ0mQY/bb/9PH64c=";
  };

  buildInputs = [ libevdev pkg-config gcc xdotool libX11 ];

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/share/applciations
    install -v -Dm 0755 push-to-talk $out/bin/push-to-talk
    install -v -Dm 0644 push-to-talk.desktop $out/share/applications/push-to-talk.desktop
  '';

  meta = {
    description = "";
    homepage = "";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ arroquw ];
  };
})
