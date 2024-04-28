{ lib, config, ... }:
let inherit (lib) mkOption types;
in {
  options.monitors = mkOption {
    type = types.listOf (types.submodule {
      options = {
        name = mkOption {
          type = types.nullOr types.str;
          example = "DP-1";
          default = null;
        };
        desc = mkOption {
          type = types.nullOr types.str;
          example = "LG Display 0x068B";
          default = null;
        };
        primary = mkOption {
          type = types.bool;
          default = false;
        };
        width = mkOption {
          type = types.int;
          example = 1920;
        };
        height = mkOption {
          type = types.int;
          example = 1080;
        };
        refreshRate = mkOption {
          type = types.int;
          default = 60;
        };
        x = mkOption {
          type = types.int;
          default = 0;
        };
        y = mkOption {
          type = types.int;
          default = 0;
        };
        transform = mkOption {
          type = types.int;
          default = 0;
        };
        enabled = mkOption {
          type = types.bool;
          default = true;
        };
        workspace = mkOption {
          type = types.listOf types.str;
          example = [ "1" "2" "Hello" "7" ];
          default = [ ];
        };
        vrr = mkOption {
          type = types.int;
          default = 0;
        };
      };
    });
    default = [ ];
  };
  config = {
    assertions = [
      {
        assertion = ((lib.length config.monitors) != 0)
          -> ((lib.length (lib.filter (m: m.primary) config.monitors)) == 1);
        message = "Exactly one monitor must be set to primary.";
      }
      {
        assertion = ((lib.length config.monitors) != 0) -> ((lib.length
          (lib.filter (m: builtins.isNull m.name && builtins.isNull m.desc)
            config.monitors)) == 0);
        message =
          "At least one of the following fields is required: name, desc.";
      }
      {
        assertion = ((lib.length config.monitors) != 0) -> ((lib.length
          (lib.filter (m: m.vrr < 0 || m.vrr > 2) config.monitors)) == 0);
        message =
          "vrr must be a value between 0 (off), 1 (always on) 2 (only in fullscreen)";
      }
    ];
  };
}
