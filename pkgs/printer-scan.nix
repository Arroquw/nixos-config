{ lib, stdenv, fetchurl, cups, dpkg, gnused, makeWrapper, ghostscript, a2ps
, coreutils, gnugrep, gawk }:
let
  version = "4.0.0";
  model = "dcpl2530dw";
in stdenv.mkDerivation {
  pname = "${model}-cupswrapper";
  inherit version;

  src = fetchurl {
    url =
      "https://download.brother.com/welcome/dlf105200/brscan4-0.4.11-1.amd64.deb";
    sha256 = "sha256-AntzZIcirIyOsanEGdKEplYsx2P+rJdAordaaDsJKXI=";
  };

  nativeBuildInputs = [ dpkg makeWrapper ];
  buildInputs = [ cups ghostscript a2ps gawk ];
  unpackPhase = "dpkg-deb -x $src $out";

  installPhase = ''
    for f in $out/opt/brother/scanner/brscan4/*; do
      test -f "$f" && test -x "$f" && wrapProgram $f --prefix PATH : ${
        lib.makeBinPath [ coreutils ghostscript gnugrep gnused ]
      }
    done
  '';

  meta = with lib; {
    homepage = "http://www.brother.com/";
    description = "Brother ${model} printer CUPS wrapper driver";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    platforms = platforms.linux;
    downloadPage =
      "https://support.brother.com/g/b/downloadlist.aspx?c=gb&lang=en&prod=${model}_eu&os=128";
    maintainers = with maintainers; [ pshirshov ];
  };
}
