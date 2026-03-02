Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]"Administrator")) {
    [System.Windows.Forms.MessageBox]::Show("Please right-click and choose Run with PowerShell as Administrator.","Admin Required","OK","Warning")
    exit 1
}

# ================================================================
# MAIN FORM
# ================================================================
$form                 = New-Object System.Windows.Forms.Form
$form.Text            = "Edge Obliterator"
$form.Size            = New-Object System.Drawing.Size(660, 620)
$form.StartPosition   = "CenterScreen"
$form.BackColor       = [System.Drawing.Color]::FromArgb(10, 10, 18)
$form.FormBorderStyle = "FixedSingle"
$form.MaximizeBox     = $false
$form.Font            = New-Object System.Drawing.Font("Consolas", 9)

# ================================================================
# TAB CONTROL
# ================================================================
$tabControl                  = New-Object System.Windows.Forms.TabControl
$tabControl.Size             = New-Object System.Drawing.Size(644, 580)
$tabControl.Location         = New-Object System.Drawing.Point(0, 0)
$tabControl.Appearance       = "Normal"
$tabControl.DrawMode         = "OwnerDrawFixed"
$tabControl.ItemSize         = New-Object System.Drawing.Size(160, 36)
$tabControl.SizeMode         = "Fixed"
$tabControl.BackColor        = [System.Drawing.Color]::FromArgb(10, 10, 18)
$tabControl.Font             = New-Object System.Drawing.Font("Consolas", 10, [System.Drawing.FontStyle]::Bold)
$form.Controls.Add($tabControl)

# Custom tab drawing
$tabControl.Add_DrawItem({
    param($s, $e)
    $g        = $e.Graphics
    $tabRect  = $tabControl.GetTabRect($e.Index)
    $isActive = ($e.Index -eq $tabControl.SelectedIndex)
    $bgColor  = if ($isActive) { [System.Drawing.Color]::FromArgb(180, 20, 20) } else { [System.Drawing.Color]::FromArgb(25, 25, 35) }
    $fgColor  = if ($isActive) { [System.Drawing.Color]::White } else { [System.Drawing.Color]::FromArgb(130, 130, 160) }
    $g.FillRectangle([System.Drawing.SolidBrush]::new($bgColor), $tabRect)
    $sf = New-Object System.Drawing.StringFormat
    $sf.Alignment     = [System.Drawing.StringAlignment]::Center
    $sf.LineAlignment = [System.Drawing.StringAlignment]::Center
    $g.DrawString($tabControl.TabPages[$e.Index].Text, $tabControl.Font, [System.Drawing.SolidBrush]::new($fgColor), [System.Drawing.RectangleF]$tabRect, $sf)
})

# ================================================================
# TAB 1 - EDGE REMOVAL
# ================================================================
$tab1           = New-Object System.Windows.Forms.TabPage
$tab1.Text      = "Edge Removal"
$tab1.BackColor = [System.Drawing.Color]::FromArgb(10, 10, 18)
$tabControl.TabPages.Add($tab1)

$lblTitle           = New-Object System.Windows.Forms.Label
$lblTitle.Text      = "EDGE OBLITERATOR"
$lblTitle.Font      = New-Object System.Drawing.Font("Consolas", 20, [System.Drawing.FontStyle]::Bold)
$lblTitle.ForeColor = [System.Drawing.Color]::FromArgb(255, 60, 60)
$lblTitle.AutoSize  = $true
$lblTitle.Location  = New-Object System.Drawing.Point(20, 18)
$tab1.Controls.Add($lblTitle)

$lblSub           = New-Object System.Windows.Forms.Label
$lblSub.Text      = "Removes Microsoft Edge and blocks reinstallation permanently"
$lblSub.Font      = New-Object System.Drawing.Font("Consolas", 8)
$lblSub.ForeColor = [System.Drawing.Color]::FromArgb(120, 120, 150)
$lblSub.AutoSize  = $true
$lblSub.Location  = New-Object System.Drawing.Point(22, 60)
$tab1.Controls.Add($lblSub)

$sep1           = New-Object System.Windows.Forms.Panel
$sep1.Size      = New-Object System.Drawing.Size(600, 1)
$sep1.Location  = New-Object System.Drawing.Point(20, 83)
$sep1.BackColor = [System.Drawing.Color]::FromArgb(255, 60, 60)
$tab1.Controls.Add($sep1)

$logBox1             = New-Object System.Windows.Forms.RichTextBox
$logBox1.Size        = New-Object System.Drawing.Size(600, 300)
$logBox1.Location    = New-Object System.Drawing.Point(20, 95)
$logBox1.BackColor   = [System.Drawing.Color]::FromArgb(5, 5, 12)
$logBox1.ForeColor   = [System.Drawing.Color]::FromArgb(0, 230, 120)
$logBox1.Font        = New-Object System.Drawing.Font("Consolas", 9)
$logBox1.ReadOnly    = $true
$logBox1.BorderStyle = "None"
$logBox1.ScrollBars  = "Vertical"
$tab1.Controls.Add($logBox1)

$prog1          = New-Object System.Windows.Forms.ProgressBar
$prog1.Size     = New-Object System.Drawing.Size(600, 6)
$prog1.Location = New-Object System.Drawing.Point(20, 408)
$prog1.Style    = "Continuous"
$prog1.Minimum  = 0
$prog1.Maximum  = 100
$prog1.Value    = 0
$tab1.Controls.Add($prog1)

$lbl1Status           = New-Object System.Windows.Forms.Label
$lbl1Status.Text      = "Ready."
$lbl1Status.ForeColor = [System.Drawing.Color]::FromArgb(100, 100, 130)
$lbl1Status.Font      = New-Object System.Drawing.Font("Consolas", 8)
$lbl1Status.AutoSize  = $true
$lbl1Status.Location  = New-Object System.Drawing.Point(20, 422)
$tab1.Controls.Add($lbl1Status)

$btnEdge                           = New-Object System.Windows.Forms.Button
$btnEdge.Text                      = "EXECUTE"
$btnEdge.Size                      = New-Object System.Drawing.Size(600, 52)
$btnEdge.Location                  = New-Object System.Drawing.Point(20, 448)
$btnEdge.BackColor                 = [System.Drawing.Color]::FromArgb(180, 20, 20)
$btnEdge.ForeColor                 = [System.Drawing.Color]::White
$btnEdge.Font                      = New-Object System.Drawing.Font("Consolas", 15, [System.Drawing.FontStyle]::Bold)
$btnEdge.FlatStyle                 = "Flat"
$btnEdge.FlatAppearance.BorderSize = 0
$btnEdge.Cursor                    = [System.Windows.Forms.Cursors]::Hand
$tab1.Controls.Add($btnEdge)

$btnEdge.Add_MouseEnter({ $btnEdge.BackColor = [System.Drawing.Color]::FromArgb(220, 30, 30) })
$btnEdge.Add_MouseLeave({ $btnEdge.BackColor = [System.Drawing.Color]::FromArgb(180, 20, 20) })

# ================================================================
# TAB 2 - CLEAN UP
# ================================================================
$tab2           = New-Object System.Windows.Forms.TabPage
$tab2.Text      = "Clean Up"
$tab2.BackColor = [System.Drawing.Color]::FromArgb(10, 10, 18)
$tabControl.TabPages.Add($tab2)

