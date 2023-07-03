{ pkgs, ... }: {
  home.packages = with pkgs; [
    (iosevka-bin.override { variant = "sgr-iosevka-term"; })
    (nerdfonts.override { fonts = [ "NerdFontsSymbolsOnly" ]; })
  ];

  fonts.fontconfig.enable = true;

  programs.wezterm = {
    enable      = true;
    extraConfig = ''
      local fish = { '${pkgs.fish}/bin/fish', '-l' }
      local font_size = font_size or 14.0
      ${builtins.readFile ./config.lua}
    '';
  };
}
