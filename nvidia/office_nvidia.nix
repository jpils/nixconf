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
            
            # Ampere (30-series) supports this, but it can sometimes cause 
            # flicker on wake. Keep it false first; if battery/power is 
            # a huge concern, you can try true later.
            powerManagement.finegrained = false;

            open = true; # Using the Open modules is great for 30-series
            nvidiaSettings = true;
            package = config.boot.kernelPackages.nvidiaPackages.latest;
        };
    };

    # Force the kernel to allocate space to save your GPU's 'brain'
    boot.kernelParams = [ "nvidia.NVreg_PreserveVideoMemoryAllocations=1" ];

    services.xserver.videoDrivers = ["nvidia"];
}