$lbl2Title           = New-Object System.Windows.Forms.Label
$lbl2Title.Text      = "CLEAN UP"
$lbl2Title.Font      = New-Object System.Drawing.Font("Consolas", 20, [System.Drawing.FontStyle]::Bold)
$lbl2Title.ForeColor = [System.Drawing.Color]::FromArgb(60, 180, 255)
$lbl2Title.AutoSize  = $true
$lbl2Title.Location  = New-Object System.Drawing.Point(20, 18)
$tab2.Controls.Add($lbl2Title)

$lbl2Sub           = New-Object System.Windows.Forms.Label
$lbl2Sub.Text      = "Remove Edge from Search + Block all Microsoft Copilot AI"
$lbl2Sub.Font      = New-Object System.Drawing.Font("Consolas", 8)
$lbl2Sub.ForeColor = [System.Drawing.Color]::FromArgb(120, 120, 150)
$lbl2Sub.AutoSize  = $true
$lbl2Sub.Location  = New-Object System.Drawing.Point(22, 60)
$tab2.Controls.Add($lbl2Sub)

$sep2           = New-Object System.Windows.Forms.Panel
$sep2.Size      = New-Object System.Drawing.Size(600, 1)
$sep2.Location  = New-Object System.Drawing.Point(20, 83)
$sep2.BackColor = [System.Drawing.Color]::FromArgb(60, 180, 255)
$tab2.Controls.Add($sep2)

# Section A - Edge from Search
$lblSearchTitle           = New-Object System.Windows.Forms.Label
$lblSearchTitle.Text      = "REMOVE EDGE FROM WINDOWS SEARCH"
$lblSearchTitle.Font      = New-Object System.Drawing.Font("Consolas", 9, [System.Drawing.FontStyle]::Bold)
$lblSearchTitle.ForeColor = [System.Drawing.Color]::FromArgb(255, 180, 60)
$lblSearchTitle.AutoSize  = $true
$lblSearchTitle.Location  = New-Object System.Drawing.Point(20, 98)
$tab2.Controls.Add($lblSearchTitle)

$lblSearchDesc           = New-Object System.Windows.Forms.Label
$lblSearchDesc.Text      = "Removes Edge shortcuts, web results, and Edge promotion from Windows Search"
$lblSearchDesc.Font      = New-Object System.Drawing.Font("Consolas", 8)
$lblSearchDesc.ForeColor = [System.Drawing.Color]::FromArgb(100, 100, 130)
$lblSearchDesc.AutoSize  = $true
$lblSearchDesc.Location  = New-Object System.Drawing.Point(20, 118)
$tab2.Controls.Add($lblSearchDesc)

$logSearch             = New-Object System.Windows.Forms.RichTextBox
$logSearch.Size        = New-Object System.Drawing.Size(600, 100)
$logSearch.Location    = New-Object System.Drawing.Point(20, 140)
$logSearch.BackColor   = [System.Drawing.Color]::FromArgb(5, 5, 12)
$logSearch.ForeColor   = [System.Drawing.Color]::FromArgb(0, 230, 120)
$logSearch.Font        = New-Object System.Drawing.Font("Consolas", 9)
$logSearch.ReadOnly    = $true
$logSearch.BorderStyle = "None"
$logSearch.ScrollBars  = "Vertical"
$tab2.Controls.Add($logSearch)

$btnSearch                           = New-Object System.Windows.Forms.Button
$btnSearch.Text                      = "REMOVE EDGE FROM SEARCH"
$btnSearch.Size                      = New-Object System.Drawing.Size(600, 40)
$btnSearch.Location                  = New-Object System.Drawing.Point(20, 248)
$btnSearch.BackColor                 = [System.Drawing.Color]::FromArgb(160, 100, 0)
$btnSearch.ForeColor                 = [System.Drawing.Color]::White
$btnSearch.Font                      = New-Object System.Drawing.Font("Consolas", 11, [System.Drawing.FontStyle]::Bold)
$btnSearch.FlatStyle                 = "Flat"
$btnSearch.FlatAppearance.BorderSize = 0
$btnSearch.Cursor                    = [System.Windows.Forms.Cursors]::Hand
$tab2.Controls.Add($btnSearch)

$btnSearch.Add_MouseEnter({ $btnSearch.BackColor = [System.Drawing.Color]::FromArgb(200, 130, 0) })
$btnSearch.Add_MouseLeave({ $btnSearch.BackColor = [System.Drawing.Color]::FromArgb(160, 100, 0) })

# Divider
$sep3           = New-Object System.Windows.Forms.Panel
$sep3.Size      = New-Object System.Drawing.Size(600, 1)
$sep3.Location  = New-Object System.Drawing.Point(20, 303)
$sep3.BackColor = [System.Drawing.Color]::FromArgb(40, 40, 60)
$tab2.Controls.Add($sep3)

# Section B - Copilot Block
$lblCopTitle           = New-Object System.Windows.Forms.Label
$lblCopTitle.Text      = "BLOCK ALL MICROSOFT COPILOT AI"
$lblCopTitle.Font      = New-Object System.Drawing.Font("Consolas", 9, [System.Drawing.FontStyle]::Bold)
$lblCopTitle.ForeColor = [System.Drawing.Color]::FromArgb(180, 60, 255)
$lblCopTitle.AutoSize  = $true
$lblCopTitle.Location  = New-Object System.Drawing.Point(20, 316)
$tab2.Controls.Add($lblCopTitle)

$lblCopDesc           = New-Object System.Windows.Forms.Label
$lblCopDesc.Text      = "Removes Copilot, blocks all AI endpoints, kills taskbar Copilot button"
$lblCopDesc.Font      = New-Object System.Drawing.Font("Consolas", 8)
$lblCopDesc.ForeColor = [System.Drawing.Color]::FromArgb(100, 100, 130)
$lblCopDesc.AutoSize  = $true
$lblCopDesc.Location  = New-Object System.Drawing.Point(20, 336)
$tab2.Controls.Add($lblCopDesc)

$logCopilot             = New-Object System.Windows.Forms.RichTextBox
$logCopilot.Size        = New-Object System.Drawing.Size(600, 100)
$logCopilot.Location    = New-Object System.Drawing.Point(20, 358)
$logCopilot.BackColor   = [System.Drawing.Color]::FromArgb(5, 5, 12)
$logCopilot.ForeColor   = [System.Drawing.Color]::FromArgb(0, 230, 120)
$logCopilot.Font        = New-Object System.Drawing.Font("Consolas", 9)
$logCopilot.ReadOnly    = $true
$logCopilot.BorderStyle = "None"
$logCopilot.ScrollBars  = "Vertical"
$tab2.Controls.Add($logCopilot)

$btnCopilot                           = New-Object System.Windows.Forms.Button
$btnCopilot.Text                      = "BLOCK COPILOT AI"
$btnCopilot.Size                      = New-Object System.Drawing.Size(600, 40)
$btnCopilot.Location                  = New-Object System.Drawing.Point(20, 466)
$btnCopilot.BackColor                 = [System.Drawing.Color]::FromArgb(100, 20, 160)
$btnCopilot.ForeColor                 = [System.Drawing.Color]::White
$btnCopilot.Font                      = New-Object System.Drawing.Font("Consolas", 11, [System.Drawing.FontStyle]::Bold)
$btnCopilot.FlatStyle                 = "Flat"
$btnCopilot.FlatAppearance.BorderSize = 0
$btnCopilot.Cursor                    = [System.Windows.Forms.Cursors]::Hand
$tab2.Controls.Add($btnCopilot)

$btnCopilot.Add_MouseEnter({ $btnCopilot.BackColor = [System.Drawing.Color]::FromArgb(130, 30, 200) })
$btnCopilot.Add_MouseLeave({ $btnCopilot.BackColor = [System.Drawing.Color]::FromArgb(100, 20, 160) })

