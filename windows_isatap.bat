@echo off
for /f "delims=" %%i in ('c:\curl.exe -4 ip.sb') do (set "i=%%i"
echo %i%)
netsh interface ipv6 isatap set state disable
netsh interface ipv6 isatap set state enable
netsh interface ipv6 isatap set router 202.38.64.9
netsh interface ipv6 set address isatap.lan 2001:da8:d800:9:200:5efe:%i%/64
netsh interface ipv6 add route ::/0 isatap.lan 2001:da8:d800:9:200:5efe:202.38.64.9
