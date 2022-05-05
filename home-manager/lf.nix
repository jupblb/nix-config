{ pkgs, ... }: {
  programs.lf = {
    commands    = {
      open = ''
      ''${{
        case $(file --mime-type "$f" -b) in
          text/*) $EDITOR $fx;;
          *) for f in $fx; do setsid $OPENER $f > /dev/null 2> /dev/null & done;;
        esac
      }}
      '';
    };
    enable      = true;
    previewer   = { keybinding = "`"; };
    settings    = { hidden = true; icons = true; tabstop = 4; };
  };

  xdg.configFile = {
    "lf/icons".source                = pkgs.fetchurl {
      sha256 = "04jnldz0y2fj4ymypzmvs7jjbvvjrwzdp99qp9r12syfk65nh9cn";
      url    = "https://github.com/gokcehan/lf/raw/master/etc/icons.example";
    };
  };
}
