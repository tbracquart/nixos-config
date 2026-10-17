{ config, ... }:

let
  secretsDir = "${config.home.homeDirectory}/.secrets";
in
{
  programs.openclaw = {
    enable = true;

    environment.OPENCLAW_GATEWAY_TOKEN = "${secretsDir}/openclaw-gateway-token";

    config = {
      gateway = {
        mode = "local";
        auth = {
          mode = "token";
          token = {
            source = "env";
            provider = "default";
            id = "OPENCLAW_GATEWAY_TOKEN";
          };
        };
      };

      agents.defaults.model.primary = "openai/gpt-6-astra";

      channels.telegram = {
        tokenFile = "${secretsDir}/openclaw-telegram-token";
        dmPolicy = "pairing";
      };
    };
  };
}
