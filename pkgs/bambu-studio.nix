{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.bambuStudio;

  version = "02.05.00.67";

  # Fetch the AppImage once
  appimageSource = pkgs.fetchurl {
    url = "https://github.com/bambulab/BambuStudio/releases/download/v${version}/Bambu_Studio_ubuntu-24.04_PR-9540.AppImage";
    hash = "sha256-JrwH3MsE3y5GKx4Do3ZlCSAcRuJzEqFYRPb11/3x3r0=";
  };

  # Extract AppImage contents for desktop file and icon
  appimageContents = pkgs.appimageTools.extractType2 {
    pname = "bambu-studio";
    inherit version;
    src = appimageSource;
  };

  # AppImage wrapper with full dependencies from discourse thread
  # Using Ubuntu AppImage (better compatibility than Fedora on NixOS)
  bambu-studio = pkgs.appimageTools.wrapType2 rec {
    pname = "bambu-studio";
    inherit version;

    src = appimageSource;

    # Set environment variables for SSL, GIO, and webkit rendering
    profile = ''
      export SSL_CERT_FILE="${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt"
      export GIO_MODULE_DIR="${pkgs.glib-networking}/lib/gio/modules/"
      export WEBKIT_DISABLE_DMABUF_RENDERER=1
      export __GLX_VENDOR_LIBRARY_NAME=nvidia
      export MESA_LOADER_DRIVER_OVERRIDE=nvidia
    '';

    extraPkgs =
      pkgs: with pkgs; [
        cacert
        curl
        glib
        glib-networking
        gst_all_1.gst-plugins-bad
        gst_all_1.gst-plugins-base
        gst_all_1.gst-plugins-good
        webkitgtk_4_1 # Provides libwebkit2gtk-4.1.so.0
      ];

    # Install desktop entry and icon for rofi/application launchers
    extraInstallCommands = ''
      # Install desktop file
      install -Dm644 ${appimageContents}/BambuStudio.desktop $out/share/applications/BambuStudio.desktop
      substituteInPlace $out/share/applications/BambuStudio.desktop \
        --replace 'Exec=AppRun' 'Exec=bambu-studio' \
        --replace 'Icon=BambuStudio' 'Icon=bambu-studio'

      # Install icon
      mkdir -p $out/share/pixmaps
      cp ${appimageContents}/resources/images/BambuStudioLogo.png $out/share/pixmaps/bambu-studio.png 2>/dev/null || \
      cp ${appimageContents}/.DirIcon $out/share/pixmaps/bambu-studio.png 2>/dev/null || true
    '';
  };
in
{
  options.bambuStudio = {
    enable = lib.mkEnableOption "Bambu Studio AppImage";
  };

  config = lib.mkIf cfg.enable { environment.systemPackages = [ bambu-studio ]; };
}
