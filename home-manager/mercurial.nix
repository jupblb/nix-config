{ pkgs, ... }: {
  programs.mercurial = {
    enable      = true;
    extraConfig = {
      extensions.beautifygraph = "";
      pager.pager              = "${pkgs.gitAndTools.delta}/bin/delta";
    };
    userEmail   = "mpkielbowicz@gmail.com";
    userName    = "jupblb";
  };
}
