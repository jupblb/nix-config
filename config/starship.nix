{
  enable   = true;
  settings = {
    add_newline = false;
    directory   = {
      read_only         = " ";
      truncation_length = 8;
      truncation_symbol = "…/";
    };
    format      =
      let
        git    = map (s: "git_" + s) [ "branch" "commit" "state" "status" ];
        line   = prefix ++ [ "hg_branch" ] ++ git  ++ [ "status" "shell" ];
        prefix = [ "shlvl" "nix_shell"  "hostname" "directory" ];
      in builtins.concatStringsSep "" (map (e: "$" + e) line);
    git_branch  = { symbol = " "; };
    git_status  = {
      ahead      = " ";
      behind     = " ";
      conflicted = " ";
      deleted    = " ";
      diverged   = " ";
      format     =
        "([$all_status](underline $style)[$ahead_behind]($style) )";
      modified   = " ";
      renamed    = " ";
      staged     = " ";
      stashed    = " ";
      untracked  = " ";
    };
    hg_branch   = { disabled = false; symbol = " "; };
    hostname    = { format = "[($hostname:)]($style)"; };
    nix_shell   = { format = "[ ]($style) "; };
    shell       = {
      bash_indicator = "\\$";
      disabled       = false;
      fish_indicator = "~>";
    };
    shlvl       = { disabled = false; symbol = " "; };
    status      = { disabled = false; symbol = " "; };
  };
}
