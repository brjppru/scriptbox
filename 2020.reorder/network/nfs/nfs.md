# nfs #

sudo apt install nfs-kernel-server portmap

/etc/exports
/var/nfsroot     example_IP/17(rw,root_squash,subtree_check)

sudo exportfs -ra

sudo systemctl restart nfs-kernel-server

# client

sudo apt install nfs-common

example_IP:/var/nfsroot /mnt/remotenfs nfs rw,async,hard,intr,noexec 0 0
