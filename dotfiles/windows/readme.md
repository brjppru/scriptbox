# Windows 

## install tip&trick

version update 2024.04.27


### preinstall gpt

GPT. В окне управления дисками нажмите  shift + F10, в командной строке очистите диск и конвертируйте в GPT, потом обновите информацию в окне.

```
diskpart
sel dis 0
clean
convert gpt
exit
```

### Запустить в виртуалке

Припасу, а то забываю где гвест агент и драва качать qemu-ga-x64.msi should be the latest -> https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/latest-virtio/

## Активация

- Если у вас в BIOS нормальный слик, то windows само все подтянет и активирует. А если нет, то нет.
- https://docs.microsoft.com/en-us/windows-server/get-started/kms-client-activation-keys
- https://technet.microsoft.com/en-us/library/dn385360(v=office.16).aspx

### актуалочка

- https://github.com/massgravel/Microsoft-Activation-Scripts -> MAS A Windows and Office activator using HWID / Ohook / KMS38 / Online KMS activation methods, with a focus on open-source code and fewer antivirus detections.

### ltsc пуньк

```
slmgr /dli
slmgr -ipk M7XTQ-FN8P6-TTKYV-9D4CC-J462D
slmgr.vbs -skms 192.168.0.40
slmgr /ato
```

```
cd "C:\Program Files\Microsoft Office\Office16"
cscript ospp.vbs /sethst:192.168.0.240
cscript ospp.vbs /inpkey:KDX7X-BNVR8-TXXGX-4Q7Y8-78VT3
cscript ospp.vbs /puserops
```
### Наглухо отлетела активация
 
Слетела активация винды, ничо не помогает. Как чинить?

```
stop-service sppsvc
cd C:\Windows\System32\spp\store\2.0
ren tokens.dat tokens.bar 
start-service sppsvc
slmgr -rilc
slmgr /ato
```

## Features

## Windows Features applet

Manage optional features using the Windows Features applet. Press the Win + R keys to open Run and type ```optionalfeatures.exe``` into the Run box.

## Key Binding's

- Win + R
- Win + X
- shell:startup
- shell:appsfolder
- диспетчер задач, нажав сочетание клавиш Ctrl + Shift + Esc
- To Take a Screenshot of Part of Your Screen -> Press “Windows + Shift + S”
- Type alt+d to move to the address bar in Windows Explorer. This is useful for selecting the path to copy and paste into another application.
- During text entry, type <key>Windows<key> logo key   + . (period)

## сменить яркость

```
(Get-WmiObject -Namespace root/WMI -Class WmiMonitorBrightnessMethods).WmiSetBrightness(1,45)
```

## windows compression

```
compact /s /c /i /f /a /exe:lzx
```

Опция LZX доступна только для ядра Windows Server 2016 и 2019 и 10тки, системные файлы сжимаются только на этих редакциях, поэтому если вы хотите сэкономить место, выбор не велик.

````
compact /Compactos:always
````

## power burnin

Сжечь процессор. Ха-ха. C1 стейт еще поставить.

```
C:\Windows\system32>powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61
Power Scheme GUID: 300e4413-8397-4359-870b-f68fdfe41e78  (Ultimate Performance)
```

```
disable -> powercfg –restoredefaultschemes
```

## Display switcher

```
displayswitch.exe /internal Disconnect projector (same as "Show only on 1" from the Display Properties dialog)
displayswitch.exe /clone        Duplicate screen
displayswitch.exe /extend    Extend screen
displayswitch.exe /external Projector only (disconnect local) (same as "Show only on 2" from the Display Properties dialog)
```

## save drivers

```
Export-WindowsDriver —Online —Destination c:\temp\drivers

```

## firewall play

```
netsh advfirewall set allprofiles state off
netsh advfirewall show all
netsh advfirewall set allprofiles state on
```

## Magazinen fuckon on ltsb

```
wsreset -i
```

## Magazinen unfuckoff

remove all-shit-from-market

```
Get-AppxPackage -AllUsers | where-object {$_.name –notlike "*store*"} | Remove-AppxPackage
```

updated for windows 11

```
Get-AppxPackage -AllUsers | Where-Object { $_.IsFramework -eq $false -and $_.Name -notlike "*store*" } | Remove-AppxPackage
```

