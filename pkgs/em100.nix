{ lib, gnumake, libusb1, pkg-config, stdenv, gcc, curl, fetchgit }:
stdenv.mkDerivation (finalAttrs: rec {
  pname = "em100";
  version = "main";

  src = fetchgit {
    url = "https://review.coreboot.org/em100";
    rev = "b59e9a2a8020598dddc824feef217ec48b498beb";
    hash = "sha256-JDgzJgUfDl42W0SnPLU82mcmUAqqJF73oCbVRMrRjCw=";
  };

  nativeBuildInputs = [ gnumake pkg-config gcc ];
  buildInputs = [ libusb1 curl ];

  outputs = [ "out" "etc" ];

  installPhase = ''
      mkdir -p $etc $out
    	install -Dm 644 60-dediprog-em100pro.rules $etc/udev/rules.d/60-dediprog-em100pro.rules
    	install -Dm 740 em100 $out/bin/em100
  '';

  meta = {
    description =
      "This open source tool allows operating a Dediprog EM100Pro SPI NOR Flash Emulator under Linux and OSX";
    homepage = "https://review.coreboot.org/q/project:em100";
    license = lib.licenses.gpl2;
    maintainers = with lib.maintainers; [ arroquw ];
  };
})
