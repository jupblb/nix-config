{ pkgs, ... }: {
  programs.npm = {
    enable  = true;
    npmrc   = ''
      cache=''${XDG_CACHE_HOME}/npm
      init-module=''${XDG_CONFIG_HOME}/npm/npm-init.js
      prefix=''${XDG_DATA_HOME}/npm
      userconfig=''${XDG_CONFIG_HOME}/npm/npmrc
    '';
    package = pkgs.nodejs;
  };
}
