==============================================================================
DEEPSEARCH - MASTER VULNERABILITY & ASSET SCANNER v9.1
Enterprise Edition | Release: 2026
Developed & Architected by: Navaneethan.P
==============================================================================

[1] INTRODUCTION
------------------------------------------------------------------------------
The Master Vulnerability & Asset Scanner v9.1 is a lightweight, agent-less 
system auditing framework designed for immediate deployment. It bridges the 
gap between "Commercial Asset Valuation" (used by buyers/sellers) and 
"Technical Security Auditing" (used by SysAdmins/Repair Techs).

Unlike traditional auditing software that requires installation, agents, or 
cloud connectivity, this tool runs locally using native Windows protocols 
(WMI, PowerShell, NetSH) to ensure 100% data privacy and zero footprint.

[2] KEY CAPABILITIES
------------------------------------------------------------------------------
A. COMMERCIAL ASSET PASSPORT (For Buyers & Sellers)
   Designed to validate hardware value and detect fraud during PC resale.
   * Serial Number Verification: Extracts BIOS Serial & Chassis Tag.
   * Component Validation: Identifies exact GPU model, VRAM, and CPU Cores.
   * Battery Life Forensics: Generates a 30-day usage history and battery 
     health degradation report (Official Windows PowerCFG Standard).
   * Storage Integrity: Checks S.M.A.R.T. status to predict drive failure.

B. SECURITY RISK ASSESSMENT (For Administrators)
   Automated logic scans for 20+ common security holes.
   * Risk Scoring Engine: Calculates a threat score (0-100) based on active risks.
   * Port Scanning: Identifies open "listening" ports (e.g., RDP 3389).
   * Firewall Audit: Verifies active profiles (Domain, Private, Public).
   * Admin Hunter: Lists all users with hidden Administrator privileges.
   * Protocol Analysis: Dumps ARP tables and DNS cache to spot suspicious activity.

C. TECHNICAL DEEP DIVE (For Repair Technicians)
   Collects granular data for troubleshooting and maintenance.
   * Driver Enumeration: Exports a list of all installed drivers & versions.
   * Software Inventory: Lists every installed application (Win32 & Store Apps).
   * Patch Compliance: Audits Windows Update history for missing hotfixes.

[3] HOW TO USE
------------------------------------------------------------------------------
STEP 1: DOWNLOAD
   Save the file "Scan_v9.1_Final.bat" to the target computer.
   (Ideally, save it to a USB drive to scan multiple computers quickly).

STEP 2: EXECUTE
   Double-click "Scan_v9.1_Final.bat".
   * Note: The tool features "Auto-Elevation". It will automatically ask 
     for Administrator permissions. Click "Yes" to proceed.

STEP 3: WAIT
   The scan takes approximately 45-60 seconds. 
   Do not close the window until the HTML report opens.

STEP 4: REVIEW
   The "Master_Report.html" will open automatically in your default browser.
   This is your dashboard. You can print this page as a PDF for clients.

[4] UNDERSTANDING THE OUTPUT FILES
------------------------------------------------------------------------------
The tool creates a new folder named "Report_YYYY-MM-DD_Time" for every scan.
Inside, you will find the main report plus raw forensic data:

1. Master_Report.html ......... The Client-Facing Summary (Send this to customers).
2. battery_report.html ........ Detailed battery charge/discharge cycles.
3. software_inventory.txt ..... Full list of installed programs.
4. driver_list.txt ............ Technical driver details for troubleshooting.
5. network_ports_listening.txt. List of active network connections.
6. system_info_full.txt ....... Complete OS and Hardware environment dump.
7. _risk_summary.txt .......... The logic log explaining the Risk Score.

[5] SYSTEM REQUIREMENTS & COMPATIBILITY
------------------------------------------------------------------------------
* Operating System: Windows 10, Windows 11, Windows Server (2016/2019/2022).
* Architecture: x64 or x86.
* Dependencies: None. (Uses native PowerShell & Command Prompt).
* Internet: Not Required. (Fully offline capable for secure environments).

[6] TROUBLESHOOTING
------------------------------------------------------------------------------
* Issue: "Access Denied" or scan closes immediately.
  Fix: Ensure you clicked "Yes" on the Administrator User Account Control prompt.

* Issue: "PowerShell is not recognized".
  Fix: This tool requires PowerShell to be present (Standard on all Windows 10/11).

[7] DISCLAIMER
------------------------------------------------------------------------------
This software is provided "as is", without warranty of any kind. It is a 
passive scanning tool and does not modify system files or registry settings.
Use this tool responsibly and only on systems you own or have permission to audit.

==============================================================================
© Developed by Navaneethan.P | All Rights Reserved
==============================================================================