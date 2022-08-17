{ config, pkgs, ... }: {
  home.packages = with pkgs; [ zk ];

  programs.neovim = {
    plugins = [ {
      config = "source ${toString ./neovim.vim}\n";
      plugin = pkgs.callPackage ./neovim.nix {};
    } ];
  };

  xdg.configFile = {
    "zk/config.toml".source          =
      let toml = pkgs.formats.toml {}; in toml.generate "config.toml" {
        extra.lang      = "en_us";
        format.markdown = { link-drop-extension = false; };
        note            = {
          default-title = "{{date now 'timestamp'}}";
          filename      = "{{slug title}}";
          template      = toString ./note-template.md;
        };
        tool            = {
          editor      = "${config.programs.neovim.finalPackage}/bin/nvim";
          fzf-preview = "${pkgs.glow}/bin/glow --style light {-1}";
        };
      };
  };
}
