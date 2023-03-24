{ writeShellScriptBin }:

writeShellScriptBin "nvidia-offload" (builtins.readFile ./script.sh)
