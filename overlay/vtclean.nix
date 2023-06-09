{ buildGoModule, fetchFromGitHub }: buildGoModule rec {
    pname      = "vtclean";
    src        = fetchFromGitHub {
      owner  = "lunixbochs";
      repo   = pname;
      rev    = version;
      sha256 = "sha256-xRfQnJ4NFajUxu6VZ9qObFQ3Tczoh9mHq7ggkp7BAFs=";
    };
    vendorHash = null;
    version    = "master";
}
