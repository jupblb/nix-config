let
  common   = builtins.readFile(./id_ed25519.pub);
  dionysus = builtins.readFile(./id_ed25519_dionysus.pub);
in {
  "authelia_jwt_secret.age".publicKeys             = [ common dionysus ];
  "authelia_storage_encryption_key.age".publicKeys = [ common dionysus ];
  "cloudflare_password.age".publicKeys             = [ common dionysus ];
  "cloudflared_credentials.age".publicKeys         = [ common dionysus ];
  "github_runner.age".publicKeys                   = [ common dionysus ];
  "restic_gcs_credentials.age".publicKeys          = [ common dionysus ];
  "restic_password.age".publicKeys                 = [ common dionysus ];
}
