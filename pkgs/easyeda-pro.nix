{ stdenv, fetchurl, unzip, autoPatchelfHook, pkgs, makeWrapper, lib
, wrapGAppsHook }:

stdenv.mkDerivation rec {
  name = "easyeda-pro";
  version = "2.2.37.3";

  src = fetchurl {
    url =
      "https://image.easyeda.com/files/easyeda-pro-linux-x64-${version}.zip";
    sha256 = "sha256-X2g4yXzuWAz1vzG5C+6q62s8zxSj8r+EMkOJhQc6+nI=";
  };

  nativeBuildInputs = [ unzip autoPatchelfHook makeWrapper wrapGAppsHook ];

  buildInputs = with pkgs; [ glib nss libdrm mesa alsa-lib libGL udev ];

  unpackPhase = ''
    unzip $src -d .
  '';

  installPhase = ''
    mkdir -p $out/opt/easyeda-pro $out/share/applications/ $out/bin
    cp -rfv easyeda-pro/* $out/opt/easyeda-pro
    chmod -R 777 $out/opt/easyeda-pro

    ln -s $out/opt/easyeda-pro/easyeda-pro $out/bin/easyeda-pro
    cp -v $out/opt/easyeda-pro/easyeda-pro.dkt $out/share/applications/easyeda-pro.desktop
    substituteInPlace $out/share/applications/easyeda-pro.desktop \
        --replace 'Exec=/opt/easyeda-pro/easyeda-pro %f' "Exec=easyeda-pro %f" \
        --replace "Icon=" "Icon=$out"
  '';

  postFixup = ''
    makeWrapper $out/opt/easyeda-pro/easyeda-pro $out/bin/easyeda-pro \
      --prefix LD_LIBRARY_PATH : ${
        lib.makeLibraryPath buildInputs
      }:$out/opt/easyeda-pro
  '';

  meta = with lib; {
    description = "EasyEDA Pro Edition";
    homepage = "https://easyeda.com/";
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
  };
}
