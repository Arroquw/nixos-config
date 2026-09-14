{
  self,
  pkgs,
  ...
}:
{
  imports = [
    ../common/global.nix
    ../common/packages.nix
    ../common/desktop
    ../common/programs
    # NOTE: ../common/programs/games is deliberately not imported here.
  ];

  home = {
    username = "jusson";

    packages =
      with pkgs;
      [
        (
          let
            pname = "teams-for-linux";
            version = "1.3.11";
            src = pkgs.fetchurl {
              url = "https://github.com/IsmaelMartinez/teams-for-linux/releases/download/v${version}/${pname}-${version}.AppImage";
              sha256 = "sha256-UmVU5/oKuR3Wx2YHqD5cWjS/PeE7PTNJYF2VoGVdPcs=";
            };
            appimageContents = pkgs.appimageTools.extract { inherit version pname src; };
          in
          pkgs.appimageTools.wrapType2 {
            inherit pname version src;
            extraPkgs = appimageTools.defaultFhsEnvArgs.multiPkgs;
            extraInstallCommands = ''
              install -m 444 -D ${appimageContents}/${pname}.desktop $out/share/applications/${pname}.desktop
              install -m 444 -D ${appimageContents}/${pname}.png $out/share/icons/hicolor/512x512/apps/${pname}.png
              substituteInPlace $out/share/applications/${pname}.desktop \
                --replace 'Exec=AppRun --no-sandbox %U' 'Exec=${pname} %U'
            '';
          }
        )
        (pkgs.makeDesktopItem {
          name = "allegro-free-viewer";
          exec = ''
            env WINEPREFIX="/home/jusson/.wine64" wine64 /home/jusson/Programs/17.2/tools/bin/allegro_free_viewer.exe
          '';
          desktopName = "AllegroFreeViewer";
          icon = "/home/jusson/Programs/17.2/share/output.ico";
        })
        openconnect
        sshfs
        python3
        rubber
        krb5
        (pkgs.realvnc-vnc-viewer.overrideAttrs (old: {
          version = "8.4.2";
          src = pkgs.fetchurl {
            url = "https://downloads.realvnc.com/download/file/realvnc-connect-viewer/RealVNC-Connect-Viewer-8.4.2-Linux-x64.rpm";
            sha256 = "sha256-k0n6VuPwUEBpEQinCs+rabziMNqZR0At/4ONBHVnJSo=";
          };
          postPatch = "";
          buildInputs =
            with pkgs;
            old.buildInputs
            ++ [
              gtk3
              glib
              pango
              atk
              libepoxy
              fontconfig
            ];
          postInstall = ''
            rm -rf $out/lib/.build-id
            mkdir -p $out/bin
            ln -s $out/lib/rvncconnect/rvncconnect $out/bin/rvncconnect

            for f in $out/share/applications/com.realvnc.rvncconnect*.desktop; do
              sed -i 's/\r$//' "$f"
              substituteInPlace "$f" \
                --replace-fail '/usr/lib/rvncconnect/rvncconnect' "$out/bin/rvncconnect" \
                --replace-warn \
                  '/usr/share/icons/hicolor/scalable/apps/com.realvnc.rvncconnect.svg' \
                  "$out/share/icons/hicolor/scalable/apps/com.realvnc.rvncconnect.svg"
            done
          '';
          meta = old.meta // {
            mainProgram = "rvncconnect";
          };
        }))
      ]
      ++ (with self.packages.${pkgs.stdenv.hostPlatform.system}; [
        sf100linux
        em100
      ]);
  };

  # Laptop-only: battery warnings are meaningless on the desktop.
  # Was an exec_cmd in hyprland.nix, which ran it on both hosts.
  services.poweralertd.enable = true;

  #  ------   -----   ------
  # | DP-4/6 | | DP-5/7 |
  #              |eDP-1|
  #  ------   -----   ------
  monitors =
    let
      left = "Dell Inc. DELL U2717D J0XYN8AOB7JL";
      right = "Dell Inc. DELL U2717D J0XYN8B6DU3S";
    in
    [
      {
        name = "eDP-1";
        width = 1920;
        height = 1080;
        refreshRate = 60;
        x = 1920;
        y = 1440;
        workspace = [
          "1"
          "4"
        ];
      }
      {
        name = "DP-5";
        desc = right;
        width = 2560;
        height = 1440;
        refreshRate = 60;
        x = 2560;
        workspace = [
          "2"
          "5"
        ];
        primary = true;
      }
      {
        name = "DP-4";
        desc = left;
        width = 2560;
        height = 1440;
        refreshRate = 60;
        x = 0;
        workspace = [
          "3"
          "6"
        ];
      }
    ];
}
