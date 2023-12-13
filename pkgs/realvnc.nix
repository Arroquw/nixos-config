{ stdenv, fetchurl, xorg, patchelf, makeWrapper }:
stdenv.mkDerivation {
  name = "realvnc-viewer";
  src = fetchurl {
    url =
      "https://downloads.realvnc.com/download/file/viewer.files/VNC-Viewer-7.8.0-Linux-x64";
    sha256 = "sha256-mFWdM6kYO0LZxF0vsEn4LRBj2hgzgvUqiWDEzMfwBzE=";
  };
  dontUnpack = true;
  buildInputs = [ xorg.libX11 xorg.libXext patchelf makeWrapper ];
  buildPhase = ''
    export INTERPRETER=$(cat $NIX_CC/nix-support/dynamic-linker)
    echo "INTERPRETER=$INTERPRETER"

    cp $src realvnc-viewer
    chmod +wx realvnc-viewer

    echo "patching interpreter"
    patchelf --set-interpreter \
      "$INTERPRETER" \
      realvnc-viewer
  '';
  installPhase = ''
    echo "making output directory"
    mkdir -p $out/bin

    echo "copying to output"
    cp realvnc-viewer $out/bin

    echo "wrapping program"
    wrapProgram $out/bin/realvnc-viewer \
      --set LD_LIBRARY_PATH "${xorg.libX11}/lib:${xorg.libXext}/lib"
  '';
}
