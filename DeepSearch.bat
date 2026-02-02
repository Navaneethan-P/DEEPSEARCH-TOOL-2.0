@echo off
setlocal enabledelayedexpansion
color 0A
title DEEPSEARCH - MASTER VULNERABILITY & ASSET SCANNER - Navaneethan P

:: ==============================================================================
:: 1. AUTO-ADMIN ELEVATION
:: ==============================================================================
:check_admin
fltmc >nul 2>&1
if %errorlevel% neq 0 (
    echo [!] Requesting Administrator Privileges...
    goto :UACPrompt
) else (
    goto :START_TOOL
)

:UACPrompt
echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\getadmin.vbs"
"%temp%\getadmin.vbs"
del "%temp%\getadmin.vbs"
exit /B

:: ==============================================================================
:: 2. SETUP & INITIALIZATION
:: ==============================================================================
:START_TOOL
cd /d "%~dp0"
cls
echo ========================================================
echo  MASTER VULNERABILITY ^& ASSET SCANNER v9.1
echo  (Commercial + Deep Dive Edition)
echo ========================================================

set "scan_time=%date:~10,4%-%date:~4,2%-%date:~7,2%_%time:~0,2%%time:~3,2%"
set "scan_time=%scan_time: =0%"
set "output_dir=%~dp0Report_%scan_time%"
mkdir "%output_dir%"

:: Define Logs
set "risk_log=%output_dir%\_risk_summary.txt"
set "fix_log=%output_dir%\_recommended_fixes.txt"
set /a risk_score=0

:: Create blank logs
echo. > "%risk_log%"
echo. > "%fix_log%"

:: ==============================================================================
:: PHASE 3: ASSET PASSPORT (Commercial Data)
:: ==============================================================================
echo [1/5] Auditing Asset Identity (Serial, GPU, BIOS)...

:: Serial & BIOS
for /f "tokens=2 delims==" %%A in ('wmic bios get serialnumber /value') do set "serial_num=%%A"
for /f "tokens=2 delims==" %%A in ('wmic bios get smbiosbiosversion /value') do set "bios_ver=%%A"
for /f "tokens=2 delims==" %%A in ('wmic computersystem get model /value') do set "sys_model=%%A"
for /f "tokens=2 delims==" %%A in ('wmic computersystem get manufacturer /value') do set "sys_manuf=%%A"

:: GPU Info
wmic path win32_VideoController get Name,AdapterRAM,DriverVersion /value > "%output_dir%\hardware_gpu.txt"
for /f "tokens=2 delims==" %%A in ('wmic path win32_VideoController get Name /value ^| find "="') do set "gpu_name=%%A"

:: Battery Report
powercfg /batteryreport /output "%output_dir%\battery_report.html" >nul 2>&1
if exist "%output_dir%\battery_report.html" ( set "battery_status=Report Generated" ) else ( set "battery_status=No Battery/Desktop" )

:: ==============================================================================
:: PHASE 4: DEEP SYSTEM SCAN (Technical Data)
:: ==============================================================================
echo [2/5] Collecting Deep System Data...

:: Full System Specs
systeminfo > "%output_dir%\system_info_full.txt"

:: Installed Software (Heavy Task)
echo      - Inventorying Installed Software...
powershell -Command "Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* | Select-Object DisplayName, DisplayVersion, Publisher | Format-Table -AutoSize" > "%output_dir%\software_inventory.txt"

:: Driver List
echo      - Exporting Driver Details...
driverquery /v > "%output_dir%\driver_list.txt"

:: Windows Updates
echo      - Checking Patch History...
wmic qfe list > "%output_dir%\patch_history.txt"
for /f %%i in ('type "%output_dir%\patch_history.txt" ^| find /c /v ""') do set updates=%%i
if %updates% LSS 5 (
    echo [HIGH] System appears unpatched ^(Low update count^) >> "%risk_log%"
    set /a risk_score+=10
)

:: Disk SMART & Volumes
wmic diskdrive get Model,Status > "%output_dir%\disk_smart.txt"
wmic logicaldisk get Caption,FileSystem,FreeSpace,Size > "%output_dir%\disk_volumes.txt"

:: ==============================================================================
:: PHASE 5: NETWORK & SECURITY
:: ==============================================================================
echo [3/5] Analyzing Network ^& Security...

:: Open Ports
netstat -ano > "%output_dir%\network_ports_raw.txt"
netstat -ano | findstr "LISTENING" > "%output_dir%\network_ports_listening.txt"

:: ARP & DNS
arp -a > "%output_dir%\network_arp_table.txt"
ipconfig /displaydns > "%output_dir%\network_dns_cache.txt"

:: Firewall
netsh advfirewall show allprofiles > "%output_dir%\security_firewall_config.txt"
findstr "OFF" "%output_dir%\security_firewall_config.txt" >nul
if not errorlevel 1 (
    echo [CRITICAL] Firewall is OFF >> "%risk_log%"
    set /a risk_score+=20
)

:: Admin Users
net localgroup administrators > "%output_dir%\users_admins.txt"

:: RDP Check
findstr "3389" "%output_dir%\network_ports_listening.txt" >nul
if not errorlevel 1 (
    echo [HIGH] RDP Port Open >> "%risk_log%"
    set /a risk_score+=10
)

:: ==============================================================================
:: PHASE 6: PERFORMANCE VITALS
:: ==============================================================================
echo [4/5] Measuring Performance...

