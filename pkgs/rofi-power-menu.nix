{ pkgs, stdenv, procps, gnused, ... }:
let
  powerMenuScript = pkgs.writeShellScriptBin "rofi-power-menu" ''
    #!${pkgs.bash}/bin/bash
    dir="~/.config/rofi"
    theme='style'
    # CMDs
    uptime="$(${pkgs.procps}/bin/uptime -p | ${pkgs.gnused}/bin/sed -e 's/up //g')"
    # Options
    shutdown=''
    reboot=''
    lock=''
    suspend=' '
    logout="\Uf0343"
    yes=' '
    no=''

    # Rofi CMD
    rofi_cmd() {
    	${pkgs.rofi-wayland}/bin/rofi -dmenu \
    		-p "Uptime: $uptime" \
    		-mesg "Uptime: $uptime" \
    		-theme "''${dir}/''${theme}.rasi"
    }

    # Confirmation CMD
    confirm_cmd() {
    	${pkgs.rofi-wayland}/bin/rofi -theme-str 'window {location: center; anchor: center; fullscreen: false; width: 350px;}' \
    		-theme-str 'mainbox {children: [ "message", "listview" ];}' \
    		-theme-str 'listview {columns: 2; lines: 1;}' \
    		-theme-str 'element-text {horizontal-align: 0.5;}' \
    		-theme-str 'textbox {horizontal-align: 0.5;}' \
    		-dmenu \
    		-p 'Confirmation' \
    		-mesg 'Are you Sure?' \
    		-theme "''${dir}/''${theme}.rasi"
    }

    # Ask for confirmation
    confirm_exit() {
    	echo -e "$yes\n$no" | confirm_cmd
    }

    # Pass variables to rofi dmenu
    run_rofi() {
    	echo -e "$lock\n$suspend\n$logout\n$reboot\n$shutdown" | rofi_cmd
    }

    # Execute Command
    run_cmd() {
    	selected="$(confirm_exit)"
    	if [[ "$selected" == "$yes" ]]; then
    		if [[ $1 == '--shutdown' ]]; then
    			systemctl poweroff
    		elif [[ $1 == '--reboot' ]]; then
    			systemctl reboot
    		elif [[ $1 == '--suspend' ]]; then
    			${pkgs.playerctl}/bin/playerctl pause
    			${pkgs.alsa-utils}/bin/amixer set Master mute
    			systemctl suspend
    		elif [[ $1 == '--logout' ]]; then
                if [[ "$DESKTOP_SESSION" == 'openbox' ]]; then
                    openbox --exit
                elif [[ "$DESKTOP_SESSION" == 'bspwm' ]]; then
                    bspc quit
                elif [[ "$DESKTOP_SESSION" == 'i3' ]]; then
                    i3-msg exit
                elif [[ "$DESKTOP_SESSION" == 'plasma' ]]; then
                    qdbus org.kde.ksmserver /KSMServer logout 0 0 0
                elif [[ "$DESKTOP_SESSION" == 'hyprland' ]]; then
                    ${pkgs.hyprland}/bin/hyprctl dispatch exit 1
                fi
            fi
    	else
    		exit 0
    	fi
    }

    # Actions
    chosen="$(run_rofi)"
    case "''${chosen}" in
        "$shutdown")
    		run_cmd --shutdown
            ;;
        "$reboot")
    		run_cmd --reboot
            ;;
        "$lock")
    	if [ "$(command -v betterlockscreen)" ]; then
    		betterlockscreen -l
    	elif [ "$(command -v i3lock)" ]; then
    		i3lock
      elif [ "$(command -v hyprlock)" ]; then
        ${pkgs.hyprlock}/bin/hyprlock
    	elif [ "$(command -v swaylock)" ]; then
    		${pkgs.swaylock-effects}/bin/swaylock -fF
    	fi
            ;;
        "$suspend")
    		run_cmd --suspend
            ;;
        "$logout")
    		run_cmd --logout
            ;;
    esac
  '';
in stdenv.mkDerivation {
  name = "rofi-power-menu";

  src = powerMenuScript;
  phases = [ "installPhase" ];

  nativeBuildInputs = [ procps ];

  installPhase = ''
    mkdir -p $out/bin
    install -Dm 744 $src/bin/rofi-power-menu $out/bin/rofi-power-menu
  '';
}

