{ apple_sdk, buildRustPackage, fetchFromGitHub }: buildRustPackage rec {
  buildInputs = with apple_sdk.frameworks; [ CoreFoundation ];
  cargoHash   = "sha256-RfKVmiFfFzIp//fbIcFce4T1cQPIFuEAw7Zmnl1Ic84=";
  pname       = "mkalias";
  src         = fetchFromGitHub {
    owner = "reckenrode";
    repo  = pname;
    rev   = "v${version}";
    hash  = "sha256-tL3C/b2BPOGQpV287wECDCDWmKwwPvezAAN3qz7N07M=";
  };
  version     = "0.3.2";
}
