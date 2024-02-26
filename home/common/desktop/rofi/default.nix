{ config, ... }:
let
  background = "#20212CFF";
  background-alt = "#282B3CFF";
  foreground = "#C0CAF5";
  selected = "#7A95C9";
  active = "#414868";
  urgent = "#ECD3A0";
  inherit (config.lib.formats.rasi) mkLiteral;
in {
  programs.rofi = {
    enable = true;
    font = "JetBrains Mono Nerd Font 11.6";
    extraConfig = { modes = "window,drun,run,filebrowser"; };
    theme = {
      "configuration" = {
        show-icons = true;
        icon-theme = "Papirus";
        display-drun = " ";
        display-run = " ";
        display-filebrowser = " ";
        display-window = " ";
        drun-display-format = "{name}";
        window-format = "{w} · {c} · {t}";
      };
      "*" = {
        border-colour = mkLiteral "${selected}";
        handle-colour = mkLiteral "${selected}";
        background-colour = mkLiteral "${background}";
        foreground-colour = mkLiteral "${foreground}";
        alternate-background = mkLiteral "${background-alt}";
        normal-background = mkLiteral "${background}";
        normal-foreground = mkLiteral "${foreground}";
        urgent-background = mkLiteral "${urgent}";
        urgent-foreground = mkLiteral "${background}";
        active-background = mkLiteral "${active}";
        active-foreground = mkLiteral "${background}";
        selected-normal-background = mkLiteral "${selected}";
        selected-normal-foreground = mkLiteral "${background}";
        selected-urgent-background = mkLiteral "${active}";
        selected-urgent-foreground = mkLiteral "${background}";
        selected-active-background = mkLiteral "${urgent}";
        selected-active-foreground = mkLiteral "${background}";
        alternate-normal-background = mkLiteral "${background}";
        alternate-normal-foreground = mkLiteral "${foreground}";
        alternate-urgent-background = mkLiteral "${urgent}";
        alternate-urgent-foreground = mkLiteral "${background}";
        alternate-active-background = mkLiteral "${active}";
        alternate-active-foreground = mkLiteral "${background}";
      };

      # ****----- Main Window -----****
      "window" = {
        # properties for window widget
        transparency = "real";
        location = mkLiteral "center";
        anchor = mkLiteral "center";
        fullscreen = false;
        width = mkLiteral "400px";
        x-offset = mkLiteral "0px";
        y-offset = mkLiteral "0px";

        # properties for all widgets
        enabled = true;
        margin = mkLiteral "0px";
        padding = mkLiteral "0px";
        border = mkLiteral "0px solid";
        border-radius = mkLiteral "10px";
        border-color = mkLiteral "#89B4FA";
        cursor = "default";
        # Backgroud Colors
        background-color = mkLiteral "@background-colour";
        # Backgroud Image
        # background-image = mkLiteral "url("/path/to/image.png", none)";
        # Simple Linear Gradient
        # background-image = mkLiteral "linear-gradient(red, orange, pink, purple)";
        # Directional Linear Gradient
        # background-image = mkLiteral "linear-gradient(to bottom, pink, yellow, magenta)";
        # Angle Linear Gradient
        # background-image = mkLiteral "linear-gradient(45, cyan, purple, indigo)";
      };

      # ****----- Main Box -----****
      "mainbox" = {
        enabled = true;
        spacing = mkLiteral "10px";
        margin = mkLiteral "0px";
        padding = mkLiteral "30px";
        border = mkLiteral "0px solid";
        border-radius = mkLiteral "15px";
        border-color = mkLiteral "#6f91c9";
        background-color = mkLiteral "transparent";
        transparency = "real";
        children = map mkLiteral [ "inputbar" "message" "listview" ];
      };

      # ****----- Inputbar -----****
      "inputbar" = {
        enabled = true;
        spacing = mkLiteral "10px";
        margin = mkLiteral "0px";
        padding = mkLiteral "0px";
        border = mkLiteral "0px solid";
        border-radius = mkLiteral "0px";
        border-color = mkLiteral "@border-colour";
        background-color = mkLiteral "transparent";
        text-color = mkLiteral "@foreground-colour";
        children =
          map mkLiteral [ "textbox-prompt-colon" "entry" "mode-switcher" ];
      };

      "prompt" = {
        enabled = true;
        background-color = mkLiteral "inherit";
        text-color = mkLiteral "inherit";
      };
      "textbox-prompt-colon" = {
        enabled = true;
        padding = mkLiteral "5px 0px";
        expand = false;
        str = "";
        background-color = mkLiteral "inherit";
        text-color = mkLiteral "inherit";
      };
      "entry" = {
        enabled = true;
        padding = mkLiteral "5px 0px";
        background-color = mkLiteral "inherit";
        text-color = mkLiteral "inherit";
        cursor = mkLiteral "text";
        placeholder = "Search...";
        placeholder-color = mkLiteral "inherit";
      };
      "num-filtered-rows" = {
        enabled = true;
        expand = false;
        background-color = mkLiteral "inherit";
        text-color = mkLiteral "inherit";
      };
      "textbox-num-sep" = {
        enabled = true;
        expand = false;
        str = "/";
        background-color = mkLiteral "inherit";
        text-color = mkLiteral "inherit";
      };
      "num-rows" = {
        enabled = true;
        expand = false;
        background-color = mkLiteral "inherit";
        text-color = mkLiteral "inherit";
      };
      "case-indicator" = {
        enabled = true;
        background-color = mkLiteral "inherit";
        text-color = mkLiteral "inherit";
      };

      # ****----- Listview -----****
      "listview" = {
        enabled = true;
        columns = 1;
        lines = 8;
        cycle = true;
        dynamic = true;
        scrollbar = true;
        layout = mkLiteral "vertical";
        reverse = false;
        fixed-height = true;
        fixed-columns = true;

        spacing = mkLiteral "5px";
        margin = mkLiteral "0px";
        padding = mkLiteral "0px";
        border = mkLiteral "0px solid";
        border-radius = mkLiteral "0px";
        border-color = mkLiteral "@border-colour";
        background-color = mkLiteral "transparent";
        text-color = mkLiteral "@foreground-colour";
        cursor = "default";
      };
      "scrollbar" = {
        handle-width = mkLiteral "3px ";
        handle-color = mkLiteral "@handle-colour";
        border-radius = mkLiteral "10px";
        background-color = mkLiteral "@alternate-background";
      };

      # ****----- Elements -----****
      "element" = {
        enabled = true;
        spacing = mkLiteral "10px";
        margin = mkLiteral "0px";
        padding = mkLiteral "5px 10px";
        border = mkLiteral "0px solid";
        border-radius = mkLiteral "10px";
        border-color = mkLiteral "@border-colour";
        background-color = mkLiteral "transparent";
        text-color = mkLiteral "@foreground-colour";
        cursor = mkLiteral "pointer";
      };
      "element normal.normal" = {
        background-color = mkLiteral "var(normal-background)";
        text-color = mkLiteral "var(normal-foreground)";
      };
      "element normal.urgent" = {
        background-color = mkLiteral "var(urgent-background)";
        text-color = mkLiteral "var(urgent-foreground)";
      };
      "element normal.active" = {
        background-color = mkLiteral "var(active-background)";
        text-color = mkLiteral "var(active-foreground)";
      };
      "element selected.normal" = {
        background-color = mkLiteral "var(selected-normal-background)";
        text-color = mkLiteral "var(selected-normal-foreground)";
      };
      "element selected.urgent" = {
        background-color = mkLiteral "var(selected-urgent-background)";
        text-color = mkLiteral "var(selected-urgent-foreground)";
      };
      "element selected.active" = {
        background-color = mkLiteral "var(selected-active-background)";
        text-color = mkLiteral "var(selected-active-foreground)";
      };
      "element alternate.normal" = {
        background-color = mkLiteral "var(alternate-normal-background)";
        text-color = mkLiteral "var(alternate-normal-foreground)";
      };
      "element alternate.urgent" = {
        background-color = mkLiteral "var(alternate-urgent-background)";
        text-color = mkLiteral "var(alternate-urgent-foreground)";
      };
      "element alternate.active" = {
        background-color = mkLiteral "var(alternate-active-background)";
        text-color = mkLiteral "var(alternate-active-foreground)";
      };
      "element-icon" = {
        background-color = mkLiteral "transparent";
        text-color = mkLiteral "inherit";
        size = mkLiteral "24px";
        cursor = mkLiteral "inherit";
      };
      "element-text" = {
        background-color = mkLiteral "transparent";
        text-color = mkLiteral "inherit";
        highlight = mkLiteral "inherit";
        cursor = mkLiteral "inherit";
        vertical-align = "0.5";
        horizontal-align = 0;
      };

      # ****----- Mode Switcher -----****
      "mode-switcher" = {
        enabled = true;
        spacing = mkLiteral "10px";
        margin = mkLiteral "0px";
        padding = mkLiteral "0px";
        border = mkLiteral "0px solid";
        border-radius = mkLiteral "0px";
        border-color = mkLiteral "@border-colour";
        background-color = mkLiteral "transparent";
        text-color = mkLiteral "@foreground-colour";
      };
      "button" = {
        padding = mkLiteral "5px 10px";
        border = mkLiteral "0px solid";
        border-radius = mkLiteral "10px";
        border-color = mkLiteral "@border-colour";
        background-color = mkLiteral "@alternate-background";
        text-color = mkLiteral "inherit";
        cursor = mkLiteral "pointer";
      };
      "button selected" = {
        background-color = mkLiteral "var(selected-normal-background)";
        text-color = mkLiteral "var(selected-normal-foreground)";
      };

      # ****----- Message -----****
      "message" = {
        enabled = true;
        margin = mkLiteral "0px";
        padding = mkLiteral "0px";
        border = mkLiteral "0px solid";
        border-radius = mkLiteral "0px 0px 0px 0px";
        border-color = mkLiteral "@border-colour";
        background-color = mkLiteral "transparent";
        text-color = mkLiteral "@foreground-colour";
      };
      "textbox" = {
        padding = mkLiteral "8px 10px";
        border = mkLiteral "0px solid";
        border-radius = mkLiteral "10px";
        border-color = mkLiteral "@border-colour";
        background-color = mkLiteral "@alternate-background";
        text-color = mkLiteral "@foreground-colour";
        vertical-align = "0.5";
        horizontal-align = 0;
        highlight = mkLiteral "none";
        placeholder-color = mkLiteral "@foreground-colour";
        blink = true;
        markup = true;
      };
      "error-message" = {
        padding = mkLiteral "10px";
        border = mkLiteral "2px solid";
        border-radius = mkLiteral "10px";
        border-color = mkLiteral "@border-colour";
        background-color = mkLiteral "@background-colour";
        text-color = mkLiteral "@foreground-colour";
      };
    };
  };

}
