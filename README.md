# Windows Cleanup Tool

A PowerShell-based GUI utility for removing Microsoft Edge, blocking unwanted Microsoft services, and purging preinstalled Windows bloatware from your system. Everything is done at a deep level — AppX packages, provisioned packages, registry keys, scheduled tasks, directories, firewall rules, and hosts file entries.

---

## Requirements

- Windows 10 or Windows 11
- PowerShell 5.1 or later (included with Windows by default)
- Administrator privileges (required — right-click and run as Administrator)

---

## How to Run

1. Download `RemoveEdge.ps1`
2. Right-click the file
3. Select "Run with PowerShell"
4. When prompted by UAC, click Yes to grant administrator access

If PowerShell blocks the script due to execution policy, run this command in an elevated PowerShell window first:

```
powershell -ExecutionPolicy Bypass -File RemoveEdge.ps1
```

---

## Tabs

### Tab 1 - Edge Removal

Completely removes Microsoft Edge from the system and blocks it from being reinstalled.

What it does:

- Kills all running Edge processes
- Runs Edge's own built-in uninstaller
- Force-deletes all Edge directories using takeown and icacls to bypass locked files
- Removes all Edge registry keys and uninstall entries
- Applies Group Policy registry blocks to prevent reinstallation
- Removes all Edge-related scheduled tasks
- Disables Edge update services (edgeupdate, edgeupdatem, MicrosoftEdgeElevationService)
- Patches the hosts file to block Edge update servers


### Tab 2 - Clean Up

Three independent sections, each with its own button and log output.

**Remove Edge from Windows Search**

- Disables Bing-powered web results in Windows Search
- Applies registry policies to disable cloud search and location tracking
- Removes Edge from taskbar search suggestions
- Removes Edge shortcuts from the Desktop, Start Menu, and common locations

**Block Copilot AI**

- Kills running Copilot processes
- Disables the Copilot taskbar button via registry
- Removes Copilot, BingSearch, and related AppX packages for all users
- Deprovisions packages so they cannot reinstall for new user accounts
- Blocks Copilot network endpoints in the hosts file
- Creates outbound firewall rules blocking resolved Copilot IP addresses

**Block Bing Search (Firewall IP Level)**

- Fetches Microsoft's officially published Bing IP list from bingbot.json
- Adds a set of hardcoded known Bing and Microsoft IP ranges as a fallback
- Resolves all Bing-related domains via live DNS lookup
- Creates inbound and outbound Windows Firewall rules blocking all resolved IPs
- Patches the hosts file to redirect Bing domains to 0.0.0.0
- Flushes the DNS cache


### Tab 3 - Bloat Nuker

An advanced bloatware removal tool with a selectable list of preinstalled Windows apps. Each app is fully scrubbed across seven removal layers.

**Features**

- Checklist of 40+ apps organized by category
- Select All and Deselect All buttons
- Live counter showing how many apps are selected
- Confirmation dialog before anything is deleted
- Real-time progress bar and log output
- Successfully removed apps are automatically removed from the list

**Removal layers applied per app**

1. Remove AppX package for the current user
2. Remove AppX package for all users
3. Deprovision the package (blocks reinstallation for new accounts and Windows updates)
4. Kill any running processes belonging to the app
5. Scrub leftover directories from LocalAppData\Packages using takeown and icacls
6. Remove all matching registry uninstall keys
7. Remove related scheduled tasks

**Advanced system hardening (runs after purge)**

- Locks down ContentDeliveryManager with 15 registry keys to block Windows from silently auto-reinstalling apps
- Disables Start Menu sponsored content and recommendations
- Removes OneDrive from the startup run key
- Disables Xbox-related services (XblAuthManager, XblGameSave, XboxGipSvc, XboxNetApiSvc)
- Disables scheduled tasks that silently reinstall Edge, OneDrive, and other apps

**App categories included**

- Gaming and Xbox (Xbox App, Game Bar, Game Pass, Speech to Text)
- Communication (Skype, Teams, Phone Link, People, Mail and Calendar)
- Media and Entertainment (Groove Music, Movies and TV, Clipchamp, Mixed Reality Portal, 3D Viewer, Paint 3D, Spotify)
- News, Weather, and Maps (Microsoft News, Weather, Bing Finance, Bing Sports, Maps)
- Office and Productivity (Office Hub, OneNote UWP, OneDrive, To-Do, Power Automate)
- System Bloat (Cortana, Get Help, Tips, Feedback Hub, Solitaire, Sticky Notes, Family Safety, Quick Assist, Wallet, Advertising SDK)
- Third Party Preinstalled (TikTok, Facebook, Instagram, Amazon, Disney Plus, Candy Crush, Duolingo, Dolby Access)

---

## Notes

- A system reboot is recommended after running any of the tools to finalize all changes
- All buttons can be clicked multiple times — the tool resets after each run
- Apps that are not found on your system are skipped and noted in the log
- This tool does not require any third-party dependencies and runs entirely with built-in Windows PowerShell and .NET APIs
- Some Microsoft apps are protected by Windows and may partially resist removal on certain configurations. The tool will log anything it could not remove.

---

## Disclaimer

This tool makes permanent changes to your system including registry edits, firewall rules, and package removal. Use it on systems you own and manage. Some removed components may affect other software that depends on them. Always create a system restore point before running tools that modify system state.
