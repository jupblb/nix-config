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
      commands    = {
        fzf_open = "\${{${builtins.readFile ./fzf-open.sh}}}";
      };
      enable      = true;
      extraConfig =
        let cleaner = pkgs.writeScript "lf-cleaner"
          (builtins.readFile ./cleaner.bash);
        in ''
          set cleaner ${cleaner}
          map <a-c> :fzf_open d
          map <c-t> :fzf_open f
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
        command = "${pkgs.jq}/bin/jq --color-output . %pistol-filename%";
        mime    = "application/json";
      } {
        command = "${pkgs.poppler_utils}/bin/pdftotext %pistol-filename% -";
        mime    = "application/pdf";
      } {
        command =
          "sh: ${pkgs.exa}/bin/exa -RT --color=always --icons %pistol-filename% | head -10000";
        mime    = "inode/directory";
      } {
        command = "${pkgs.bat}/bin/bat --style=numbers --color=always %pistol-filename%";
        mime    = "text/*";
      } {
        command = "${pkgs.glow}/bin/glow -s light -- %pistol-filename%";
        fpath   = ".*.md$";
      } ];
      enable       = true;
    };
  };

  xdg.configFile = {
    "lf/icons".source                = pkgs.fetchurl {
      sha256 = "04jnldz0y2fj4ymypzmvs7jjbvvjrwzdp99qp9r12syfk65nh9cn";
      url    = "https://github.com/gokcehan/lf/raw/master/etc/icons.example";
    };
  };
}
