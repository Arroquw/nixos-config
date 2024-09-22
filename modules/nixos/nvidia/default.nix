{ lib, pkgs, config, ... }:
with lib;
let
  cfg = config.arroquw.nvidia;
  nvidiaPackage = config.boot.kernelPackages.nvidiaPackages.latest;
in {
  options.arroquw.nvidia = { enable = mkEnableOption "nvidia drivers"; };

  config = mkIf cfg.enable {
    nixpkgs.config.nvidia.acceptLicense = true;

    services.xserver.videoDrivers = [ "nvidia" ];

    environment.variables = {
      GBM_BACKEND = "nvidia-drm";
      LIBVA_DRIVER_NAME = "nvidia";
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    };

    environment.systemPackages = with pkgs; [
      vulkan-loader
      vulkan-validation-layers
      vulkan-tools
    ];

    hardware = {
      nvidia = {
        modesetting.enable = true;
        powerManagement.enable = true; # Disable if issues with sleep/suspend
        package = nvidiaPackage;
        nvidiaSettings = true;
        open = true;
      };
      opengl = {
        #driSupport = true;
        driSupport32Bit = true;
        extraPackages = with pkgs; [
          nvidia-vaapi-driver
          vaapiVdpau
          libvdpau-va-gl
        ];
      };
    };
  };
}
