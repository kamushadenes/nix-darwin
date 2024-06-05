{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.nextdns;
  nextdns = pkgs.nextdns;
  removeQuotes = arg: builtins.substring 1 (builtins.stringLength arg - 2) arg;

in {
  options = {
    services.nextdns = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description =
          "Whether to enable the NextDNS DNS/53 to DoH Proxy service.";
      };
      arguments = mkOption {
        type = types.listOf types.str;
        default = [ ];
        example = [ "-config" "10.0.3.0/24=abcdef" ];
        description = "Additional arguments to be passed to nextdns run.";
      };
    };
  };

  config = mkIf cfg.enable {

    environment.systemPackages = [ nextdns ];

    launchd.daemons.nextdns = {
      path = [ nextdns ];
      serviceConfig.ProgramArguments =
        [ "${pkgs.nextdns}/bin/nextdns" "run" ] ++ cfg.arguments;
      serviceConfig.KeepAlive = true;
      serviceConfig.RunAtLoad = true;
    };
  };
}