# ================================================================
# SHARED LOG HELPER
# ================================================================
function Write-ToBox {
    param($box, [string]$msg, [string]$col = "Green")
    $ts = Get-Date -Format "HH:mm:ss"
    $colorMap = @{
        Green  = [System.Drawing.Color]::FromArgb(0, 230, 120)
        Red    = [System.Drawing.Color]::FromArgb(255, 80, 80)
        Yellow = [System.Drawing.Color]::FromArgb(255, 210, 60)
        Cyan   = [System.Drawing.Color]::FromArgb(60, 200, 255)
        Gray   = [System.Drawing.Color]::FromArgb(100, 100, 130)
    }
    $dc = if ($colorMap[$col]) { $colorMap[$col] } else { $colorMap["Green"] }
    $box.SelectionStart  = $box.TextLength
    $box.SelectionLength = 0
    $box.SelectionColor  = [System.Drawing.Color]::FromArgb(60, 60, 80)
    $box.AppendText("[$ts] ")
    $box.SelectionColor  = $dc
    $box.AppendText("$msg`n")
    $box.ScrollToCaret()
    [System.Windows.Forms.Application]::DoEvents()
}

function Set-Prog {
    param([int]$val, [string]$status)
    $prog1.Value      = [Math]::Min($val, 100)
    $lbl1Status.Text  = $status
    [System.Windows.Forms.Application]::DoEvents()
}

# ================================================================
# TAB 1 - EDGE REMOVAL LOGIC
# ================================================================
$btnEdge.Add_Click({
    $btnEdge.Text    = "RUNNING..."
    $logBox1.Clear()

    Write-ToBox $logBox1 "Starting Edge Obliterator..." "Cyan"
    Write-ToBox $logBox1 "----------------------------------------" "Gray"

    Set-Prog 5 "Killing Edge processes..."
    Write-ToBox $logBox1 "[1/8] Terminating Edge processes..." "Yellow"
    $edgeProcs = @("msedge","MicrosoftEdge","MicrosoftEdgeCP","MicrosoftEdgeSH","msedgewebview2")
    foreach ($p in $edgeProcs) {
        Get-Process -Name $p -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
    }
    Start-Sleep -Milliseconds 800
    Write-ToBox $logBox1 "    Processes terminated." "Green"

    Set-Prog 15 "Running Edge uninstaller..."
    Write-ToBox $logBox1 "[2/8] Running Edge built-in uninstaller..." "Yellow"
    $edgeBases = @(
        "$env:ProgramFiles (x86)\Microsoft\Edge\Application",
        "$env:ProgramFiles\Microsoft\Edge\Application"
    )
    $ran = $false
    foreach ($base in $edgeBases) {
        if (Test-Path $base) {
            $vers = Get-ChildItem $base -ErrorAction SilentlyContinue | Where-Object { $_.Name -match "^[0-9]" }
            foreach ($v in $vers) {
                $setup = Join-Path $v.FullName "Installer\setup.exe"
                if (Test-Path $setup) {
                    Write-ToBox $logBox1 "    Found: $setup" "Gray"
                    Start-Process -FilePath $setup -ArgumentList "--uninstall --system-level --verbose-logging --force-uninstall" -Wait -ErrorAction SilentlyContinue
                    $ran = $true
                    Write-ToBox $logBox1 "    Uninstaller executed." "Green"
                }
            }
        }
    }
    if (-not $ran) { Write-ToBox $logBox1 "    No built-in uninstaller found." "Gray" }
    Start-Sleep -Seconds 2

    Set-Prog 30 "Deleting Edge directories..."
    Write-ToBox $logBox1 "[3/8] Removing Edge directories..." "Yellow"
    $dirs = @(
        "$env:ProgramFiles (x86)\Microsoft\Edge",
        "$env:ProgramFiles (x86)\Microsoft\EdgeUpdate",
        "$env:ProgramFiles (x86)\Microsoft\EdgeCore",
        "$env:ProgramFiles (x86)\Microsoft\EdgeWebView",
        "$env:ProgramFiles\Microsoft\Edge",
        "$env:ProgramFiles\Microsoft\EdgeUpdate",
        "$env:LocalAppData\Microsoft\Edge",
        "$env:AppData\Microsoft\Edge",
        "$env:SystemRoot\SystemApps\Microsoft.MicrosoftEdge_8wekyb3d8bbwe"
    )
    foreach ($d in $dirs) {
        if (Test-Path $d) {
            try {
                & takeown /F "$d" /R /D Y 2>&1 | Out-Null
                & icacls "$d" /grant administrators:F /T 2>&1 | Out-Null
                Remove-Item -Path $d -Recurse -Force -ErrorAction SilentlyContinue
                Write-ToBox $logBox1 "    Removed: $d" "Green"
            } catch {
                Write-ToBox $logBox1 "    Could not remove: $d" "Red"
            }
        }
    }

    Set-Prog 50 "Cleaning registry..."
    Write-ToBox $logBox1 "[4/8] Removing Edge registry keys..." "Yellow"
    $keys = @(
        "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\msedge.exe",
        "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Edge",
        "HKLM:\SOFTWARE\Microsoft\Edge",
        "HKCU:\SOFTWARE\Microsoft\Edge",
        "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\Microsoft Edge",
        "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\Microsoft Edge Update",
        "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Microsoft Edge",
        "HKLM:\SOFTWARE\Microsoft\EdgeUpdate",
        "HKLM:\SOFTWARE\WOW6432Node\Microsoft\EdgeUpdate",
        "HKCU:\SOFTWARE\Microsoft\EdgeUpdate"
    )
    foreach ($k in $keys) {
        if (Test-Path $k) {
            try {
                Remove-Item -Path $k -Recurse -Force -ErrorAction SilentlyContinue
                Write-ToBox $logBox1 "    Removed: $k" "Green"
            } catch {
                Write-ToBox $logBox1 "    Could not remove: $k" "Red"
            }
        }
    }

    Set-Prog 65 "Blocking reinstallation..."
    Write-ToBox $logBox1 "[5/8] Setting Group Policy blocks..." "Yellow"
    $pol = "HKLM:\SOFTWARE\Policies\Microsoft\Edge"
    if (-not (Test-Path $pol)) { New-Item -Path $pol -Force | Out-Null }
    Set-ItemProperty -Path $pol -Name "DoNotUpdateToEdgeWithChromium" -Value 1 -Type DWord -Force
    $upd = "HKLM:\SOFTWARE\Policies\Microsoft\EdgeUpdate"
    if (-not (Test-Path $upd)) { New-Item -Path $upd -Force | Out-Null }
    Set-ItemProperty -Path $upd -Name "UpdateDefault"                                  -Value 0 -Type DWord -Force
    Set-ItemProperty -Path $upd -Name "DisableAutoUpdateChecksCheckboxValue"           -Value 1 -Type DWord -Force
    Set-ItemProperty -Path $upd -Name "Install{56EB18F8-B008-4CBD-B6D2-8C97FE7E9062}" -Value 0 -Type DWord -Force
    Write-ToBox $logBox1 "    Policy blocks applied." "Green"

    Set-Prog 75 "Removing scheduled tasks..."
    Write-ToBox $logBox1 "[6/8] Removing Edge scheduled tasks..." "Yellow"
    $tasks = Get-ScheduledTask -ErrorAction SilentlyContinue | Where-Object { $_.TaskName -like "*Edge*" -or $_.TaskName -like "*MicrosoftEdge*" }
    foreach ($t in $tasks) {
        Unregister-ScheduledTask -TaskName $t.TaskName -Confirm:$false -ErrorAction SilentlyContinue
        Write-ToBox $logBox1 "    Removed task: $($t.TaskName)" "Green"
    }
    if (-not $tasks) { Write-ToBox $logBox1 "    No Edge tasks found." "Gray" }

    Set-Prog 85 "Disabling Edge services..."
    Write-ToBox $logBox1 "[7/8] Disabling Edge services..." "Yellow"
    $svcs = @("edgeupdate","edgeupdatem","MicrosoftEdgeElevationService")
    foreach ($s in $svcs) {
        if (Get-Service -Name $s -ErrorAction SilentlyContinue) {
            Stop-Service -Name $s -Force -ErrorAction SilentlyContinue
            Set-Service  -Name $s -StartupType Disabled -ErrorAction SilentlyContinue
            Write-ToBox $logBox1 "    Disabled: $s" "Green"
        }
    }

    Set-Prog 93 "Blocking Edge update endpoints..."
    Write-ToBox $logBox1 "[8/8] Patching hosts file..." "Yellow"
    $hostsPath    = "$env:SystemRoot\System32\drivers\etc\hosts"
    $hostsContent = Get-Content $hostsPath -Raw -ErrorAction SilentlyContinue
    $marker       = "EDGE BLOCK START"
    if ($hostsContent -notlike "*$marker*") {
        $block  = "`r`nEDGE BLOCK START`r`n"
        $block += "0.0.0.0 edgeupdates.microsoft.com`r`n"
        $block += "0.0.0.0 msedge.api.cdp.microsoft.com`r`n"
        $block += "0.0.0.0 edge.microsoft.com`r`n"
        $block += "0.0.0.0 config.edge.skype.com`r`n"
        $block += "EDGE BLOCK END`r`n"
        Add-Content -Path $hostsPath -Value $block
        Write-ToBox $logBox1 "    Hosts file patched." "Green"
    } else {
        Write-ToBox $logBox1 "    Hosts file already patched." "Gray"
    }
    ipconfig /flushdns | Out-Null

    Set-Prog 100 "Complete!"
    Write-ToBox $logBox1 "----------------------------------------" "Gray"
    Write-ToBox $logBox1 "DONE. Microsoft Edge has been obliterated." "Cyan"
    Write-ToBox $logBox1 "Reboot your PC to finalize removal." "Yellow"
    Write-ToBox $logBox1 "----------------------------------------" "Gray"

    $btnEdge.Text      = "EXECUTE"
    $btnEdge.BackColor = [System.Drawing.Color]::FromArgb(180, 20, 20)
    [System.Windows.Forms.MessageBox]::Show(
        "Microsoft Edge has been removed and blocked from reinstalling. Please reboot your PC to complete the process.",
        "Edge Obliterator - Done",
        "OK",
        "Information"
    )
})

