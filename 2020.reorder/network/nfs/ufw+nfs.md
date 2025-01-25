# ufw + nfs #

Â Start by ensuring that you have the basic NFS ports open. Â These are going to be 2049 (udp/tcp) for NFS, and 111 (udp/tcp) for “sunrpc”. Â You can add both of these with a straightforward ufw rule, relying on /etc/services to identify the ports. Â For example, assuming that you have LCL_NET set to your local network, and only want to allow access to machines in that network:

ufw allow from ${LCL_NET} to any port nfs

ufw allow from ${LCL_NET} to any port sunrpc

/etc/default/nfs-kernel-server and change the line for RPCMOUNTDOPTS to be:

RPCMOUNTDOPTS=”-p 4001 -g”

Then go back to ufw and allow this port for both udp and tcp. 

