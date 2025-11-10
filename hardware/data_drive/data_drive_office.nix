{ config, pkgs, ... }:

{
  fileSystems."/Data" = {
    device = "/dev/disk/by-uuid/806c5d44-1a06-44fb-b590-4528116d2e1b";
    fsType = "ext4";
    options = [ "defaults" "noatime" ];
  };
}