# ================================================================
# TAB 2 - REMOVE EDGE FROM SEARCH
# ================================================================
$btnSearch.Add_Click({
    $btnSearch.Text    = "RUNNING..."
    $logSearch.Clear()

    Write-ToBox $logSearch "Removing Edge from Windows Search..." "Cyan"

    # Kill Search UI and related processes
    Write-ToBox $logSearch "[1/4] Restarting Search process..." "Yellow"
    Get-Process -Name "SearchUI","SearchApp","SearchIndexer" -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
    Start-Sleep -Milliseconds 600
    Write-ToBox $logSearch "    Done." "Green"

    # Registry: disable Edge promotion in Search
    Write-ToBox $logSearch "[2/4] Applying Search registry settings..." "Yellow"
    $searchPol = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search"
    if (-not (Test-Path $searchPol)) { New-Item -Path $searchPol -Force | Out-Null }
    Set-ItemProperty -Path $searchPol -Name "AllowCloudSearch"                 -Value 0 -Type DWord -Force
    Set-ItemProperty -Path $searchPol -Name "AllowSearchToUseLocation"         -Value 0 -Type DWord -Force
    Set-ItemProperty -Path $searchPol -Name "DisableWebSearch"                 -Value 1 -Type DWord -Force
    Set-ItemProperty -Path $searchPol -Name "ConnectedSearchUseWeb"            -Value 0 -Type DWord -Force
    Set-ItemProperty -Path $searchPol -Name "ConnectedSearchUseWebOverMetered" -Value 0 -Type DWord -Force

    $searchUser = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search"
    if (-not (Test-Path $searchUser)) { New-Item -Path $searchUser -Force | Out-Null }
    Set-ItemProperty -Path $searchUser -Name "BingSearchEnabled"          -Value 0 -Type DWord -Force
    Set-ItemProperty -Path $searchUser -Name "CortanaConsent"             -Value 0 -Type DWord -Force
    Set-ItemProperty -Path $searchUser -Name "AllowSearchToUseLocation"   -Value 0 -Type DWord -Force
    Write-ToBox $logSearch "    Registry settings applied." "Green"

    # Remove Edge from taskbar search suggestions
    Write-ToBox $logSearch "[3/4] Removing Edge from search suggestions..." "Yellow"
    $edgeSuggest = "HKLM:\SOFTWARE\Policies\Microsoft\Edge"
    if (-not (Test-Path $edgeSuggest)) { New-Item -Path $edgeSuggest -Force | Out-Null }
    Set-ItemProperty -Path $edgeSuggest -Name "ShowMicrosoftRewards"       -Value 0 -Type DWord -Force
    Set-ItemProperty -Path $edgeSuggest -Name "HideFirstRunExperience"     -Value 1 -Type DWord -Force
    Set-ItemProperty -Path $edgeSuggest -Name "EdgeShoppingAssistantEnabled" -Value 0 -Type DWord -Force
    Write-ToBox $logSearch "    Done." "Green"

    # Remove Edge pinned shortcuts
    Write-ToBox $logSearch "[4/4] Removing Edge shortcuts from common locations..." "Yellow"
    $shortcuts = @(
        "$env:USERPROFILE\Desktop\Microsoft Edge.lnk",
        "$env:PUBLIC\Desktop\Microsoft Edge.lnk",
        "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Microsoft Edge.lnk",
        "$env:PROGRAMDATA\Microsoft\Windows\Start Menu\Programs\Microsoft Edge.lnk"
    )
    foreach ($sc in $shortcuts) {
        if (Test-Path $sc) {
            Remove-Item $sc -Force -ErrorAction SilentlyContinue
            Write-ToBox $logSearch "    Removed: $sc" "Green"
        }
    }

    Write-ToBox $logSearch "DONE. Edge removed from Search." "Cyan"
    $btnSearch.Text      = "REMOVE EDGE FROM SEARCH"
    $btnSearch.BackColor = [System.Drawing.Color]::FromArgb(160, 100, 0)
    [System.Windows.Forms.MessageBox]::Show("Edge has been removed from Windows Search. A reboot is recommended.","Clean Up - Done","OK","Information")
})

