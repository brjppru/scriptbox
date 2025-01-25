# ipv4 prefer #

Microsoft EasyFix 20166
Prefer IPv4 over IPv6 - Microsoft

https://social.technet.microsoft.com/Forums/windows/en-US/33b99ca4-9182-4f3d-94ea-7e689c837efe/prefer-ipv4-over-ipv6?forum=winserver8gen

Open RegEdit, navigate to HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\tcpip6\Parameters
Create DisabledComponents DWORD registry value, set its value to 20 (Hexadecimal).
Reboot.

https://www.kapilarya.com/how-to-force-windows-10-to-use-ipv4-over-ipv6
https://go.microsoft.com/?linkid=9728870
