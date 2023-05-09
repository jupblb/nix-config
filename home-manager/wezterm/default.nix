{ pkgs, ... }: {
    programs.wezterm = {
      enable      = true;
      extraConfig = ''
        local fish = { '${pkgs.fish}/bin/fish', '-l' }
        local font_size = font_size or 14.0
        ${builtins.readFile ./config.lua}
      '';
    };
}