# ================================================================
# TAB 2 - BLOCK COPILOT AI LOGIC
# ================================================================
$btnCopilot.Add_Click({
    $btnCopilot.Text    = "RUNNING..."
    $logCopilot.Clear()

    Write-ToBox $logCopilot "Blocking all Microsoft Copilot AI..." "Cyan"

    # Kill Copilot processes
    Write-ToBox $logCopilot "[1/5] Killing Copilot processes..." "Yellow"
    $copProcs = @("Copilot","copilot","Microsoft.Windows.AI.Copilot.Provider")
    foreach ($p in $copProcs) {
        Get-Process -Name $p -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
    }
    Write-ToBox $logCopilot "    Done." "Green"

    # Registry: disable Copilot system-wide
    Write-ToBox $logCopilot "[2/5] Disabling Copilot via registry..." "Yellow"
    $copPolPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsCopilot"
    if (-not (Test-Path $copPolPath)) { New-Item -Path $copPolPath -Force | Out-Null }
    Set-ItemProperty -Path $copPolPath -Name "TurnOffWindowsCopilot" -Value 1 -Type DWord -Force

    $copUser = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
    if (-not (Test-Path $copUser)) { New-Item -Path $copUser -Force | Out-Null }
    Set-ItemProperty -Path $copUser -Name "ShowCopilotButton" -Value 0 -Type DWord -Force

    $copTaskbar = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search"
    if (-not (Test-Path $copTaskbar)) { New-Item -Path $copTaskbar -Force | Out-Null }
    Set-ItemProperty -Path $copTaskbar -Name "CopilotEnabled" -Value 0 -Type DWord -Force

    $copEdge = "HKLM:\SOFTWARE\Policies\Microsoft\Edge"
    if (-not (Test-Path $copEdge)) { New-Item -Path $copEdge -Force | Out-Null }
    Set-ItemProperty -Path $copEdge -Name "CopilotCDPPageContext" -Value 0 -Type DWord -Force
    Set-ItemProperty -Path $copEdge -Name "DiscoverPageContextEnabled" -Value 0 -Type DWord -Force
    Write-ToBox $logCopilot "    Registry policies set." "Green"

    # Remove Copilot app if installed
    Write-ToBox $logCopilot "[3/5] Removing Copilot app package..." "Yellow"
    $copApps = @(
        "Microsoft.Windows.Ai.Copilot.Provider",
        "MicrosoftWindows.Client.AIX",
        "Microsoft.Copilot",
        "Microsoft.BingSearch"
    )
    foreach ($app in $copApps) {
        $pkg = Get-AppxPackage -Name $app -AllUsers -ErrorAction SilentlyContinue
        if ($pkg) {
            Remove-AppxPackage -Package $pkg.PackageFullName -AllUsers -ErrorAction SilentlyContinue
            Write-ToBox $logCopilot "    Removed: $app" "Green"
        }
        $prov = Get-AppxProvisionedPackage -Online -ErrorAction SilentlyContinue | Where-Object { $_.DisplayName -like $app }
        if ($prov) {
            Remove-AppxProvisionedPackage -Online -PackageName $prov.PackageName -ErrorAction SilentlyContinue | Out-Null
            Write-ToBox $logCopilot "    Deprovisioned: $app" "Green"
        }
    }
    Write-ToBox $logCopilot "    App removal complete." "Green"

    # Block Copilot/AI endpoints in hosts file
    Write-ToBox $logCopilot "[4/5] Blocking Copilot network endpoints..." "Yellow"
    $hostsPath    = "$env:SystemRoot\System32\drivers\etc\hosts"
    $hostsContent = Get-Content $hostsPath -Raw -ErrorAction SilentlyContinue
    $copMarker    = "COPILOT BLOCK START"
    if ($hostsContent -notlike "*$copMarker*") {
        $cb  = "`r`nCOPILOT BLOCK START`r`n"
        $cb += "0.0.0.0 copilot.microsoft.com`r`n"
        $cb += "0.0.0.0 sydney.bing.com`r`n"
        $cb += "0.0.0.0 copilot-backend.microsoft.com`r`n"
        $cb += "0.0.0.0 edgeservices.bing.com`r`n"
        $cb += "0.0.0.0 substrate.office.com`r`n"
        $cb += "0.0.0.0 api.cognitive.microsoft.com`r`n"
        $cb += "0.0.0.0 westus.api.cognitive.microsoft.com`r`n"
        $cb += "0.0.0.0 eastus.api.cognitive.microsoft.com`r`n"
        $cb += "0.0.0.0 inference.location.live.net`r`n"
        $cb += "0.0.0.0 bingaiassistant.microsoft.com`r`n"
        $cb += "COPILOT BLOCK END`r`n"
        Add-Content -Path $hostsPath -Value $cb
        Write-ToBox $logCopilot "    Hosts file patched with Copilot endpoints." "Green"
    } else {
        Write-ToBox $logCopilot "    Hosts already patched." "Gray"
    }
    ipconfig /flushdns | Out-Null

    # Firewall: block Copilot IPs
    Write-ToBox $logCopilot "[5/5] Creating firewall rules for Copilot..." "Yellow"
    Remove-NetFirewallRule -DisplayName "Block Copilot AI" -ErrorAction SilentlyContinue
    $copHosts = @("copilot.microsoft.com","sydney.bing.com","copilot-backend.microsoft.com","api.cognitive.microsoft.com")
    $copIPs = @()
    foreach ($h in $copHosts) {
        try {
            $ips = [System.Net.Dns]::GetHostAddresses($h) | ForEach-Object { $_.IPAddressToString }
            $copIPs += $ips | Where-Object { $_ -match "^[0-9]" }
        } catch { }
    }
    $copIPs = $copIPs | Sort-Object -Unique
    if ($copIPs.Count -gt 0) {
        New-NetFirewallRule -DisplayName "Block Copilot AI" -Direction Outbound -Action Block -RemoteAddress $copIPs -Protocol Any -Profile Any -Enabled True -ErrorAction SilentlyContinue | Out-Null
        Write-ToBox $logCopilot "    Firewall rule created blocking $($copIPs.Count) IPs." "Green"
    } else {
        Write-ToBox $logCopilot "    No IPs resolved (offline?). Hosts file block still active." "Yellow"
    }

    Write-ToBox $logCopilot "DONE. Copilot AI is blocked." "Cyan"
    $btnCopilot.Text      = "BLOCK COPILOT AI"
    $btnCopilot.BackColor = [System.Drawing.Color]::FromArgb(100, 20, 160)
    [System.Windows.Forms.MessageBox]::Show("All Microsoft Copilot AI has been blocked. A reboot is recommended.","Clean Up - Done","OK","Information")
})

# ================================================================
# TAB 3 - BLOATWARE NUKER
# ================================================================
$tabControl.ItemSize = New-Object System.Drawing.Size(160, 36)

$tab3           = New-Object System.Windows.Forms.TabPage
$tab3.Text      = "Bloat Nuker"
$tab3.BackColor = [System.Drawing.Color]::FromArgb(10, 10, 18)
$tabControl.TabPages.Add($tab3)

