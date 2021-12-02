{
  enable         = true;
  historyControl = [ "erasedups" "ignoredups" "ignorespace" ];
  shellOptions   = [ "cdspell" "checkwinsize" "cmdhist" "histappend" ];
  initExtra      = "source ${toString ./bashrc.bash}";
}
