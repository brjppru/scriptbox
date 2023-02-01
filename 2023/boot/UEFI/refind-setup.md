Deploying rEFInd on Ubuntu 16.04 LTS with secure boot enabled
-------------------------------------------------------------

Hello guys,

For these dual-booting Ubuntu 16.04 with an alternate operating system in UEFI boot mode, it may often be necessary to use a third-party boot manager such as rEFInd, as it's significantly superior to grub2's on UEFI-capable systems.  

This write-up assumes that:

(a). The user is running a current Ubuntu 16.04LTS operating system installation (preferably on a dual-boot system)

(b). The user can safely use the terminal (emulator of choice)

(c). That said user can interact with system tools with appropriate permission levels (privileges) as needed.


And that he/she absolves the author of any damage, instability or other consequences incurred as a result of using the instructions below to accomplish the set objectives highlighted therein. 

You can install rEFInd from a PPA:

    $ sudo apt-add-repository ppa:rodsmith/refind
    $ sudo apt-get update
    $ sudo apt-get install refind

It will recommend doing so to the ESP, accept the default.

If you wish to change this behavior (for any reason), you can always do so by:

    $ sudo dpkg-reconfigure refind
You may also wish to use the *refind-install* script (available from the package), remember to pass to it appropriate arguments should you choose not to deploy with defaults.

