{
  writeShellApplication,
  hyprland,
  jq,
  libnotify,
  noctalia,
}:
writeShellApplication {
  name = "hypr-resolution";
  runtimeInputs = [
    hyprland # hyprctl
    jq
    libnotify # notify-send
    noctalia # noctalia dmenu
  ];
  text = ''
    monitors=$(hyprctl monitors -j)

    choice=$(jq -r '.[] | "\(.name), \(.width)x\(.height)@\(.refreshRate | round), scale \(.scale), \(.description)"' <<<"$monitors" |
      noctalia dmenu -p "Monitor") || exit 0
    [ -n "$choice" ] || exit 0
    name=''${choice%%,*}

    monitor=$(jq -c --arg n "$name" '.[] | select(.name == $n)' <<<"$monitors")
    mode=$(jq -r '"\(.width)x\(.height)@\(.refreshRate)"' <<<"$monitor")
    position=$(jq -r '"\(.x)x\(.y)"' <<<"$monitor")
    scale=$(jq -r '.scale' <<<"$monitor")

    action=$(printf 'scale\nresolution\n' | noctalia dmenu -p "Change $name") || exit 0
    case "$action" in
    scale)
      new=$(printf '%s (current)\n1.0\n1.25\n1.5\n1.6\n2.0\n' "$scale" |
        noctalia dmenu -p "Scale for $name") || exit 0
      new=''${new% (current)}
      scale=$new
      ;;
    resolution)
      new=$(printf '%s (current)\n1920x1080@60\n2560x1440@60\n3840x2160@60\n' "$mode" |
        noctalia dmenu -p "Resolution for $name") || exit 0
      new=''${new% (current)}
      mode=$new
      ;;
    *) exit 0 ;;
    esac
    [ -n "$new" ] || exit 0

    result=$(hyprctl eval "hl.monitor({output = \"$name\", mode = \"$mode\", position = \"$position\", scale = \"$scale\"})")
    if [ "$result" = ok ]; then
      notify-send "Display" "$name: $action set to $new"
    else
      notify-send -u critical "Display" "$name: could not set $action to $new: $result"
    fi
  '';
}
