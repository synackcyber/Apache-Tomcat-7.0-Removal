$days_to_check=$(Get-Date).AddDays(-365)
$getfile=Get-Item "C:\Program Files (x86)\Apache Software Foundation\Tomcat 7.0\logs\*.*" | where { $_.LastWriteTime -gt $days_to_check } | Foreach {
“File Name: ” + $_.Name
}
if ($getfile -gt 1) {
    Write-host "File Changed within past year. Abort!"
    exit
}
    else {
        Write-Host "File has not been changed in 365 days. Starting Removal!"
        Start-Sleep -Seconds 10
        cd "C:\Program Files (x86)\Apache Software Foundation\Tomcat 7.0\logs\*.*"
        ./Uninstall.exe /S -ServiceName="Tomcat7"
        cd C:\
        Start-Sleep -Seconds 15
        rmdir -r "C:\Program Files (x86)\Apache Software Foundation\"
        Write-Host "removal complete"
        exit
    }
