{ config, ... }:

{
  sops.secrets = {
    storagebox-stage = {
      sopsFile = ../secrets/storagebox.json;
      format = "json";
      key = "stage";
      path = "${config.home.homeDirectory}/.config/smb/storagebox-stage.credentials";
      mode = "0600";
    };
    storagebox-prod = {
      sopsFile = ../secrets/storagebox.json;
      format = "json";
      key = "prod";
      path = "${config.home.homeDirectory}/.config/smb/storagebox-prod.credentials";
      mode = "0600";
    };
  };
}
