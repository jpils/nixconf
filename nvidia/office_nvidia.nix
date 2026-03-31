{ pkgs, config, ... }:

{
    hardware = {
        graphics = {
            enable = true;
            # 32-bit support is often needed for Steam/Games on a 3070 Ti
            enable32Bit = true; 
        };

        nvidia = {
            # Keeps the 3070 Ti stable on Wayland
            modesetting.enable = true;
            
            powerManagement.enable = true;
            powerManagement.finegrained = false;

            open = true; # Using the Open modules is great for 30-series
            nvidiaSettings = true;
            package = config.boot.kernelPackages.nvidiaPackages.latest;
        };
    };

    # Force the kernel to allocate space to save your GPU's 'brain'
	boot.kernelParams = [
	  "nvidia-drm.modeset=1"
	  "nvidia.NVreg_PreserveVideoMemoryAllocations=1"
	  # Explicitly remove fbdev for Wayland
	];

    services.xserver.videoDrivers = ["nvidia"];

    # Add suspend/resume workaround
    systemd.services.nvidia-suspend = {
        description = "Reload NVIDIA drivers on suspend";
        wantedBy = [ "sleep.target" ];
        before = [ "systemd-suspend.service" ];
        script = ''
            sleep 1
            ${pkgs.kmod}/bin/modprobe -r nvidia_drm nvidia_modeset nvidia_uvm nvidia
            sleep 2
        '';
        serviceConfig = {
            Type = "oneshot";
            RemainAfterExit = false;
        };
    };

    systemd.services.nvidia-resume = {
        description = "Reload NVIDIA drivers after resume";
        wantedBy = [ "resume.target" ];
        after = [ "systemd-resume.service" ];
        script = ''
            sleep 2
            ${pkgs.kmod}/bin/modprobe nvidia nvidia_uvm nvidia_modeset nvidia_drm
        '';
        serviceConfig = {
            Type = "oneshot";
            RemainAfterExit = false;
        };
    };
}