The recommended installation prerequisites are *openssl*,*sbsigntool* and *shim*. Use your package manager or an alternate installation method as per your needs. For example, one may wish to use [Fedora's shim](https://docs.fedoraproject.org/en-US/Fedora/18/html/UEFI_Secure_Boot_Guide/sect-UEFI_Secure_Boot_Guide-Implementation_of_UEFI_Secure_Boot-Shim.html) instead of Ubuntu's signed shim. Another user may wish to build openssl and sbsigntool from source or even fetch them from a third-party such as [OpenSUSE build service](https://build.opensuse.org/package/show/home:jejb1:UEFI/sbsigntools).

A more recommended installation option that will result in a working deployment with **secure boot tools** (if installed on your host and secure boot enabled on Ubuntu 16.04LTS) would be possible by running:

 

    refind-install --shim /boot/efi/EFI/ubuntu/shimx64.efi --localkeys

Let's break down the options:

(a).**refind-install**: This launches the refind-install script.

(b). **--shim**: This argument should point to a valid location of a *signed shim binary* on the ESP. As noted, the ESP on Linux is mounted on /boot , and as such, the location of the shim binary on Ubuntu 16.04LTS is therefore /boot/efi/EFI/ubuntu/shimx64.efi (This location is dependent on your distribution vendor, and thus, on Fedora or RHEL, may differ. Double-check to confirm).

(c). **--localkeys**: If you have the required packages installed (shim, sbsigntools and openssl), this option tells refind-install to generate and sign the refind EFI binary.

When done with the refind-install script (and it's arguments), please run:

    refind-mkdefault

That sets rEFInd as the **default boot entry** on your UEFI firmware's NVRAM entries via efibootmgr.
On properly configured firmware, that should run without a hitch. Incase of firmware bugs, you may need to boot into an **EFI shell** and modify the boot order via *bcfg*.

At the moment, that option above may not work due to an outstanding bug in [sbsigntools](https://bugs.launchpad.net/ubuntu/+source/sbsigntool/+bug/1574372) package on Ubuntu 16.04, and for this reason I've provided the full instructions required to successfully replicate this manually.


Setting it up to work with Secure Boot enabled:
-----------------------------------------------

For secure boot, a little manual work is required as the packages provided by the PPA are not signed by default, unless you re-installed the package using the --localkeys argument passed to the refind-install script.

**Manual work:**

You'll need to copy over *shimx64* and *MokManager* from the Ubuntu sub-directory in the ESP to the one where Refind's binary lies:

    sudo cp -vr /boot/efi/EFI/ubuntu/{MokManager.efi,shimx64.efi} /boot/efi/EFI/Boot

Then you will need to generate a key and a certificate with which to sign your EFI binary with:

    openssl req -new -x509 -newkey rsa:2048 -keyout refind_local.key \
      -out refind_local.crt -nodes -days 7300 -subj "/CN=Your name/"
    
    openssl x509 -in refind_local.crt -out refind_local.cer -outform DER

The first command generates the key with a validity of ~20 years (change -days argument as needed), with the name identifier set to your own (set -subj "/CN=whatever name you choose").

The second command generates a valid .cer file (converted from the input .crt that you supplied to openssl) as that format is used by MokManager when enrolling the certificate to the MOK. Very important.

Now, you will need to copy the keys to a secure location where only you can read them.

Then copy the refind_local.cer (The one you generated with the second OpenSSL command above) to the ESP's keys subdirectory under the Boot directory. This is needed by MokManager after reboot for enrollment with the MOK.

    
    cp -vr path-to-refind_local.cer /boot/efi/EFI/Boot/keys
   

Now, remember to rename the *refindx64.efi* binary to *grubx64.efi* as shim is hard-coded to launch grubx64.efi, and that is why we copied it over to this location on the ESP.
On some installations (as mine from the Ubuntu PPA), this binary may carry a different name such as Bootx64.efi. Remane as appropriate:

    sudo mv /boot/efi/EFI/Boot/Bootx64.efi /boot/efi/EFI/Boot/grubx64.efi

Now, sign the package as appropriate with sbsigntools:

    sudo sbsign --key refind_local.key --cert refind_local.crt --output /boot/efi/EFI/Boot/grubx64.efi.signed /boot/efi/EFI/Boot/grubx64.efi

Verify that the package is signed correctly (with sbsigntools):

    sbverify --cert refind_local.crt /boot/efi/EFI/Boot/grubx64.efi.signed

    warning: data remaining[207856 vs 231656]: gaps between PE/COFF sections?
    Signature verification OK

The warning on the gaps between PE/COFF sections on the EFI binary may be safely ignored.

Now, you will need to delete grubx64.efi and rename the grubx64.efi.signed back to grubx64.efi.

    sudo rm -fr /boot/efi/EFI/Boot/grubx64.efi && mv /boot/efi/EFI/Boot/grubx64.efi.signed /boot/efi/EFI/Boot/grubx64.efi

You will need to add rEFInd to the EFI Boot's NVRAM as a boot option:

    $ efibootmgr --create --disk /dev/mapper/isw_ebbjccfaba_Volume1 --part 1 --loader /EFI/Boot/shimx64.efi --label "rEFInd Boot Manager"

**Observation:** You may have observed that we treated the shim as the boot loader and not the refind's renamed binary.
Remember that note we made above about shim?
Shim is required to launch the signed boot-loader (in this case, the renamed rEFInd EFI binary).
To get an in-depth understanding of what shim is, and what it does, see Matthew Garrett's write-up on the same [here](https://mjg59.dreamwidth.org/19448.html).
    
Note that on my system, I'm using **[Intel IMSM RAID](http://www.intel.com/content/www/us/en/support/boards-and-kits/000006040.html)** and as such, my volume is accessible from that particular path. Adjust as necessary.

For most people using standard hard drives and partitioning, this ought to do, confirm your mount points first via df -h on Linux. Note that the ESP is ALWAYS mounted under /boot on modern Linux distributions:

    $ efibootmgr --create --disk /dev/sda Volume1 --part 1 --loader /EFI/Boot/shimx64.efi --label "rEFInd Boot Manager"

Now, make rEFInd the *default boot option* as needed:

Type 

    $sudo efibootmgr -v 

To view your current boot entries. After you type your password, you'll see something like this:

    BootCurrent: 0000
    Timeout: 0 seconds
    BootOrder: 0000,0002,0005,0001,0003,0004
    Boot0000* rEFInd Boot Manager	HD(1,GPT,9051ab36-c44b-4c60-91ad-26f546bae9cc,0x800,0x72000)/File(\EFI\Boot\shimx64.efi)
    Boot0001* Windows Boot Manager	HD(1,GPT,9051ab36-c44b-4c60-91ad-26f546bae9cc,0x800,0x72000)/File(\EFI\Microsoft\Boot\bootmgfw.efi)
    Boot0002* ubuntu	HD(1,GPT,9051ab36-c44b-4c60-91ad-26f546bae9cc,0x800,0x72000)/File(\EFI\ubuntu\shimx64.efi)
    Boot0003* UEFI: IP4 Qualcomm Atheros PCIe Network Controller	PciRoot(0x0)/Pci(0x1c,0x3)/Pci(0x0,0x0)/MAC(40167e0b3328,0)/IPv4(0.0.0.0:0<->0.0.0.0:0,0,0)..BO
    Boot0004* UEFI: IP6 Qualcomm Atheros PCIe Network Controller	PciRoot(0x0)/Pci(0x1c,0x3)/Pci(0x0,0x0)/MAC(40167e0b3328,0)/IPv6([::]:<->[::]:,0,0)..BO
    Boot0005* Windows Boot Manager	HD(1,GPT,9051ab36-c44b-4c60-91ad-26f546bae9cc,0x800,0x72000)/File(\EFI\refind\refind_x64.efi)WINDOWS.........x...B.C.D.O.B.J.E.C.T.=.{.9.d.e.a.8.6.2.c.-.5.c.d.d.-.4.e.7.0.-.a.c.c.1.-.f.3.2.b.3.4.4.d.4.7.9.5.}...a................
    Boot0007* ubuntu	HD(1,GPT,9051ab36-c44b-4c60-91ad-26f546bae9cc,0x800,0x72000)/File(\EFI\Ubuntu\grubx64.efi)


Your details will be different, of course. You need to identify your entries and figure out the order in which you want them to appear. For instance, suppose you had these entries you wanted to boot rEFInd via shim by default, then rEFInd via PreLoader second, followed by Ubuntu and then finally Fedora if all the others fail. The desired order would then be 0000,0002,0003,0001. You can then specify that order via the *-o* option to efibootmgr: (That's my example below).

    sudo efibootmgr -o 0000,0002,0005,0001,0003,0004

The output will include a less verbose repeat of the original output, with the BootOrder line changed appropriately. Double-check that your changes are correct, then reboot to test that it's working. 

On rebooting, enter the UEFI settings ("Bios"), enable secure boot and resume booting. This should launch MokManager. Now, use MokManager to enroll refind_local.crt to the MOK. You'll have to navigate to the ESP's Keys sub-directory under the Boot directory on the ESP. The next reboot should be butter smooth, with secure boot enabled on your (dual-boot or otherwise) setup with rEFInd.

**Warning**: Ubuntu 16.04's *sbsigntool* package has a bug that causes the sbsign utility to crash randomly. (See [this](https://bugs.launchpad.net/ubuntu/+source/sbsigntool/+bug/1574372) bug report for details.) When installing Ubuntu with Secure Boot active from the PPA, this bug will be triggered and is likely to prevent successful installation. 
Therefore, I recommend you disable Secure Boot or install from the Debian package (with the sbsigntool package uninstalled) to avoid this problem. 
This bug does not exist in Ubuntu 15.10 and earlier.

It is for this reason that we install this package the manual way. And it's totally worth it.

Life after secure boot:
-----------------------

One thing you'll notice is that Ubuntu 16.04 now enforces a signed module policy for all kernels, and as such, all kernel modules must be signed before they can be loaded.

See [this](https://blueprints.launchpad.net/ubuntu/+spec/foundations-x-installing-unsigned-secureboot) and [this](https://bugs.launchpad.net/ubuntu/+source/dkms/+bug/1574727) for more details.

Some "bugs" have been filed related to this new policy, and you can see their progress here:

1. https://bugs.launchpad.net/ubuntu/+source/grub2/+bug/1571388
2. https://bugs.launchpad.net/ubuntu/+source/bcmwl/+bug/1572659

There may be more, and others will keep cropping up with the use of DKMS modules, which, by definition, are mostly out-of-tree, such as proprietary drivers.

This is not a bug, it is a feature.

When you install a DKMS package you are compiling the package yourself, thus, **Canonical cannot sign the module for you.**

However, you can definitely use Secure Boot, and this is exactly the use case where Secure Boot is trying to protect you from yourself because it cannot know whether you trust a module or don't.

By default, there is a **Platform Key (PK)** on your UEFI machine, which is the **ultimately trusted Certificate Authority** for loading code in your processor.

**GRUB, or shim, or other boot mechanisms can be digitally signed by a KEK which is trusted by the root CA (PK)**, and thus your computer can, without any configuration, boot software like Ubuntu Live USB/DVDs, and this is what we replicate here with rEFInd.

On Ubuntu 16.04 the kernel is built with *CONFIG_MODULE_SIG_FORCE=1*, which means that the kernel will enforce modules to be signed by a trusted key in the platform. Take into consideration that the UEFI platform by default contains a PK that you do not have any control over (unless you setup your UEFI firmware to boot in setup mode so you can replace the default keys with your own, a scenario we do not cover here).

Some people bash and rant against that, but there is really no better way (from a security standpoint) than it being yourself who enrolls the new key you want.

If your boot system uses shim, you can use the **Machine Owner's Key database**, and enroll your key as a MOK (You can do that with *mokutil*). If you don't, you can also enroll your key in the UEFI database as a signing key.

After you enroll your key, you can sign your DKMS-built package with your MOK (there should be a perl script at */usr/src/kernels/$(uname -r)/scripts/sign-file*), and after it is signed, you can load it into the kernel.

You must therefore sign the DKMS modules you have on your system (see dkms status to see installed modules) with the keys you generated and enrolled via the MokManager as shown below:

1. Navigate to the directory containing your keys:
2. Copy the following files as instructed:  

cp refind_local.key MOK.priv &&  cp refind_local.cer MOK.der

      
3. Sign your modules (With that info) as it's already present in the MOK.
The example provided below illustrates how you'd go on about signing a particular module by its' name:
`sudo /usr/src/linux-headers-$(uname-r)/scripts/sign-file sha256 ./MOK.priv ./MOK.der $(modinfo -n name)`

For instance, to sign Broadcom's BCMWL DKMS modules (wl), you'd run the command as shown:

    sudo /usr/src/linux-headers-$(uname -r)/scripts/sign-file sha256 ./MOK.priv ./MOK.der $(modinfo -n wl)

Where *wl* is the module name. 

More examples from my current DKMS setup:

    sudo /usr/src/linux-headers-$(uname -r)/scripts/sign-file sha256 ./MOK.priv ./MOK.der $(modinfo -n nvidia_361)
    sudo /usr/src/linux-headers-$(uname -r)/scripts/sign-file sha256 ./MOK.priv ./MOK.der $(modinfo -n nvidia_361_uvm)
    sudo /usr/src/linux-headers-$(uname -r)/scripts/sign-file sha256 ./MOK.priv ./MOK.der $(modinfo -n nvidia_361_modeset)
    sudo /usr/src/linux-headers-$(uname -r)/scripts/sign-file sha256 ./MOK.priv ./MOK.der $(modinfo -n bbswitch)
    sudo /usr/src/linux-headers-$(uname -r)/scripts/sign-file sha256 ./MOK.priv ./MOK.der $(modinfo -n snd_hda_codec)
    sudo /usr/src/linux-headers-$(uname -r)/scripts/sign-file sha256 ./MOK.priv ./MOK.der $(modinfo -n snd_hda_codec-ca0132)
    sudo /usr/src/linux-headers-$(uname -r)/scripts/sign-file sha256 ./MOK.priv ./MOK.der $(modinfo -n snd_hda_codec-analog)
    sudo /usr/src/linux-headers-$(uname -r)/scripts/sign-file sha256 ./MOK.priv ./MOK.der $(modinfo -n snd_hda_codec-ca0110)
    sudo /usr/src/linux-headers-$(uname -r)/scripts/sign-file sha256 ./MOK.priv ./MOK.der $(modinfo -n snd_hda_codec-conexant)
    sudo /usr/src/linux-headers-$(uname -r)/scripts/sign-file sha256 ./MOK.priv ./MOK.der $(modinfo -n snd_hda_codec-cirrus)
    sudo /usr/src/linux-headers-$(uname -r)/scripts/sign-file sha256 ./MOK.priv ./MOK.der $(modinfo -n snd_hda_codec-cmedia)
    sudo /usr/src/linux-headers-$(uname -r)/scripts/sign-file sha256 ./MOK.priv ./MOK.der $(modinfo -n snd_hda_codec-idt)
    sudo /usr/src/linux-headers-$(uname -r)/scripts/sign-file sha256 ./MOK.priv ./MOK.der $(modinfo -n snd_hda_codec-generic)
    sudo /usr/src/linux-headers-$(uname -r)/scripts/sign-file sha256 ./MOK.priv ./MOK.der $(modinfo -n snd_hda_codec-hdmi)
    sudo /usr/src/linux-headers-$(uname -r)/scripts/sign-file sha256 ./MOK.priv ./MOK.der $(modinfo -n snd_hda_codec-si3054)
    sudo /usr/src/linux-headers-$(uname -r)/scripts/sign-file sha256 ./MOK.priv ./MOK.der $(modinfo -n snd_hda_codec-realtek)
    sudo /usr/src/linux-headers-$(uname -r)/scripts/sign-file sha256 ./MOK.priv ./MOK.der $(modinfo -n snd_hda-codec-via)
    sudo /usr/src/linux-headers-$(uname -r)/scripts/sign-file sha256 ./MOK.priv ./MOK.der $(modinfo -n snd_hda-core)
    sudo /usr/src/linux-headers-$(uname -r)/scripts/sign-file sha256 ./MOK.priv ./MOK.der $(modinfo -n snd_hda-ext-core)
    sudo /usr/src/linux-headers-$(uname -r)/scripts/sign-file sha256 ./MOK.priv ./MOK.der $(modinfo -n snd_hda_intel)
    sudo /usr/src/linux-headers-$(uname -r)/scripts/sign-file sha256 ./MOK.priv ./MOK.der $(modinfo -n wl)

Ensure that the command is ran from the directory holding your previously generated keys.

DKMS tips:
----------

See the list of DKMS packages on your Ubuntu system and their status:

    sudo dkms status

One-liners to rebuild them all:

    ls /usr/src/linux-headers-* -d | sed -e 's/.*linux-headers-//' | \
      sort -V | tac | sudo xargs -n1 /usr/lib/dkms/dkms_autoinstaller start

Another one using xargs:

    ls /var/lib/initramfs-tools | sudo xargs -n1 /usr/lib/dkms/dkms_autoinstaller start

Listing out all built module files on DKMS:

    ls -al /lib/modules/$(uname -r)/updates/dkms/


Confirmation after a successful boot:

You can confirm that secure boot is available and enabled by running:

    sudo mokutil --sb-state

The output should be as follows:

    SecureBoot enabled.

That's all. Have fun with secure boot :-)

















