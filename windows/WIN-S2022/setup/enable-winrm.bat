@REM basic config for winrm
@REM cmd /c winrm quickconfig -q

@REM allow unencrypted traffic, and configure auth to use basic username/password auth
cmd /c winrm set winrm/config/service @{AllowUnencrypted="true"}
cmd /c winrm set winrm/config/service/auth @{Basic="true"}

@REM update firewall rules to open the right port and to allow remote administration
@REM cmd /c netsh firewall set service remoteDesktop enable

@REM restart winrm
cmd /c net stop winrm
cmd /c net start winrm
