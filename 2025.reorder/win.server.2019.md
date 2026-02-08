# Windows server 2019

## English

# set time zone in utc

- run as admin (search timedate.cpl)

# secpol

- Нажимаем Win + R или кликаем правой кнопкой мыши по иконке меню и выбираем пункт "Run"
- В строке набираем secpol.msc и жмем кнопку "OK"
- В открывшемся окне переходим "Local Policies" - "Security Options"
- Ищем "User Account Control: Admin Approval Mode for the Built-in Administrator account"
- Переключаем в "Enable"
- Update force policy / reboot / relogon

# password 
- Password must meet complexity requirements

## MTU
```
netsh interface ipv4 set subinterface eth0 mtu=1498 store=persistent
```

## ping
```
netsh advfirewall firewall add rule name="ICMP Allow incoming V4 echo request" protocol=icmpv4:8,any dir=in action=allow
```

## fuck ipv6

```
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip6\Parameters" /v DisabledComponents /t REG_DWORD /d 255 /f
```

# ssh

```
Get-WindowsCapability -Online | Where-Object Name -like 'OpenSSH*'
```
```
# Install the OpenSSH Client
Add-WindowsCapability -Online -Name OpenSSH.Client~~~~0.0.1.0

# Install the OpenSSH Server
Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0
```
```
# Start the sshd service
Start-Service sshd

# OPTIONAL but recommended:
Set-Service -Name sshd -StartupType 'Automatic'

# Confirm the Firewall rule is configured. It should be created automatically by setup. Run the following to verify
if (!(Get-NetFirewallRule -Name "OpenSSH-Server-In-TCP" -ErrorAction SilentlyContinue | Select-Object Name, Enabled)) {
    Write-Output "Firewall Rule 'OpenSSH-Server-In-TCP' does not exist, creating it..."
    New-NetFirewallRule -Name 'OpenSSH-Server-In-TCP' -DisplayName 'OpenSSH Server (sshd)' -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22
} else {
    Write-Output "Firewall rule 'OpenSSH-Server-In-TCP' has been created and exists."
}
```

- C:\ProgramData\ssh\sshd_config
- C:\Users\brjed\.ssh\authorized_keys

```
icacls.exe ""administrators_authorized_keys"" /inheritance:r /grant ""Administrators:F"" /grant ""SYSTEM:F""
icacls.exe ""authorized_keys"" /inheritance:r /grant ""Administrators:F"" /grant ""SYSTEM:F""
```

```
Get-Service ssh-agent | Select StartType
Get-Service -Name ssh-agent | Set-Service -StartupType Auto
Get-Service -Name ssh-agent | Set-Service -StartupType Manual
Start-Service ssh-agent
```
# ping

```
netsh advfirewall firewall add rule name="ICMP Allow incoming V4 echo request" protocol=icmpv4:8,any dir=in action=allow
````

# activaton

```
slmgr /dli
slmgr.vbs -skms 192.168.0.40
slmgr /ipk VDYBN-27WPP-V4HQT-9VMD4-VMK7H
slmgr /ato
```