:: CPU Load
for /f %%A in ('powershell -Command "(Get-CimInstance Win32_Processor).LoadPercentage"') do set cpu_load=%%A
if %cpu_load% GTR 80 (
    echo [WARN] High CPU Load: %cpu_load%%% >> "%risk_log%"
    set /a risk_score+=5
)

:: RAM Usage
for /f "tokens=1,2" %%A in ('powershell -Command "$m=Get-CimInstance Win32_OperatingSystem; $t=$m.TotalVisibleMemorySize; $f=$m.FreePhysicalMemory; $u=$t-$f; $p=[math]::Round(($u/$t)*100); Write-Output $p $t"') do (
    set ram_pct=%%A
    set /a ram_total_mb=%%B / 1024
)

:: ==============================================================================
:: PHASE 7: REPORT GENERATION
:: ==============================================================================
echo [5/5] Building Master Report...

set "html_file=%output_dir%\Master_Report.html"

(
echo ^<!DOCTYPE html^>
echo ^<html^>^<head^>^<title^>Master Scan Report^</title^>
echo ^<style^>
echo    body { font-family: 'Segoe UI', Arial, sans-serif; background: #f4f6f9; margin: 0; padding: 20px; color: #333; }
echo    .container { max-width: 1100px; margin: auto; background: #fff; padding: 40px; box-shadow: 0 4px 10px rgba(0,0,0,0.1); border-top: 5px solid #27ae60; }
echo    h1 { color: #2c3e50; border-bottom: 2px solid #eee; padding-bottom: 10px; }
echo    h2 { background: #ecf0f1; padding: 10px; border-left: 5px solid #2980b9; margin-top: 30px; color: #2c3e50; }
echo    table { width: 100%%; border-collapse: collapse; margin-top: 10px; font-size: 14px; }
echo    th { text-align: left; background: #bdc3c7; padding: 10px; }
echo    td { padding: 10px; border-bottom: 1px solid #eee; }
echo    .risk-box { background: #ffebee; border: 1px solid #ef9a9a; padding: 15px; border-radius: 5px; color: #c0392b; }
echo    .score { font-size: 36px; font-weight: bold; float: right; color: #e74c3c; }
echo    .links a { display: inline-block; margin-right: 15px; color: #2980b9; text-decoration: none; font-weight: bold; }
echo    .links a:hover { text-decoration: underline; }
echo ^</style^>
echo ^</head^>^<body^>
echo ^<div class="container"^>

echo    ^<div class="score"^>Risk Score: %risk_score%^</div^>
echo    ^<h1^>Master Vulnerability ^& Asset Report^</h1^>
echo    ^<p^>Scan Date: %date% %time% ^| User: %username%^</p^>

echo    ^<h2^>1. Asset Passport (Buyer/Seller Data)^</h2^>
echo    ^<table^>
echo        ^<tr^>^<td^>Manufacturer^</td^>^<td^>%sys_manuf%^</td^>^</tr^>
echo        ^<tr^>^<td^>Model^</td^>^<td^>%sys_model%^</td^>^</tr^>
echo        ^<tr^>^<td^>Serial Number^</td^>^<td^>%serial_num%^</td^>^</tr^>
echo        ^<tr^>^<td^>GPU / Graphics^</td^>^<td^>%gpu_name%^</td^>^</tr^>
echo        ^<tr^>^<td^>RAM^</td^>^<td^>%ram_total_mb% MB^</td^>^</tr^>
echo        ^<tr^>^<td^>Battery Health^</td^>^<td^>^<a href="battery_report.html" target="_blank"^>%battery_status%^</a^>^</td^>^</tr^>
echo    ^</table^>

echo    ^<h2^>2. Risk Analysis^</h2^>
echo    ^<div class="risk-box"^>^<pre^>
type "%risk_log%"
echo    ^</pre^>^</div^>

echo    ^<h2^>3. System Vitals^</h2^>
echo    ^<table^>
echo        ^<tr^>^<td^>CPU Load^</td^>^<td^>%cpu_load%%%^</td^>^</tr^>
echo        ^<tr^>^<td^>RAM Usage^</td^>^<td^>%ram_pct%%%^</td^>^</tr^>
echo        ^<tr^>^<td^>Windows Updates^</td^>^<td^>%updates% installed^</td^>^</tr^>
echo    ^</table^>

echo    ^<h2^>4. Deep Dive Logs (Technician View)^</h2^>
echo    ^<p^>Click below to inspect raw system logs:^</p^>
echo    ^<div class="links"^>
echo        ^<a href="software_inventory.txt" target="_blank"^>[+] Installed Software^</a^>
echo        ^<a href="driver_list.txt" target="_blank"^>[+] Driver List^</a^>
echo        ^<a href="network_ports_listening.txt" target="_blank"^>[+] Open Ports^</a^>
echo        ^<a href="users_admins.txt" target="_blank"^>[+] Admin Users^</a^>
echo        ^<a href="security_firewall_config.txt" target="_blank"^>[+] Firewall Config^</a^>
echo        ^<a href="system_info_full.txt" target="_blank"^>[+] Full Sys Info^</a^>
echo    ^</div^>

echo    ^<br^>^<hr^>
echo    ^<small^>Generated by Scanner v9.1^</small^>
echo ^</div^>^</body^>^</html^>
) > "%html_file%"

echo.
echo ===========================================
echo  SCAN COMPLETE.
echo ===========================================
echo  Report Saved: %html_file%
echo ===========================================
echo Press any key to open the report...
pause >nul
start "" "%html_file%"