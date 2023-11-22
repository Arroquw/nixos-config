{ lib, gnumake, libusb1, pkg-config, stdenv, gcc, coreutils, fetchFromGitHub }:
stdenv.mkDerivation (finalAttrs: rec {
  pname = "SF100Linux";
  version = "master";

  src = fetchFromGitHub {
    owner = "DediProgSW";
    repo = "SF100Linux";
    rev = "${version}";
    hash = "sha256-aho9MOnUXNZBMYoWhPY+252QYnY+V9Ex0/kNju5sFco=";
  };

  nativeBuildInputs = [ gnumake pkg-config gcc coreutils ];

  buildInputs = [ libusb1 ];

  installPhase = ''
      mkdir -p $out/bin $out/share/DediProg
      mkdir -p $out/etc/udev/rules.d
    	install -v -Dm 0755 dpcmd $out/bin/dpcmd
    	strip $out/bin/dpcmd
    	install -v -Dm 0644 ChipInfoDb.dedicfg $out/share/DediProg/ChipInfoDb.dedicfg
    	install -v -Dm 0644 60-dediprog.rules $out/etc/udev/rules.d/60-dediprog.rules
  '';

  meta = {
    description =
      "Linux software for Dediprog SF100 and SF600 SPI flash programmers";
    homepage = "https://www.dediprog.com/";
    license = lib.licenses.gpl2;
    maintainers = with lib.maintainers; [ arroquw ];
  };
})
