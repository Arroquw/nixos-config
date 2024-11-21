{ pkgs, ... }: {
  hardware = {
    bluetooth = {
      enable = true;
      package = pkgs.bluez;
      input.General.ClassicBondedOnly = false;
    };
  };
  services.blueman.enable = true;

  services.udev.extraRules = ''
    # PS4 DualShock controller over USB hidraw
    KERNEL=="hidraw*", ATTRS{idVendor}=="054c", ATTRS{idProduct}=="05c4", MODE="0660", TAG+="uaccess"

    # PS4 DualShock controller over bluetooth hidraw
    KERNEL=="hidraw*", KERNELS=="*054C:05C4*", MODE="0660", TAG+="uaccess"
  '';
}
