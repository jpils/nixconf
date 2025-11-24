{ config, pkgs, ... }:

{
  fileSystems."/home/jay/Data" = {
    device = "/dev/disk/by-uuid/32dd7340-dea7-47be-840f-737f02887e8c";
    fsType = "ext4";
    options = [ "defaults" "noatime" ];
  };
}
