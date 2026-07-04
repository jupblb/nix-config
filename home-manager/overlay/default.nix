final: prev: {
  fishPlugins = prev.fishPlugins // {
    async-prompt = prev.fishPlugins.async-prompt.overrideAttrs(old: rec {
      # https://github.com/acomagu/fish-async-prompt/pull/95
      src     = final.applyPatches({
        src     = final.fetchFromGitHub {
          owner  = "acomagu";
          repo   = "fish-async-prompt";
          rev    = "v${version}";
          sha256 = "sha256-HWW9191RP//48HkAHOZ7kAAAPSBKZ+BW2FfCZB36Y+g=";
        };
        patches = [
          (final.fetchpatch {
            url  = "https://github.com/acomagu/fish-async-prompt/pull/95.patch";
            hash = "sha256-+IaFHqlro0XAQ8e7pVkwNHyMQ9fI95jQffL1zIytZvk=";
          })
        ];
      });
      version = "1.3.0";
    });
    nix-env      = rec {
      pname   = "nix-env";
      src     = final.fetchFromGitHub {
        owner  = "lilyball";
        repo   = "nix-env.fish";
        rev    = "7b65bd228429e852c8fdfa07601159130a818cfa";
        sha256 = "sha256-RG/0rfhgq6aEKNZ0XwIqOaZ6K5S4+/Y5EEMnIdtfPhk=";
      };
      version = "2021-11-29";
    };
  };
  fortune     = prev.fortune.override({ withOffensive = true; });
  vimPlugins  = prev.vimPlugins // {
    amp-nvim   = final.vimUtils.buildVimPlugin(rec {
      pname   = "amp.nvim";
      src     = final.fetchFromGitHub({
        owner  = "sourcegraph";
        repo   = pname;
        rev    = "b851d97d8e8782e58343608d8de7d9eb3a88090f";
        sha256 = "sha256-SdpKR1hfSyJ25tD7G1u4wYOHRNyeuTKbdMKG80iCUB4=";
      });
      version = "2025-12-17";
    });
    zoekt-nvim = final.vimUtils.buildVimPlugin(rec {
      pname   = "zoekt.nvim";
      src     = final.fetchFromGitHub({
        owner  = "jupblb";
        repo   = pname;
        rev    = "5d943d3e6aee297b23020a035a23785f7ec45737";
        sha256 = "sha256-l6zNoKVmC2hw+YDa4aj28zlFvaxF91QlVOGo/fwIqu0=";
      });
      version = "2025-09-22";
    });
  };
}