$lbl3Title           = New-Object System.Windows.Forms.Label
$lbl3Title.Text      = "BLOAT NUKER"
$lbl3Title.Font      = New-Object System.Drawing.Font("Consolas", 20, [System.Drawing.FontStyle]::Bold)
$lbl3Title.ForeColor = [System.Drawing.Color]::FromArgb(255, 140, 0)
$lbl3Title.AutoSize  = $true
$lbl3Title.Location  = New-Object System.Drawing.Point(20, 15)
$tab3.Controls.Add($lbl3Title)
$lbl3Sub           = New-Object System.Windows.Forms.Label
$lbl3Sub.Text      = "Advanced removal of preinstalled Windows bloatware - fully scrubbed"
$lbl3Sub.Font      = New-Object System.Drawing.Font("Consolas", 8)
$lbl3Sub.ForeColor = [System.Drawing.Color]::FromArgb(120, 120, 150)
$lbl3Sub.AutoSize  = $true
$lbl3Sub.Location  = New-Object System.Drawing.Point(22, 57)
$tab3.Controls.Add($lbl3Sub)
$sep5           = New-Object System.Windows.Forms.Panel
$sep5.Size      = New-Object System.Drawing.Size(600, 1)
$sep5.Location  = New-Object System.Drawing.Point(20, 78)
$sep5.BackColor = [System.Drawing.Color]::FromArgb(255, 140, 0)
$tab3.Controls.Add($sep5)
$btnSelectAll                           = New-Object System.Windows.Forms.Button
$btnSelectAll.Text                      = "SELECT ALL"
$btnSelectAll.Size                      = New-Object System.Drawing.Size(140, 26)
$btnSelectAll.Location                  = New-Object System.Drawing.Point(20, 86)
$btnSelectAll.BackColor                 = [System.Drawing.Color]::FromArgb(40, 40, 60)
$btnSelectAll.ForeColor                 = [System.Drawing.Color]::FromArgb(200, 200, 220)
$btnSelectAll.Font                      = New-Object System.Drawing.Font("Consolas", 8, [System.Drawing.FontStyle]::Bold)
$btnSelectAll.FlatStyle                 = "Flat"
$btnSelectAll.FlatAppearance.BorderSize = 1
$btnSelectAll.FlatAppearance.BorderColor= [System.Drawing.Color]::FromArgb(80, 80, 100)
$btnSelectAll.Cursor                    = [System.Windows.Forms.Cursors]::Hand
$tab3.Controls.Add($btnSelectAll)
$btnDeselectAll                           = New-Object System.Windows.Forms.Button
$btnDeselectAll.Text                      = "DESELECT ALL"
$btnDeselectAll.Size                      = New-Object System.Drawing.Size(140, 26)
$btnDeselectAll.Location                  = New-Object System.Drawing.Point(168, 86)
$btnDeselectAll.BackColor                 = [System.Drawing.Color]::FromArgb(40, 40, 60)
$btnDeselectAll.ForeColor                 = [System.Drawing.Color]::FromArgb(200, 200, 220)
$btnDeselectAll.Font                      = New-Object System.Drawing.Font("Consolas", 8, [System.Drawing.FontStyle]::Bold)
$btnDeselectAll.FlatStyle                 = "Flat"
$btnDeselectAll.FlatAppearance.BorderSize = 1
$btnDeselectAll.FlatAppearance.BorderColor= [System.Drawing.Color]::FromArgb(80, 80, 100)
$btnDeselectAll.Cursor                    = [System.Windows.Forms.Cursors]::Hand
$tab3.Controls.Add($btnDeselectAll)
$lblAppCount           = New-Object System.Windows.Forms.Label
$lblAppCount.Text      = "0 selected"
$lblAppCount.ForeColor = [System.Drawing.Color]::FromArgb(100, 100, 130)
$lblAppCount.Font      = New-Object System.Drawing.Font("Consolas", 8)
$lblAppCount.AutoSize  = $true
$lblAppCount.Location  = New-Object System.Drawing.Point(320, 92)
$tab3.Controls.Add($lblAppCount)
$clbApps                    = New-Object System.Windows.Forms.CheckedListBox
$clbApps.Size               = New-Object System.Drawing.Size(600, 340)
$clbApps.Location           = New-Object System.Drawing.Point(20, 118)
$clbApps.BackColor          = [System.Drawing.Color]::FromArgb(5, 5, 14)
$clbApps.ForeColor          = [System.Drawing.Color]::FromArgb(200, 200, 220)
$clbApps.Font               = New-Object System.Drawing.Font("Consolas", 9)
$clbApps.BorderStyle        = "None"
$clbApps.CheckOnClick       = $true
$clbApps.SelectionMode      = "One"
$clbApps.IntegralHeight     = $false
$tab3.Controls.Add($clbApps)
$logBloat             = New-Object System.Windows.Forms.RichTextBox
$logBloat.Size        = New-Object System.Drawing.Size(600, 100)
$logBloat.Location    = New-Object System.Drawing.Point(20, 464)
$logBloat.BackColor   = [System.Drawing.Color]::FromArgb(5, 5, 12)
$logBloat.ForeColor   = [System.Drawing.Color]::FromArgb(0, 230, 120)
$logBloat.Font        = New-Object System.Drawing.Font("Consolas", 9)
$logBloat.ReadOnly    = $true
$logBloat.BorderStyle = "None"
$logBloat.ScrollBars  = "Vertical"
$tab3.Controls.Add($logBloat)
$progBloat          = New-Object System.Windows.Forms.ProgressBar
$progBloat.Size     = New-Object System.Drawing.Size(600, 5)
$progBloat.Location = New-Object System.Drawing.Point(20, 570)
$progBloat.Style    = "Continuous"
$progBloat.Minimum  = 0
$progBloat.Maximum  = 100
$progBloat.Value    = 0
$tab3.Controls.Add($progBloat)
$btnPurge                           = New-Object System.Windows.Forms.Button
$btnPurge.Text                      = "PURGE SELECTED BLOATWARE"
$btnPurge.Size                      = New-Object System.Drawing.Size(600, 52)
$btnPurge.Location                  = New-Object System.Drawing.Point(20, 580)
$btnPurge.BackColor                 = [System.Drawing.Color]::FromArgb(180, 80, 0)
$btnPurge.ForeColor                 = [System.Drawing.Color]::White
$btnPurge.Font                      = New-Object System.Drawing.Font("Consolas", 14, [System.Drawing.FontStyle]::Bold)
$btnPurge.FlatStyle                 = "Flat"
$btnPurge.FlatAppearance.BorderSize = 0
$btnPurge.Cursor                    = [System.Windows.Forms.Cursors]::Hand
$tab3.Controls.Add($btnPurge)
$btnPurge.Add_MouseEnter({ $btnPurge.BackColor = [System.Drawing.Color]::FromArgb(220, 100, 0) })
$btnPurge.Add_MouseLeave({ $btnPurge.BackColor = [System.Drawing.Color]::FromArgb(180, 80, 0) })

