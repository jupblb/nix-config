{ pkgs, ... }: {
  home.packages = with pkgs; [ zk ];

  programs.neovim = {
    plugins = [ {
      config = ''
        source ${toString ./neovim.vim}
        luafile ${toString ./neovim.lua}
      '';
      plugin = pkgs.callPackage ./neovim.nix {};
    } ];
  };

  xdg.configFile = {
    "zk/config.toml".source          =
      let toml = pkgs.formats.toml {}; in toml.generate "config.toml" {
        alias           = {
          edit = "zk edit --interactive $@";
          list = "zk list --interactive $@";
        };
        format.markdown = { link-drop-extension = false; };
        note            = {
          id-charset = "hex";
          id-length  = 8;
          template   = toString ./note-template.md;
        };
        tool            = {
          fzf-preview = "${pkgs.glow}/bin/glow --style light {-1}";
        };
      };
  };
}
