{ lib, stdenv, fetchurl, cups, dpkg, gnused, makeWrapper, ghostscript, file
, a2ps, coreutils, gnugrep, which, gawk }:

let
  version = "4.0.0";
  model = "DCPL2530DW";
  model_lc = "dcpl2530dw";
in stdenv.mkDerivation rec {
  pname = "${model_lc}-lpr";
  inherit version;

  src = fetchurl {
    url =
      "https://download.brother.com/welcome/dlf103518/dcpl2530dwpdrv-${version}-1.i386.deb";
    sha256 = "sha256-f5lxwp7iu6gvmP7DU3xQMH8rOcuUT0vlxVTUiTg1eeo=";
  };
  nativeBuildInputs = [ dpkg makeWrapper ];
  buildInputs = [ cups ghostscript a2ps gawk ];
  unpackPhase = "dpkg-deb -x $src $out";
  # /opt/brother/Printers/DCPL2530DW/lpd/lpdfilter
  installPhase = ''
    substituteInPlace $out/opt/brother/Printers/${model}/lpd/lpdfilter \
    --replace /opt "$out/opt"

    patchShebangs $out/opt/brother/Printers/${model}/lpd/lpdfilter

    mkdir -p $out/lib/cups/filter/
    ln -s $out/opt/brother/Printers/${model}/lpd/lpdfilter $out/lib/cups/filter/brother_lpdwrapper_${model}

    wrapProgram $out/opt/brother/Printers/${model}/lpd/lpdfilter \
      --prefix PATH ":" ${
        lib.makeBinPath [
          gawk
          ghostscript
          a2ps
          file
          gnused
          gnugrep
          coreutils
          which
        ]
      }
  '';

  meta = with lib; {
    homepage = "http://www.brother.com/";
    description = "Brother ${model} printer driver";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    platforms = platforms.linux;
    downloadPage =
      "https://support.brother.com/g/b/downloadlist.aspx?c=gb&lang=en&prod=${model}_eu&os=128";
    maintainers = with maintainers; [ pshirshov ];
  };
}
