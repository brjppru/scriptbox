# CloudLinux SSH configuration
# Ownership map:
# - Domains: *.*.cloudlinux.com, *.atm.svcs.io, gateway-*.atm.svcs.io
# - Networks: 10.100.*.*, 10.192.*.*, 10.193.*.*, 10.194.*.*, 10.195.*.*, 10.255.*.*
# - Jump route: jump.atm.svcs.io -> 142.132.147.88
# - Default key: /Users/brjed/clbrj/clbrj202507
# - Dedicated key: 206.252.237.34 -> /Users/brjed/clbrj/gitlab.priv

# Hosts with dedicated non-default keys
Host 206.252.237.34
	User root
	IdentityFile /Users/brjed/clbrj/gitlab.priv
	IdentitiesOnly yes

# CL jump hosts and explicit proxy target
Host jump.atm.svcs.io
	User rbogdanov
	IdentityFile /Users/brjed/clbrj/clbrj202507
	IdentitiesOnly yes
	ForwardAgent yes

Host 142.132.147.88
	User rbogdanov
	IdentityFile /Users/brjed/clbrj/clbrj202507
	IdentitiesOnly yes
	ProxyJump jump.atm.svcs.io
	ForwardAgent yes

# Aliases
Host atm-jump
	HostName 192.168.251.1
	User root
	IdentityFile /Users/brjed/clbrj/clbrj202507
	IdentitiesOnly yes

# CL defaults for root
Host 10.192.16.6 77.79.198.33
	User root
	IdentityFile /Users/brjed/clbrj/clbrj202507
	IdentitiesOnly yes

# CL defaults for rbogdanov
Host 10.100.*.* 10.192.*.* 10.193.*.* 10.194.*.* 10.195.*.* 10.255.*.*
	User rbogdanov
	IdentityFile /Users/brjed/clbrj/clbrj202507
	IdentitiesOnly yes

Host *.*.cloudlinux.com 206.252.237.2 206.252.237.32 206.252.237.33 77.79.198.14 77.79.198.15 138.199.237.44 192.168.245.253 192.168.245.254
	User rbogdanov
	IdentityFile /Users/brjed/clbrj/clbrj202507
	IdentitiesOnly yes

Host gateway-*.atm.svcs.io *.atm.svcs.io
	User rbogdanov
	IdentityFile /Users/brjed/clbrj/clbrj202507
	IdentitiesOnly yes
