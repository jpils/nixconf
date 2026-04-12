qemu-system-x86_64 \
  -m 2048 \
  -drive file=/home/jay/.VM/eos-vm.qcow2,format=qcow2 \
  -enable-kvm \
  -net nic -net user \
  -smp cores=2 \
  -vga virtio \
  -virtfs local,path=/home/jay/Shared/,mount_tag=hostshare,security_model=mapped,id=hostshare
