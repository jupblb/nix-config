{ config, lib, pkgs, ... }: {
  home =
    let gcloud = pkgs.google-cloud-sdk.withExtraComponents
      (with pkgs.google-cloud-sdk.components; [ gke-gcloud-auth-plugin ]);
    in {
      activation.gcloud = lib.hm.dag.entryAfter ["writeBoundary"] ''
        # gcloud looks for the component binaries only within the following path
        # sudo ln -sfn ${gcloud} /usr/local/share/google-cloud-sdk
        # disable telemetry
        ${gcloud}/bin/gcloud config set disable_usage_reporting true
      '';
      packages          = [ gcloud pkgs.kubectl ];
      sessionVariables  = {
        CLOUDSDK_CONFIG = "${config.xdg.configHome}/gcloud";
    };
  };

  programs.fish.plugins = [ {
    name = "gcloud";
    src  = pkgs.fetchFromGitHub {
      owner  = "lgathy";
      repo   = "google-cloud-sdk-fish-completion";
      rev    = "master";
      sha256 = "03zzggi64fhk0yx705h8nbg3a02zch9y49cdvzgnmpi321vz71h4";
    };
  } ];
}
