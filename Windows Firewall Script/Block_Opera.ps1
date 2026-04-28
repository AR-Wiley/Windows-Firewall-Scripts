
if (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "Please run this script as Administrator."
    return 
}
else {
    Write-Host "Running as Administrator."
}


function Block_Opera{

    $path = "$env:LOCALAPPDATA\Programs\Opera\launcher.exe"

    if(-not(Test-Path $path)){
        Write-Host "$path is not installed on machine..."
        return
    }
    
    $ruleName = "Block Opera"

    if (Get-NetFirewallRule -DisplayName $ruleName -ErrorAction SilentlyContinue) {
        Write-Host "Firewall rule '$ruleName' exists."
    } else {
        Try{
            New-NetFirewallRule -DisplayName $ruleName -Direction Outbound -Program $path -Action Block
        } Catch{
             Write-Host "Failed to create $ruleName..."
        }
    }

    Get-NetFirewallRule -DisplayName "Block Opera" | Format-List
}

Block_Opera
