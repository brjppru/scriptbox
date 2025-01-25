# get free VM #

https://www.scivision.co/free-windows-virtual-machine-images/

For years, Microsoft has been allowing legal free Windows (including Windows 10) virtual machine image downloads. You can do almost anything you want with them, but the caveat is the image is only good for 90 days. You can quickly do your setup, take a snapshot, and revert every 90 days, or setup a fresh VM image every 90 days.

This VM includes the latest PowerShell, so you can test Scoop.

This example is targeted for VirtualBox on Linux host PC, but many other combinations are possible.

Download Windows VM
unzip MSEdge.Win10*.zip which creates an .ova file if you picked VirtualBox
import image into your virtual machine software e.g. VirtualBox.
VirtualBox: check “Reinitialize the MAC address of all network cards”
Start the VM, do your setup, take a snapshot if you want to extend work with this setup beyond 90 days.

https://developer.microsoft.com/en-us/windows/downloads/virtual-machines

