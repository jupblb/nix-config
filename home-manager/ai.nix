{ pkgs, ... }: {
  home = {
    packages = with pkgs; [ amp-cli gemini-cli ];
  };
}
