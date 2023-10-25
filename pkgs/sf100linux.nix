{ lib, gnumake, libusb1, pkg-config, stdenv, gcc, fetchFromGitHub }:
stdenv.mkDerivation (finalAttrs: rec {
  pname = "SF100Linux";
  version = "master";

  src = fetchFromGitHub {
    owner = "DediProgSW";
    repo = "SF100Linux";
    rev = "${version}";
    hash = "sha256-aho9MOnUXNZBMYoWhPY+252QYnY+V9Ex0/kNju5sFco=";
  };

  patches = [ ./sf100linux-remove-unpermitted-commands.patch ];

  nativeBuildInputs = [ gnumake pkg-config gcc ];

  buildInputs = [ libusb1 ];

  outputs = [ "out" "share" "etc" ];

  installPhase = ''
      mkdir -p $out/bin $share/DediProg
      mkdir -p $etc/udev/rules.d
    	install -Dm 0755 dpcmd $out/bin/dpcmd
    	strip $out/bin/dpcmd
    	install -Dm 0644 ChipInfoDb.dedicfg $share/DediProg/ChipInfoDb.dedicfg
    	install -Dm 0644 60-dediprog.rules $etc/udev/rules.d/60-dediprog.rules
  '';

  meta = {
    description =
      "Linux software for Dediprog SF100 and SF600 SPI flash programmers";
    homepage = "https://www.dediprog.com/";
    license = lib.licenses.gpl2;
    maintainers = with lib.maintainers; [ arroquw ];
  };
})