$bloatApps = [System.Collections.Generic.List[string]]::new()
$bloatApps.Add("=== GAMING / XBOX ===")
$bloatApps.Add("Xbox App|Microsoft.XboxApp,Microsoft.Xbox.TCUI,Microsoft.XboxIdentityProvider")
$bloatApps.Add("Xbox Game Bar|Microsoft.XboxGamingOverlay,Microsoft.XboxGameOverlay")
$bloatApps.Add("Xbox Game Pass|Microsoft.GamingApp")
$bloatApps.Add("Xbox Speech to Text|Microsoft.XboxSpeechToTextOverlay")
$bloatApps.Add("=== COMMUNICATION ===")
$bloatApps.Add("Skype|Microsoft.SkypeApp")
$bloatApps.Add("Microsoft Teams Consumer|MicrosoftTeams,MSTeams")
$bloatApps.Add("Your Phone - Phone Link|Microsoft.YourPhone")
$bloatApps.Add("People|Microsoft.People")
$bloatApps.Add("Mail and Calendar|microsoft.windowscommunicationsapps")
$bloatApps.Add("=== MEDIA / ENTERTAINMENT ===")
$bloatApps.Add("Groove Music and Media Player|Microsoft.ZuneMusic")
$bloatApps.Add("Movies and TV|Microsoft.ZuneVideo")
$bloatApps.Add("Clipchamp Video Editor|Clipchamp.Clipchamp")
$bloatApps.Add("Mixed Reality Portal|Microsoft.MixedReality.Portal")
$bloatApps.Add("3D Viewer|Microsoft.Microsoft3DViewer")
$bloatApps.Add("Paint 3D|Microsoft.MSPaint")
$bloatApps.Add("Spotify Preinstalled|SpotifyAB.SpotifyMusic")
$bloatApps.Add("=== NEWS / WEATHER / MAPS ===")
$bloatApps.Add("Microsoft News|Microsoft.BingNews")
$bloatApps.Add("Weather|Microsoft.BingWeather")
$bloatApps.Add("Bing Finance|Microsoft.BingFinance")
$bloatApps.Add("Bing Sports|Microsoft.BingSports")
$bloatApps.Add("Maps|Microsoft.WindowsMaps")
$bloatApps.Add("=== OFFICE / PRODUCTIVITY ===")
$bloatApps.Add("Microsoft Office Hub|Microsoft.MicrosoftOfficeHub")
$bloatApps.Add("OneNote UWP|Microsoft.Office.OneNote")
$bloatApps.Add("OneDrive|Microsoft.OneDrive")
$bloatApps.Add("Microsoft To-Do|Microsoft.Todos")
$bloatApps.Add("Power Automate|Microsoft.PowerAutomateDesktop")
$bloatApps.Add("=== SYSTEM BLOAT ===")
$bloatApps.Add("Cortana|Microsoft.549981C3F5F10")
$bloatApps.Add("Get Help|Microsoft.GetHelp")
$bloatApps.Add("Tips and Get Started|Microsoft.Getstarted")
$bloatApps.Add("Feedback Hub|Microsoft.WindowsFeedbackHub")
$bloatApps.Add("Microsoft Solitaire Collection|Microsoft.MicrosoftSolitaireCollection")
$bloatApps.Add("Sticky Notes|Microsoft.MicrosoftStickyNotes")
$bloatApps.Add("Family Safety|MicrosoftCorporationII.MicrosoftFamily")
$bloatApps.Add("Quick Assist|MicrosoftCorporationII.QuickAssist")
$bloatApps.Add("Microsoft Wallet|Microsoft.Wallet")
$bloatApps.Add("Microsoft Advertising SDK|Microsoft.Advertising.Xaml")
$bloatApps.Add("=== THIRD PARTY PREINSTALLED ===")
$bloatApps.Add("TikTok|ByteDance.TikTok")
$bloatApps.Add("Facebook|Facebook.Facebook")
$bloatApps.Add("Instagram|Facebook.Instagram")
$bloatApps.Add("Amazon Shopping|Amazon.com.Amazon")
$bloatApps.Add("Disney Plus|Disney.37853FC22B2CE")
$bloatApps.Add("Candy Crush|king.com.CandyCrushSaga,king.com.CandyCrushFriends")
$bloatApps.Add("Duolingo|D5EA27B7.Duolingo-LearnLanguagesforFree")
$bloatApps.Add("Dolby Access|DolbyLaboratories.DolbyAccess")

foreach ($entry in $bloatApps) {
    if ($entry.StartsWith("===")) { $clbApps.Items.Add($entry) | Out-Null }
    else { $clbApps.Items.Add($entry.Split("|")[0]) | Out-Null }
}
$clbApps.Add_ItemCheck({
    $c = $clbApps.CheckedItems.Count
    $n = if ($_.NewValue -eq "Checked") { $c + 1 } else { [Math]::Max(0, $c - 1) }
    $lblAppCount.Text = "$n selected"
})
$btnSelectAll.Add_Click({
    for ($i = 0; $i -lt $clbApps.Items.Count; $i++) {
        if (-not $clbApps.Items[$i].ToString().StartsWith("===")) { $clbApps.SetItemChecked($i, $true) }
    }
    $lblAppCount.Text = "$($clbApps.CheckedItems.Count) selected"
})
$btnDeselectAll.Add_Click({
    for ($i = 0; $i -lt $clbApps.Items.Count; $i++) { $clbApps.SetItemChecked($i, $false) }
    $lblAppCount.Text = "0 selected"
})

