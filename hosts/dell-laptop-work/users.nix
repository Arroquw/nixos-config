{ pkgs, user, ... }: {
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${user} = {
    isNormalUser = true;
    description = "${user}";
    extraGroups = [ "networkmanager" "wheel" "qemu-libvirtd" "libvirtd" "kvm" ];
    packages = with pkgs; [
      (let
        pname = "teams-for-linux";
        version = "1.3.11";
        name = "${pname}-${version}";
        src = pkgs.fetchurl {
          url =
            "https://github.com/IsmaelMartinez/teams-for-linux/releases/download/v1.3.11/teams-for-linux-1.3.11.AppImage";
          sha256 = "sha256-UmVU5/oKuR3Wx2YHqD5cWjS/PeE7PTNJYF2VoGVdPcs=";
        };
        appimageContents =
          pkgs.appimageTools.extractType1 { inherit name src; };
      in pkgs.appimageTools.wrapType1 {
        inherit name src;
        extraPkgs = appimageTools.defaultFhsEnvArgs.multiPkgs;
        extraInstallCommands =
          "	mv $out/bin/${name} $out/bin/${pname}\n	install -m 444 -D ${appimageContents}/${pname}.desktop $out/share/applications/${pname}.desktop\n	install -m 444 -D ${appimageContents}/${pname}.png $out/share/icons/hicolor/512x512/apps/${pname}.png\n	substituteInPlace $out/share/applications/${pname}.desktop \\\n	    	--replace 'Exec=AppRun --no-sandbox %U' 'Exec=${pname} %U'\n";
      })
      (pkgs.makeDesktopItem {
        name = "allegro-free-viewer";
        exec =
          "wine64 /home/${user}/Programs/17.2/tools/bin/allegro_free_viewer.exe";
        desktopName = "AllegroFreeViewer";
      })
      vscode
      telegram-desktop
      minicom
    ];
  };

}