## ssh addon

```
Get-Service ssh-agent | Select StartType
Get-Service -Name ssh-agent | Set-Service -StartupType Auto
Get-Service -Name ssh-agent | Set-Service -StartupType Manual
Start-Service ssh-agent
```

## WSL2 (windows subsystem for linux)

```
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
```

Visit https://aka.ms/wsl2kernel to download a .msi package, install it, and then try again, иначе хер тебе во все рыло, а не wsl2.

```
wsl --set-default-version 2
```

## Конвертация wsl1 в wsl2

```
wsl.exe -l
wsl.exe --set-version Ubuntu-20.04 2
wsl.exe --set-version Debian 2
```

## export / import wsl

```
wsl.exe --export Ubuntu-20.04 C:\temp\brjed-ubuntu2004.tar
wsl.exe --import brjedubuntu2004 d:\wsl\brjed c:\temp\brjed-ubuntu.tar
wsl --list --all
wslconfig /list /all
wsl --setdefault brjedubuntu2004
wsl --distribution brjedubuntu2004
cd \\wsl$\brjedubuntu2004
wsl --shutdown
```

## Sandbox

```
Enable-WindowsOptionalFeature -FeatureName "Containers-DisposableClientVM" –Online
Dism /online /Enable-Feature /FeatureName:"Containers-DisposableClientVM" -All
```

  - Windows Sandbox Editor -> https://gallery.technet.microsoft.com/Windows-Sandbox-Configurati-f2c863dc
  - https://gallery.technet.microsoft.com/Windows-Sandbox-Configurati-f2c863dc/file/221934/3/Sandbox_EXE.zip

## Powershell

https://github.com/PowerShell/PowerShell

## terminal

- https://www.microsoft.com/en-us/p/windows-terminal/9n0dx20hk701?activetab=pivot:overviewtab
- https://github.com/microsoft/terminal/releases
- https://learn.microsoft.com/en-us/troubleshoot/developer/visualstudio/cpp/libraries/c-runtime-packages-desktop-bridge


```
Invoke-WebRequest -Uri https://github.com/microsoft/terminal/releases/download/v1.16.10261.0/Microsoft.WindowsTerminal_Win10_1.16.10261.0_8wekyb3d8bbwe.msixbundle
Add-AppxPackage -Path .\Microsoft.WindowsTerminal_Win10_1.16.10261.0_8wekyb3d8bbwe.msixbundle
Get-AppxPackage *WindowsTerminal* -AllUsers
Import-Module Appx -UseWindowsPowerShell
Add-AppPackage .\Microsoft.VCLibs.x64.14.00.Desktop.appx

```

```
Add-AppxPackage Microsoft.WindowsTerminal_<versionNumber>.msixbundle
```
https://github.com/microsoft/terminal/releases

# Software Intall tips

- install language (fix for oem)
- install langulage for non utf8 to russian
- activate 
- force for wumt_x64
- reboot here

- install far
- install total commander
- install https://github.com/randyrants/sharpkeys/releases
- install last fira code nerd font
- install lswitch32
- install 7zip, winrar
- install foxitreader, but disable (x) online context

- install market-terminal
- install wsl2, reboot, install market, enable wsl2, reboot install ubuntu-wsl, reboot
- https://devolutions.net/remote-desktop-manager/home/downloadfree

- https://ninite.com/7zip-firefox-foxit-keepass2-notepadplusplus-putty-qbittorrent-thunderbird-vlc-vscode-winrar-winscp/

- install telegramm.desktop
- install sublime3
- install acemoney
- install megasync
- install cobian backup? -> cobian reflector?
- install rescuetime
- install tunderbird
- install kepasslo
- install https://win7games.com/#calc
- install qbittorent
- install https://keystore-explorer.org/downloads.html
- install https://github.com/namazso/OpenHashTab
- install https://github.com/buptczq/WinCryptSSHAgent/releases

- https://github.com/rcmaehl/MSEdgeRedirect/releases
- https://github.com/Genymobile/scrcpy/blob/master/doc/windows.md
- https://github.com/lostindark/DriverStoreExplorer/releases


## fuck OneDrive

```
ps onedrive | Stop-Process -Force
start-process "$env:windir\SysWOW64\OneDriveSetup.exe" "/uninstall"
```