$btnPurge.Add_Click({
    $selected = @()
    foreach ($item in $clbApps.CheckedItems) { $selected += $item.ToString() }
    if ($selected.Count -eq 0) {
        [System.Windows.Forms.MessageBox]::Show("Please check at least one app to remove.","Nothing Selected","OK","Warning")
        return
    }
    $confirm = [System.Windows.Forms.MessageBox]::Show(
        "You are about to permanently remove $($selected.Count) app(s) for ALL users.`n`nThis scrubs: AppX packages, provisioned packages, scheduled tasks, directories, and registry entries.`n`nContinue?",
        "Confirm Purge", "YesNo", "Warning"
    )
    if ($confirm -ne "Yes") { return }
    $btnPurge.Text    = "PURGING..."
    $logBloat.Clear()
    $progBloat.Value  = 0
    Write-ToBox $logBloat "Bloat Nuker - $($selected.Count) apps targeted..." "Cyan"
    Write-ToBox $logBloat "----------------------------------------" "Gray"
    $pkgMap = @{}
    foreach ($entry in $bloatApps) {
        if ($entry.Contains("|")) {
            $parts = $entry.Split("|")
            $pkgMap[$parts[0]] = $parts[1].Split(",")
        }
    }
    $total = $selected.Count; $cur = 0; $removed = 0; $skipped = 0
    foreach ($label in $selected) {
        $cur++
        $progBloat.Value = [int](($cur / $total) * 85)
        [System.Windows.Forms.Application]::DoEvents()
        Write-ToBox $logBloat "[$cur/$total] $label" "Yellow"
        if (-not $pkgMap.ContainsKey($label)) {
            Write-ToBox $logBloat "    Skipped (section header)." "Gray"
            $skipped++; continue
        }
        $found = $false
        foreach ($pkgName in ($pkgMap[$label] | ForEach-Object { $_.Trim() })) {
            Get-AppxPackage -Name "*$pkgName*" -ErrorAction SilentlyContinue | ForEach-Object {
                Remove-AppxPackage -Package $_.PackageFullName -ErrorAction SilentlyContinue
                Write-ToBox $logBloat "    AppX removed: $($_.Name)" "Green"
                $found = $true
            }
            Get-AppxPackage -Name "*$pkgName*" -AllUsers -ErrorAction SilentlyContinue | ForEach-Object {
                Remove-AppxPackage -Package $_.PackageFullName -AllUsers -ErrorAction SilentlyContinue
                Write-ToBox $logBloat "    AppX AllUsers removed: $($_.Name)" "Green"
                $found = $true
            }
            Get-AppxProvisionedPackage -Online -ErrorAction SilentlyContinue | Where-Object { $_.DisplayName -like "*$pkgName*" } | ForEach-Object {
                Remove-AppxProvisionedPackage -Online -PackageName $_.PackageName -ErrorAction SilentlyContinue | Out-Null
                Write-ToBox $logBloat "    Deprovisioned: $($_.DisplayName)" "Green"
                $found = $true
            }
            $ph = ($pkgName -split "[.]")[-1]
            Get-Process -Name "*$ph*" -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
            $pkgBase = "$env:LocalAppData\Packages"
            if (Test-Path $pkgBase) {
                Get-ChildItem $pkgBase -ErrorAction SilentlyContinue | Where-Object { $_.Name -like "*$pkgName*" } | ForEach-Object {
                    try {
                        & takeown /F $_.FullName /R /D Y 2>&1 | Out-Null
                        & icacls $_.FullName /grant administrators:F /T 2>&1 | Out-Null
                        Remove-Item $_.FullName -Recurse -Force -ErrorAction SilentlyContinue
                        Write-ToBox $logBloat "    Dir scrubbed: $($_.Name)" "Green"
                        $found = $true
                    } catch { }
                }
            }
            $regRoots = @(
                "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall",
                "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall",
                "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall"
            )
            foreach ($rr in $regRoots) {
                if (Test-Path $rr) {
                    Get-ChildItem $rr -ErrorAction SilentlyContinue | Where-Object {
                        ($_.GetValue("DisplayName","") -like "*$pkgName*") -or ($_.PSChildName -like "*$pkgName*")
                    } | ForEach-Object {
                        Remove-Item -Path $_.PSPath -Recurse -Force -ErrorAction SilentlyContinue
                        Write-ToBox $logBloat "    Registry key removed: $($_.PSChildName)" "Green"
                        $found = $true
                    }
                }
            }
            Get-ScheduledTask -ErrorAction SilentlyContinue | Where-Object {
                $_.TaskName -like "*$ph*" -or $_.TaskPath -like "*$pkgName*"
            } | ForEach-Object {
                Unregister-ScheduledTask -TaskName $_.TaskName -Confirm:$false -ErrorAction SilentlyContinue
                Write-ToBox $logBloat "    Scheduled task removed: $($_.TaskName)" "Green"
                $found = $true
            }
        }
        if ($found) {
            $removed++
            Write-ToBox $logBloat "    Done." "Green"
            $idxToRemove = $clbApps.Items.IndexOf($label)
            if ($idxToRemove -ge 0) { $clbApps.Items.RemoveAt($idxToRemove) }
            $lblAppCount.Text = "$($clbApps.CheckedItems.Count) selected"
            [System.Windows.Forms.Application]::DoEvents()
        } else { $skipped++; Write-ToBox $logBloat "    Not found (already absent)." "Gray" }
    }
    Write-ToBox $logBloat "----------------------------------------" "Gray"
    Write-ToBox $logBloat "Running advanced system hardening..." "Cyan"
    $cdm = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager"
    if (Test-Path $cdm) {
        $cdmKeys = @(
            "AutoInstallAppDownloads","FeatureManagementEnabled","OemPreInstalledAppsEnabled",
            "PreInstalledAppsEnabled","PreInstalledAppsEverEnabled","SilentInstalledAppsEnabled",
            "SoftLandingEnabled","SystemPaneSuggestionsEnabled","ContentDeliveryAllowed",
            "SubscribedContent-338388Enabled","SubscribedContent-338389Enabled",
            "SubscribedContent-310093Enabled","SubscribedContent-314563Enabled",
            "SubscribedContent-338387Enabled","RotatingLockScreenEnabled"
        )
        foreach ($ck in $cdmKeys) {
            Set-ItemProperty -Path $cdm -Name $ck -Value 0 -Type DWord -Force -ErrorAction SilentlyContinue
        }
        Write-ToBox $logBloat "    ContentDeliveryManager: auto-install blocked." "Green"
    }
    $adv = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
    Set-ItemProperty -Path $adv -Name "Start_TrackProgs"             -Value 0 -Type DWord -Force -ErrorAction SilentlyContinue
    Set-ItemProperty -Path $adv -Name "ShowSyncProviderNotifications" -Value 0 -Type DWord -Force -ErrorAction SilentlyContinue
    $expPol = "HKCU:\SOFTWARE\Policies\Microsoft\Windows\Explorer"
    if (-not (Test-Path $expPol)) { New-Item -Path $expPol -Force | Out-Null }
    Set-ItemProperty -Path $expPol -Name "HideRecommendedSection" -Value 1 -Type DWord -Force -ErrorAction SilentlyContinue
    Write-ToBox $logBloat "    Start Menu ads and suggestions disabled." "Green"
    $runKey = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run"
    Remove-ItemProperty -Path $runKey -Name "OneDrive" -Force -ErrorAction SilentlyContinue
    Write-ToBox $logBloat "    OneDrive startup entry removed." "Green"
    foreach ($xs in @("XblAuthManager","XblGameSave","XboxGipSvc","XboxNetApiSvc")) {
        if (Get-Service -Name $xs -ErrorAction SilentlyContinue) {
            Stop-Service -Name $xs -Force -ErrorAction SilentlyContinue
            Set-Service  -Name $xs -StartupType Disabled -ErrorAction SilentlyContinue
            Write-ToBox $logBloat "    Xbox service disabled: $xs" "Green"
        }
    }
    foreach ($st in @("MicrosoftEdgeUpdateTaskMachineCore","MicrosoftEdgeUpdateTaskMachineUA","OneDrive Standalone Update Task","XblGameSaveTask","DmClient","DmClientOnScenarioDownload")) {
        if (Get-ScheduledTask -TaskName $st -ErrorAction SilentlyContinue) {
            Disable-ScheduledTask -TaskName $st -ErrorAction SilentlyContinue | Out-Null
            Write-ToBox $logBloat "    Silent task disabled: $st" "Green"
        }
    }
    $progBloat.Value = 100
    Write-ToBox $logBloat "----------------------------------------" "Gray"
    Write-ToBox $logBloat "DONE. Removed: $removed  |  Not found: $skipped" "Cyan"
    Write-ToBox $logBloat "Auto-reinstall locked via ContentDeliveryManager." "Green"
    Write-ToBox $logBloat "Reboot to finalize all changes." "Yellow"
    Write-ToBox $logBloat "----------------------------------------" "Gray"
    $btnPurge.Text      = "PURGE SELECTED BLOATWARE"
    $btnPurge.BackColor = [System.Drawing.Color]::FromArgb(180, 80, 0)
    [System.Windows.Forms.MessageBox]::Show(
        "Bloat Nuker complete!`n`nRemoved: $removed app(s)`nNot found: $skipped`n`nAuto-reinstall has been blocked. Please reboot your PC.",
        "Bloat Nuker - Done", "OK", "Information"
    )
})


# Execute button for Tab 3 - triggers the purge
$btnExecute3                           = New-Object System.Windows.Forms.Button
$btnExecute3.Text                      = "EXECUTE"
$btnExecute3.Size                      = New-Object System.Drawing.Size(600, 52)
$btnExecute3.Location                  = New-Object System.Drawing.Point(20, 638)
$btnExecute3.BackColor                 = [System.Drawing.Color]::FromArgb(180, 20, 20)
$btnExecute3.ForeColor                 = [System.Drawing.Color]::White
$btnExecute3.Font                      = New-Object System.Drawing.Font("Consolas", 15, [System.Drawing.FontStyle]::Bold)
$btnExecute3.FlatStyle                 = "Flat"
$btnExecute3.FlatAppearance.BorderSize = 0
$btnExecute3.Cursor                    = [System.Windows.Forms.Cursors]::Hand
$tab3.Controls.Add($btnExecute3)
$btnExecute3.Add_MouseEnter({ $btnExecute3.BackColor = [System.Drawing.Color]::FromArgb(220, 30, 30) })
$btnExecute3.Add_MouseLeave({ $btnExecute3.BackColor = [System.Drawing.Color]::FromArgb(180, 20, 20) })
$btnExecute3.Add_Click({ $btnPurge.PerformClick() })

# Expand form and tab to fit both buttons
$form.Size        = New-Object System.Drawing.Size(660, 780)
$tabControl.Size  = New-Object System.Drawing.Size(644, 740)
[System.Windows.Forms.Application]::Run($form)