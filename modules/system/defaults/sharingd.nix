{ config, lib, ... }:

with lib;

{
  options = {

    system.defaults.sharingd.DiscoverableMode = mkOption {
      type = types.nullOr (types.enum [
        "Off"
        "Contacts Only"
        "Everyone"
      ]);
      default = null;
      description = ''
          The AirDrop discoverability mode. Possible values are "Off", "Contacts Only", and "Everyone".
        '';
    };
  };
}
