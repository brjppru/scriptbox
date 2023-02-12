#!/bin/bash

# brjed@cloud templatatator-creator
# https://github.com/brjppru/scriptbox/tree/main/2023/emulators/proxmox/brjed-cloud-init

# see ref: https://docs.openstack.org/image-guide/obtain-images.html
# then download devel-deily build's can get 404 erorror

# Create template args: vm_id vm_name file name in the current directory

function create_template() {
    # Print all of the configuration
    echo "# ----------------------------------------------------- >"
    echo "Creating template $2 ($1)"

    # Destroy template if exist
    qm destroy $1

    # Create new VM 

    # Feel free to change any of these to your liking
    qm create $1 --name $2 --ostype l26

    # Set networking to default bridge
    qm set $1 --net0 virtio,bridge=vmbr0

    # Set display to serial
    qm set $1 --serial0 socket --vga serial0

    # Set memory, cpu, type
    qm set $1 --memory 1024 --cores 1 --cpu host

    # Set boot device to new file
    qm set $1 --scsi0 ${storage}:0,import-from="$(pwd)/$3",discard=on

    # Set scsi hardware
    qm set $1 --boot order=scsi0 --scsihw virtio-scsi-single

    # Enable Qemu guest agent
    qm set $1 --agent enabled=1,fstrim_cloned_disks=1

    # Add rng0 to system 
    qm set $1 --rng0=/dev/urandom

    # Add cloud-init device
    qm set $1 --ide2 ${storage}:cloudinit

    # Set CI ip config
    qm set $1 --ipconfig0 "ip=dhcp"

    # Import the ssh keyfile
    qm set $1 --sshkeys ${ssh_keyfile}
    # If you want to do password-based auth instaed
    # Then use this option and comment out the line above
    # qm set $1 --cipassword password

    # Add the user
    qm set $1 --ciuser ${username}

    #Resize the disk to 8G, a reasonable minimum. You can expand it more later.
    qm disk resize $1 scsi0 8G

    # Make it a template
    qm template $1

    # Remove file when done
    rm $3
}

# ----------------------------------------------------- > 
# real begin here
# ----------------------------------------------------- > 

# sshing :-)
#
# Path to your ssh authorized_keys file
# Alternatively, use /etc/pve/priv/authorized_keys if you are already authorized on the Proxmox system
# or get it like curl https://github.com/brjppru.keys > /root/cloud-init-images/authorized_keys
export ssh_keyfile=/root/.ssh/authorized_keys2

# Username to create on VM template
export username=brjed

# Name of your storage
export storage=local-lvm

# The images that I've found premade, feel free to add your own

# ----------------------------------------------------- > 
## Debian
# ----------------------------------------------------- > 

# Buster (10)
wget "https://cloud.debian.org/images/cloud/buster/latest/debian-10-genericcloud-amd64.qcow2"
create_template 900 "tmplt-debian-10" "debian-10-genericcloud-amd64.qcow2"

# Bullseye (11)
wget "https://cloud.debian.org/images/cloud/bullseye/latest/debian-11-genericcloud-amd64.qcow2"
create_template 901 "tmplt-debian-11" "debian-11-genericcloud-amd64.qcow2" 

# Bookworm (12 - not yet released)
wget "https://cloud.debian.org/images/cloud/bookworm/latest/debian-12-genericcloud-amd64.qcow2"
create_template 902 "tmplt-debian-12" "debian-12-genericcloud-amd64.qcow2" 

# ----------------------------------------------------- > 
## Ubuntu
# ----------------------------------------------------- > 

# 20.04 (Focal Fossa)
wget "https://cloud-images.ubuntu.com/focal/current/focal-server-cloudimg-amd64.img"
create_template 910 "tmplt-ubuntu-20-04" "focal-server-cloudimg-amd64.img" 

# 22.04 (Jammy Jellyfish)
wget "https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img"
create_template 911 "tmplt-ubuntu-22-04" "jammy-server-cloudimg-amd64.img" 

# 23.04 (Lunar Lobster) - daily builds
wget "https://cloud-images.ubuntu.com/lunar/current/lunar-server-cloudimg-amd64.img"
create_template 912 "tmplt-ubuntu-23-04" "lunar-server-cloudimg-amd64.img"

# ----------------------------------------------------- > 
## Fedora 37
# ----------------------------------------------------- > 

# Image is compressed, so need to uncompress first
wget https://download.fedoraproject.org/pub/fedora/linux/releases/37/Cloud/x86_64/images/Fedora-Cloud-Base-37-1.7.x86_64.raw.xz
xz -d -v Fedora-Cloud-Base-37-1.7.x86_64.raw.xz
create_template 920 "tmplt-fedora-37" "Fedora-Cloud-Base-37-1.7.x86_64.raw"

# ----------------------------------------------------- > 
## Rocky
# ----------------------------------------------------- > 

wget "https://dl.rockylinux.org/pub/rocky/8/images/x86_64/Rocky-8-GenericCloud-Base.latest.x86_64.qcow2"
create_template 930 "tmplt-rocky-8" "Rocky-8-GenericCloud-Base.latest.x86_64.qcow2"

wget "https://dl.rockylinux.org/pub/rocky/9/images/x86_64/Rocky-9-GenericCloud-Base.latest.x86_64.qcow2"
create_template 931 "tmplt-rocky-9" "Rocky-9-GenericCloud-Base.latest.x86_64.qcow2"

#
# ----------------------------------------------------- > 
# The end, yopta!
