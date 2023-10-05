{ pkgs, ... }: {
  home = {
    packages         = with pkgs; [ fd ];
    sessionVariables = {
      ZO_METHOD = "lf";
    };
  };

  programs = {
    fish.functions = {
      lf = builtins.readFile ./lf-vim.fish;
    };

    lf = {
      enable      = true;
      extraConfig =
        let cleaner = pkgs.writeScript "lf-cleaner"
          (builtins.readFile ./cleaner.bash);
        in ''
          set cleaner ${cleaner}
          map <c-z> $ kill -STOP $PPID
        '';
      previewer   = {
        keybinding = "`";
        source     = with pkgs; writeShellScript "lf-preview" ''
          ${builtins.readFile ./previewer.bash}
          ${pkgs.pistol}/bin/pistol "$1"
        '';
      };
      settings    = { hidden = true; icons = true; tabstop = 4; };
    };

    neovim.extraConfig = ''
      autocmd BufEnter * call writefile(
        \ [expand("%:p")], "/tmp/nvim-" . $KITTY_WINDOW_ID . $WEZTERM_PANE . ".buffer")
    '';

    pistol = {
      associations = [ {
        command = "${pkgs.glow}/bin/glow -s light -- %pistol-filename%";
        fpath   = ".*.md$";
      } {
        command = "${pkgs.jq}/bin/jq --color-output . %pistol-filename%";
        mime    = "application/json";
      } {
        command = "${pkgs.poppler_utils}/bin/pdftotext %pistol-filename% -";
        mime    = "application/pdf";
      } {
        command = "${pkgs.bat}/bin/bat --style=numbers --color=always %pistol-filename%";
        mime    = "text/*";
      } ];
      enable       = true;
    };
  };

  xdg.configFile = {
    "lf/icons".source = pkgs.fetchurl {
      sha256 = "sha256-QbWr5FxJZ5cJqS4zg+qyNK8JUG6SdLmaFoBuFXi0q0M=";
      url    = "https://github.com/gokcehan/lf/raw/master/etc/icons.example";
    };
  };
}
