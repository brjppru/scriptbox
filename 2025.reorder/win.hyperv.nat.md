# hyper-v travarsal nat

add internal switch and setup travarsal nat

```
New-NetNat -Name nat-my -InternalIPInterfaceAddressPrefix 10.11.12.0/24
Add-NetNatStaticMapping -ExternalIPAddress "0.0.0.0/24" -ExternalPort 25  -Protocol TCP -InternalIPAddress "10.11.12.2" -InternalPort 25 -NatName nat-my
Add-NetNatStaticMapping -ExternalIPAddress "0.0.0.0/24" -ExternalPort 465 -Protocol TCP -InternalIPAddress "10.11.12.2" -InternalPort 465 -NatName nat-my
Add-NetNatStaticMapping -ExternalIPAddress "0.0.0.0/24" -ExternalPort 993 -Protocol TCP -InternalIPAddress "10.11.12.2" -InternalPort 993 -NatName nat-my

Add-NetNatStaticMapping -ExternalIPAddress "0.0.0.0/24" -ExternalPort 80  -Protocol TCP -InternalIPAddress "10.11.12.3" -InternalPort 80 -NatName nat-my
Add-NetNatStaticMapping -ExternalIPAddress "0.0.0.0/24" -ExternalPort 443 -Protocol TCP -InternalIPAddress "10.11.12.3" -InternalPort 443 -NatName nat-my

```
