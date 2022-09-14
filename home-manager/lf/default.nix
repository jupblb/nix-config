{ pkgs, ... }: {
  programs = {
    fish = {
      functions.lfv = builtins.readFile ./lfv.fish;
    };

    lf = {
      cmdKeybindings = {
        "<c-z>" = "$ kill -STOP $PPID";
      };
      commands       = {
        open = ''
        ''${{
          case $(file --mime-type "$f" -b) in
            text/*) $EDITOR $fx;;
            *) for f in $fx; do setsid $OPENER $f > /dev/null 2> /dev/null & done;;
          esac
        }}
        '';
      };
      enable         = true;
      extraConfig    =
        let cleaner = pkgs.writeScript "lf-cleaner"
          (builtins.readFile ./cleaner.sh);
        in "set cleaner ${cleaner}";
      previewer      = {
        keybinding = "`";
        source     = with pkgs; writeShellScript "lf-preview" ''
          ${builtins.readFile ./previewer.sh}
          ${pkgs.pistol}/bin/pistol "$1"
        '';
      };
      settings       = { hidden = true; icons = true; tabstop = 4; };
    };

    pistol = {
      config = {
        "application/json" =
          "${pkgs.jq}/bin/jq --color-output . %pistol-filename%";
        "application/pdf"  =
          "${pkgs.poppler_utils}/bin/pdftotext %pistol-filename% -";
        "inode/directory"  =
          "sh: ${pkgs.exa}/bin/exa -RT --color=always --icons %pistol-filename% | head -10000";
        "text/*"           =
          "${pkgs.bat}/bin/bat --style=numbers --color=always %pistol-filename%";

        "fpath .*.md$" =
          "${pkgs.glow}/bin/glow -s light -- %pistol-filename%";
      };
      enable = true;
    };
  };

  xdg.configFile = {
    "lf/icons".source                = pkgs.fetchurl {
      sha256 = "04jnldz0y2fj4ymypzmvs7jjbvvjrwzdp99qp9r12syfk65nh9cn";
      url    = "https://github.com/gokcehan/lf/raw/master/etc/icons.example";
    };
  };
}
