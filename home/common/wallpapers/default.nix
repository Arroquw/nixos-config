builtins.listToAttrs (map (wallpaper: {
  inherit (wallpaper) name;
  value = ./${wallpaper.name}.${wallpaper.ext};
}) (builtins.fromJSON (builtins.readFile ./list.json)))
