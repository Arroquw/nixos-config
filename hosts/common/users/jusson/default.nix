{ self, pkgs, config, ... }: {
  imports = [ ../common.nix ];
  nixpkgs.config.allowUnfree = true;
  users = {
    mutableUsers = false;
    defaultUserShell = pkgs.zsh;
    users.jusson = {
      isNormalUser = true;
      description = "Justin van Son";
      extraGroups = [ "networkmanager" "wheel" "plugdev" "kvm" ];
      hashedPasswordFile = config.sops.secrets.password-jusson.path;
      packages = with pkgs; [
        (let
          pname = "teams-for-linux";
          version = "1.3.11";
          src = pkgs.fetchurl {
            url =
              "https://github.com/IsmaelMartinez/teams-for-linux/releases/download/v1.3.11/${pname}-${version}.AppImage";
            sha256 = "sha256-UmVU5/oKuR3Wx2YHqD5cWjS/PeE7PTNJYF2VoGVdPcs=";
          };
          appimageContents =
            pkgs.appimageTools.extractType1 { inherit version pname src; };
        in pkgs.appimageTools.wrapType1 {
          inherit pname version src;
          extraPkgs = appimageTools.defaultFhsEnvArgs.multiPkgs;
          extraInstallCommands = ''
            install -m 444 -D ${appimageContents}/${pname}.desktop $out/share/applications/${pname}.desktop
            install -m 444 -D ${appimageContents}/${pname}.png $out/share/icons/hicolor/512x512/apps/${pname}.png
            substituteInPlace $out/share/applications/${pname}.desktop \
            	   	--replace 'Exec=AppRun --no-sandbox %U' 'Exec=${pname} %U'
          '';
        })
        (pkgs.makeDesktopItem {
          name = "allegro-free-viewer";
          exec = ''
            env WINEPREFIX="/home/jusson/.wine64" wine64 /home/jusson/Programs/17.2/tools/bin/allegro_free_viewer.exe
          '';
          desktopName = "AllegroFreeViewer";
          icon = "/home/jusson/Programs/17.2/share/output.ico";
        })
        vscode
        telegram-desktop
        openconnect
        sshfs
        self.packages.${pkgs.system}.sf100linux
        self.packages.${pkgs.system}.em100
        python3
        rubber
        krb5
        poweralertd
      ];
    };
  };

  security.sudo = {
    extraRules = [{
      groups = [ "wheel" ];
      commands = [
        {
          command =
            "/etc/profiles/per-user/jusson/bin/systemctl restart /mnt/pd-common/copydrive";
          options = [ "SETENV" "NOPASSWD" ];
        }
        {
          command =
            "/etc/profiles/per-user/jusson/bin/systemctl restart /mnt/pd-user/projects";
        }
        {
          command =
            "/etc/profiles/per-user/jusson/bin/systemctl restart data-projects.automount";
        }
        {
          command =
            "/etc/profiles/per-user/jusson/bin/systemctl restart data-tools.automount";
        }
        {
          command =
            "/etc/profiles/per-user/jusson/bin/systemctl start /mnt/pd-common/copydrive";
          options = [ "SETENV" "NOPASSWD" ];
        }
        {
          command =
            "/etc/profiles/per-user/jusson/bin/systemctl start /mnt/pd-user/projects";
        }
        {
          command =
            "/etc/profiles/per-user/jusson/bin/systemctl start data-projects.automount";
        }
        {
          command =
            "/etc/profiles/per-user/jusson/bin/systemctl start data-tools.automount";
        }

      ];
    }];
  };
  sops.secrets.password-jusson = {
    sopsFile = ../../secrets.yaml;
    neededForUsers = true;
  };
}
