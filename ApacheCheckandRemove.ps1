## Test Uninstall Path
$pathtest = "C:\Program Files (x86)\Apache Software Foundation\Tomcat 7.0\Uninstall.exe"
$condition = Test-Path -Path $pathtest
if ( $condition )
{
    Write-Output "Directory Found"
}
    else {
        Write-Host "Directory not found. Exiting."
        exit
    }

## Test Log Path
$logpathtest = "C:\Program Files (x86)\Apache Software Foundation\Tomcat 7.0\logs\"
$logcondition = Test-Path -Path $logpathtest
if ( $logcondition )
{
    Write-Output "Log Directory Found"
}
    else {
        Write-Host "Log Directory not found. Exiting."
        exit
    }

## File date check Vars
$days_to_check = $(Get-Date).AddDays(-365)
$getfile = Get-Item "C:\Program Files (x86)\Apache Software Foundation\Tomcat 7.0\logs\*.*" | where { $_.LastWriteTime -gt $days_to_check } | Foreach {
â€œFile Name: â€ + $_.Name
}

## Check if apache log files have been updated/modified in the past year. Everytime the TomCat7 service starts the logfile date is updated.
if ($getfile -gt 1) {
    Write-host "File Changed within past year. Aborting Tomcat7 Removal.."
    exit
}

## Uninstall and remove dir if file has not been changed in a year.
    else {
        Write-Host "File has not been changed in 365 days. Starting Removal.."
        Start-Sleep -Seconds 5
        cd "C:\Program Files (x86)\Apache Software Foundation\Tomcat 7.0\"
        Start-Sleep -Seconds 5
        ./Uninstall.exe /S -ServiceName="Tomcat7"
    }

## Backup Registry entires for TomCat7 Services.
$regtestpath = test-path -path "HKLM:\SYSTEM\CurrentControlSet\Services\Tomcat7"

if ($regtestpath) {
    reg export 'HKLM\SYSTEM\CurrentControlSet\Services\Tomcat7' C:\Temp\apacheRegKey_bak.reg
    Start-Sleep -Seconds 5
    Remove-Item -Path "HKLM:\SYSTEM\CurrentControlSet\Services\Tomcat7" -Recurse -Force
    Write-Host "Registry entry has been backed up to C:\Temp and deleted. Please reboot PC at earliest convenience to remove Apache7 from services list."
}
    else {
        Write-Host "Registry Key not found. Backup and removal failed"
        exit
    }

## Remove Apache Directory
cd C:\
rmdir -r "C:\Program Files (x86)\Apache Software Foundation\"
Write-Host "Removal of Apache Tomcat 7 Complete"
