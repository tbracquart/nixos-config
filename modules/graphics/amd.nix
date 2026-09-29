{ config, lib, pkgs, ... }:

let
  cfg = config.my.graphics.amd;
in
{
  options.my.graphics.amd.enable = lib.mkEnableOption
    "le support graphique AMD";

  config = lib.mkIf cfg.enable {
    # Pilote noyau chargé tôt (évite l'écran noir/flash au démarrage)
    boot.initrd.kernelModules = [ "amdgpu" ];

    # Pilote Xorg/Wayland (le nom reste "amdgpu")
    services.xserver.videoDrivers = [ "amdgpu" ];

    hardware.graphics = {
      enable = true;
      enable32Bit = true; # Steam, Wine, jeux 32 bits

      extraPackages = with pkgs; [
        # OpenCL (Mesa Rusticl est déjà inclus ; ROCm en complément)
        rocmPackages.clr.icd

        # Accélération vidéo matérielle (VA-API / VDPAU)
        libva
        libva-utils
        libvdpau-va-gl
      ];

      extraPackages32 = with pkgs.pkgsi686Linux; [
        libva
      ];
    };

    # Force le pilote VA-API Mesa pour la lecture vidéo accélérée
    environment.sessionVariables = {
      LIBVA_DRIVER_NAME = "radeonsi";
      VDPAU_DRIVER = "radeonsi";
    };

    # Chemin HIP attendu par certains logiciels (Blender, PyTorch ROCm, etc.)
    systemd.tmpfiles.rules = [
      "L+ /opt/rocm/hip - - - - ${pkgs.rocmPackages.clr}"
    ];

    # Outils de diagnostic et de monitoring
    environment.systemPackages = with pkgs; [
      radeontop      # usage GPU en terminal
      nvtopPackages.amd # équivalent de htop pour GPU
      vulkan-tools   # vulkaninfo, vkcube
      clinfo         # infos OpenCL
      mesa-demos     # glxinfo, glxgears
    ];

    # Optionnel : panneau de contrôle (fréquences, ventilateurs, undervolt)
    # services.lact.enable = true;

    # Optionnel : débloquer overclocking / contrôle des ventilateurs
    # boot.kernelParams = [ "amdgpu.ppfeaturemask=0xffffffff" ];
  }
}
