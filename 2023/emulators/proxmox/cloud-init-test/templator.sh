#!/bin/sh

# brj ubuntu templator

export TEMPLATE_IMAGE="jammy-server-cloudimg-amd64"
export TEMPLATE_ID=9009

cd /root
mkdir -p cloud-init-images
cd /root/cloud-init-images/
rm -rf /root/cloud-init-images/*.*
wget https://cloud-images.ubuntu.com/jammy/current/${TEMPLATE_IMAGE}.img
sudo apt install libguestfs-tools -y
virt-customize -a ${TEMPLATE_IMAGE}.img --install qemu-guest-agent,whois,ncat,net-tools,bash-completion
mv ${TEMPLATE_IMAGE}.img ${TEMPLATE_IMAGE}.qcow2
qemu-img resize ${TEMPLATE_IMAGE}.qcow2 20G

qm create ${TEMPLATE_ID} --name "${TEMPLATE_IMAGE}-$(date +%Y%M%d)" --memory 2048 --cores 2 --net0 virtio,bridge=vmbr0
qm importdisk ${TEMPLATE_ID} jammy-server-cloudimg-amd64.qcow2 local-lvm
qm set ${TEMPLATE_ID} --scsihw virtio-scsi-single --scsi0 local-lvm:vm-${TEMPLATE_ID}-disk-0,iothread=1,cache=none,ssd=1,discard=on
qm set ${TEMPLATE_ID} --cpu host
qm set ${TEMPLATE_ID} --boot c --bootdisk scsi0
qm set ${TEMPLATE_ID} --ide2 local-lvm:cloudinit
qm set ${TEMPLATE_ID} --serial0 socket --vga serial0
qm set ${TEMPLATE_ID} --agent enabled=1
qm set ${TEMPLATE_ID} --rng0=/dev/urandom
# Update /root/cloud-init-images/authorized_keys with the latest public keys,
# one per row, in the same format as in .ssh/authorized_keys
curl https://github.com/brjppru.keys > /root/cloud-init-images/authorized_keys
qm set ${TEMPLATE_ID} --sshkeys=authorized_keys
qm template ${TEMPLATE_ID}
