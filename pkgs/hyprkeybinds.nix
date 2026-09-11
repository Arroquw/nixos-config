{
  writeShellApplication,
  gawk,
  gnugrep,
  gnused,
  libnotify,
  noctalia,
}:
writeShellApplication {
  name = "hyprkeybinds";
  runtimeInputs = [
    gawk
    gnugrep
    gnused
    libnotify # notify-send
    noctalia # noctalia dmenu
  ];
  text = ''
    config="''${XDG_CONFIG_HOME:-$HOME/.config}/hypr/hyprland.lua"
    if [ ! -r "$config" ]; then
      notify-send -u critical "Keybinds" "Cannot read $config"
      exit 1
    fi

    grep '^hl\.bind("' "$config" |
      sed -E \
        -e 's|/nix/store/[a-z0-9]{32}-[^/"]+/bin/||g' \
        -e 's|/nix/store/[a-z0-9]{32}-||g' \
        -e 's/^hl\.bind\("([^"]+)", \((.*)\)\)$/\1\t\2/' \
        -e 's/^hl\.bind\("([^"]+)", \((.*)\), \{$/\1\t\2/' \
        -e 's/\thl\.dsp\.exec_cmd\("(.*)"\)$/\t\1/' \
        -e 's/\thl\.dsp\./\t/' \
        -e 's/\trunapp /\t/' |
      awk -F '\t' '{ printf "%s  →  %s\n", $1, $2 }' |
      noctalia dmenu -p "Keybinds" >/dev/null || true
  '';
}
