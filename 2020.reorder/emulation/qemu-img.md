# Converting virtual disks for use with QEMU

```
apt-get install qemu-utils
```

Then to convert a VMware virtual disk for use with QEMU you can use a command similar to the following, where  -f vmdk  specifies that the format of the original disk image is a VMware VMDK file,  -O qcow2  specifies the output file format and  -p  displays the progress.
```
$ qemu-img convert -f vmdk -O qcow2 disk-1.vmdk disk-1.qcow2 -p
```

You can also convert virtual disks created by Virtual PC as well.
```
$ qemu-img convert -f vpc -O qcow2 disk-A.vhd disk-A.qcow2 -p  
```

Obviously converting the disk format is just the first step in the process, you will still need to make some changes to the guest operating system to accommodate the differences in the emulated hardware (install additional drivers, activation etc).
