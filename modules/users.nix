{ config, pkgs, lib, inputs, user, ... }:
{
# Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${user} = {
    isNormalUser = true;
    description = "${user}";
    extraGroups = [ "networkmanager" "wheel" "qemu-libvirtd" "libvirtd" "kvm" ];
    packages = with pkgs; [
     neovim
     firefox
     swaylock-effects swayidle wlogout swaybg  #Login etc..  
     waybar                                    #topbar 
     wayland-protocols
     wayland-utils
     wlroots
     libsForQt5.qt5.qtwayland
     kanshi                                    #laptop dncies
     rofi mako rofimoji                        #Drawer + notifications
     jellyfin-ffmpeg                           #multimedia libs
     viewnior                                  #image viewr
     pavucontrol                               #Volume control
     xfce.thunar                               #filemanager
     xfce.xfconf
     gnome-text-editor
     gnome.file-roller
     gnome.gnome-font-viewer
     gnome.gnome-calculator
     speedcrunch
     vlc                                       #Video player
     amberol                                   #Music player
     cava                                      #Sound Visualized
     wl-clipboard                              
     wf-recorder                               #Video recorder
     sway-contrib.grimshot                     #Screenshot
     ffmpegthumbnailer                         #thumbnailer
     playerctl                                 #play,pause..
     pamixer                                   #mixer
     brightnessctl                             #Brightness control
     ####GTK Customization####
     nordic
     papirus-icon-theme
     gtk3
     glib
     xcur2png
     rubyPackages.glib2
     libcanberra-gtk3                          #notification sound
     #########System#########
     kitty
     gnome.gnome-system-monitor
     libnotify
     poweralertd
     dbus
     #gsettings-desktop-schemas
     #wrapGAppsHook
     xdg-desktop-portal-hyprland
     ####photoshop dencies####
     gnome.zenity
     wine64Packages.waylandFull
     curl
     (steam.override {
      extraPkgs = pkgs: [ bumblebee glxinfo mangohud gamescope libgdiplus ];
     }).run
     #########################
     pulseaudio
     primus
     bumblebee
     tela-circle-icon-theme
     (pkgs.makeDesktopItem {
       name = "discord";
       exec = "${pkgs.discord}/bin/discord --use-gl=desktop";
       desktopName = "Discord";
       icon = "${pkgs.tela-circle-icon-theme}/share/icons/Tela-circle/scalable/apps/discord.svg";
     })
     spotify
     feh
     swww
     ripgrep
     (pkgs.appimageTools.wrapType1 {
	name = "prospect-mail";
	src = pkgs.fetchurl {
		url = "https://github.com/julian-alarcon/prospect-mail/releases/download/v0.5.1/Prospect-Mail-0.5.1.AppImage";
		sha256 = "2b5d3a56423f8cf5a71eab1631600a6f34321b9af487e2f7b2e7e1e19c64a884";
	};
      }) 
    ];
  };
  programs.gamemode.enable = true;
  #swaylock pass verify
  security.pam.services.swaylock = {
    text = ''
      auth include login
    '';
  };

  #thunar dencies
  programs.thunar.plugins = with pkgs.xfce; [
    thunar-archive-plugin
    thunar-volman
  ];
  services.gvfs.enable = true; 
  services.tumbler.enable = true;

  #gnome outside gnome
  programs.dconf.enable = lib.mkDefault true;

  #Steam
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  };
  
  #DIRS
    environment.etc."xdg/user-dirs.defaults".text= ''
    DESKTOP=$HOME/Desktop
    DOWNLOAD=$HOME/Downloads
    TEMPLATES=$HOME/Templates
    PUBLICSHARE=$HOME/Public
    DOCUMENTS=$HOME/Documents
    MUSIC=$HOME/Music
    PICTURES=$HOME/Photos
    VIDEOS=$HOME/Video 
    '';


   #Overlays
    #Waybar wlr/Workspaces
    nixpkgs.overlays = [
    (self: super: {
      waybar = super.waybar.overrideAttrs (oldAttrs: {
        mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
      });
    })
    ];


}
