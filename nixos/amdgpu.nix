{ pkgs, ... }: {
  boot.initrd.kernelModules = [ "amdgpu" ];

  hardware.opengl.extraPackages = with pkgs;
    [ amdvlk rocm-opencl-icd rocm-opencl-runtime ];

  services.xserver.videoDrivers = [ "amdgpu" ];
}
