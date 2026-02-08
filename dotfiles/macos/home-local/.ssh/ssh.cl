# CloudLinux SSH configuration

host 10.192.16.6
	User root
	IdentityFile /Users/brjed/clbrj/clbrj202507

host  10.192.4.99
	User root
	IdentityFile /Users/brjed/clbrj/infra.priv
	BatchMode yes

host  206.252.237.34
	User root
	IdentityFile /Users/brjed/clbrj/gitlab.priv

# opennebula
Host 10.100.*.*
	User rbogdanov
	IdentityFile /Users/brjed/clbrj/clbrj202507

# opennebula
Host 10.192.*.*
	User rbogdanov
	IdentityFile /Users/brjed/clbrj/clbrj202507

# opennebula
Host 10.193.*.*
	User rbogdanov
	IdentityFile /Users/brjed/clbrj/clbrj202507

Host 77.79.198.33
	User root
	IdentityFile /Users/brjed/clbrj/clbrj202507

# opennebula
Host 10.194.*.*
	User rbogdanov
	IdentityFile /Users/brjed/clbrj/clbrj202507

# opennebula
Host 10.195.*.*
	User rbogdanov
	IdentityFile /Users/brjed/clbrj/clbrj202507

# opennebula
Host 10.255.*.*
	User rbogdanov
	IdentityFile /Users/brjed/clbrj/clbrj202507

Host 10.192.4.*
	User rbogdanov
	IdentityFile /Users/brjed/clbrj/clbrj202507

Host *.*.cloudlinux.com
	User rbogdanov
	IdentityFile /Users/brjed/clbrj/clbrj202507

host 206.252.237.32
	User rbogdanov
	IdentityFile /Users/brjed/clbrj/clbrj202507

host 206.252.237.33
	User rbogdanov
	IdentityFile /Users/brjed/clbrj/clbrj202507


host 138.199.237.44
	User rbogdanov
	IdentityFile /Users/brjed/clbrj/clbrj202507

host 206.252.237.2
	User rbogdanov
	IdentityFile /Users/brjed/clbrj/clbrj202507


host 77.79.198.14
	User rbogdanov
	IdentityFile /Users/brjed/clbrj/clbrj202507

host 77.79.198.15
	User rbogdanov
	IdentityFile /Users/brjed/clbrj/clbrj202507

# ssh -J 192.168.245.254 192.168.251.253

host  192.168.245.254
	User rbogdanov
	IdentityFile /Users/brjed/clbrj/clbrj202507

host  192.168.245.253
	User rbogdanov
	IdentityFile /Users/brjed/clbrj/clbrj202507

# vm routers in nebula

#Host atm-*-node-*.corp.cloudlinux.com
#	User root
#	IdentityFile /Users/brjed/clbrj/infra.priv
#	BatchMode yes

Host gateway-*.atm.svcs.io
	User rbogdanov
	IdentityFile /Users/brjed/clbrj/clbrj202507

# =77.79.198.19/26
Host atm-jump
    HostName 192.168.251.1
    User root
    IdentityFile ~/brjed/clbrj/clbrj202507
    IdentitiesOnly yes