## unfuck onedrive

in a stalled state don't sync

```
%localappdata%\Microsoft\OneDrive\onedrive.exe /reset
```

If the OneDrive icon does not reappear in the System Tray on the far right side of the Taskbar within a few minutes, in the Run dialog

```
%localappdata%\Microsoft\OneDrive\onedrive.exe
```
to start OneFuckingDrive manually

## refuck onedrive

```
taskkill /f /im OneDrive.exe
```

## powershell refuck one drive

```
Stop-Process -processname "OneDrive" -ErrorAction SilentlyContinue
Start-Process "$env:LOCALAPPDATA\Microsoft\OneDrive\OneDrive.exe" /reset -ErrorAction SilentlyContinue
Remove-Item -Path "HKCU:\Software\Microsoft\OneDrive" -Force -Recurse
Remove-Item -Path "$env:LOCALAPPDATA\Microsoft\OneDrive" -Force -Recurse
```

бат ду зе бекап!

```
Move-Item -Path "$env:ONEDRIVE" -Destination "$env:ONEDRIVE Backup"
```

```
try {Start-Process "$env:SYSTEMROOT\System32\OneDriveSetup.exe"} 
catch {Start-Process "$env:SYSTEMROOT\SysWOW64\OneDriveSetup.exe"}
```

# Multiple OpenVPN

поправить, тут все поменялось, кроме конфига

add more devices to windows 

```
"C:\Program Files\OpenVPN\bin\openvpnserv.exe" -remove
"C:\Program Files\OpenVPN\bin\openvpnserv.exe" -install

tapctl
cd "C:\Program Files\TAP-Windows\bin"
c:\Program Files\TAP-Windows\bin\>addtap.bat
"devcon.exe" install "C:\Program Files\TAP-Window
"C:\Program Files\OpenVPN\bin\openvpn" --show-adapters
```

rename "Local Area Connection 3" in tap to taplink0, taplink1 and add to config

```
dev tap
dev-node linktap0
```

# NTFS

Change permissions on fake NTFS external drive to mine

```
icacls "d:\ololo\full path to your file" /reset
icacls "d:\full path to the folder" /reset
icacls "d:\all\is\mine\full path to the folder" /reset /t /c /l
```

```
takeown /f <foldername> /r /d y
icacls <foldername> /grant administrators:F /T
```

# hyper-v mac change

```
(Get-VMNetworkAdapter -ManagementOS | Set-VMNetworkAdapter -StaticMacAddress "....")
```
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
# windows sql server

port opener


```
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned  
#Enabling SQL Server Ports
New-NetFirewallRule -DisplayName “SQL Server” -Direction Inbound –Protocol TCP –LocalPort 1433 -Action allow
New-NetFirewallRule -DisplayName “SQL Admin Connection” -Direction Inbound –Protocol TCP –LocalPort 1434 -Action allow
New-NetFirewallRule -DisplayName “SQL Database Management” -Direction Inbound –Protocol UDP –LocalPort 1434 -Action allow
New-NetFirewallRule -DisplayName “SQL Service Broker” -Direction Inbound –Protocol TCP –LocalPort 4022 -Action allow
New-NetFirewallRule -DisplayName “SQL Debugger/RPC” -Direction Inbound –Protocol TCP –LocalPort 135 -Action allow
#Enabling SQL Analysis Ports
New-NetFirewallRule -DisplayName “SQL Analysis Services” -Direction Inbound –Protocol TCP –LocalPort 2383 -Action allow
New-NetFirewallRule -DisplayName “SQL Browser” -Direction Inbound –Protocol TCP –LocalPort 2382 -Action allow
#Enabling Misc. Applications
New-NetFirewallRule -DisplayName “HTTP” -Direction Inbound –Protocol TCP –LocalPort 80 -Action allow
New-NetFirewallRule -DisplayName “SSL” -Direction Inbound –Protocol TCP –LocalPort 443 -Action allow
New-NetFirewallRule -DisplayName “SQL Server Browse Button Service” -Direction Inbound –Protocol UDP –LocalPort 1433 -Action allow
#Enable Windows Firewall
Set-NetFirewallProfile -DefaultInboundAction Block -DefaultOutboundAction Allow -NotifyOnListen True -AllowUnicastResponseToMulticast True
``
