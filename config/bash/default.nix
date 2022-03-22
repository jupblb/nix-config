{
  enable         = true;
  historyControl = [ "erasedups" "ignoredups" "ignorespace" ];
  shellAliases   = { "ls" = "ls --color=auto"; };
  shellOptions   = [ "cdspell" "checkwinsize" "cmdhist" "histappend" ];
  initExtra      = "source ${toString ./bashrc.bash}";
}
