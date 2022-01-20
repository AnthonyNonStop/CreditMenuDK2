$Version = 0.2

$Things = Invoke-RestMethod https://raw.githubusercontent.com/MrFlufficans/FluffyCreditMenuDK2/master/UtilVersion
$VersionLine = ($Things).split([Environment]::NewLine) | Select-String -Pattern "ModificationCheck" -SimpleMatch
$VersionLine = $VersionLine.ToString()
$VersionMaster = $VersionLine.SubString(($VersionLine.Length) -3)

(Invoke-RestMethod "https://artii.herokuapp.com/make?text=Fluffy+Utils&font=smslant") | Write-Host 
Write-Host "`n  You Are Running ModificationCheck v$Version"

if ($VersionMaster -gt $Version) {
    Write-Host "`n  There is a New Version Available v$VersionMaster`n        Would you Like to Update?"
    $ConfirmUpdate = Read-Host
}

If ($ConfirmUpdate.ToLower() -eq "yes" -or "y") {
    
    $Update = 1
} else {
    Write-Host "Continuing to Program"
    $Update = 0    
    
}
Start-Sleep 1

If ($Update) {
    Write-Host "Fetching Update"
    If (Test-Path -Path ./ModificationCheck*.ps1 -PathType Leaf) {rm ./ModificationCheck*.ps1}
    Invoke-RestMethod https://raw.githubusercontent.com/MrFlufficans/FluffyCreditMenuDK2/master/ModificationCheck.ps1 >> ModificationCheckv$VersionMaster.ps1
    Write-Host "Script Updated"

    Write-Host "Relaunching in 5"
    Start-Sleep 1
    Write-Host "Relaunching in 4"
    Start-Sleep 1
    Write-Host "Relaunching in 3"
    Start-Sleep 1
    Write-Host "Relaunching in 2"
    Start-Sleep 1
    Write-Host "Relaunching in 1"
    Start-Sleep 1
    Start-Process powershell ./ModificationCheckv$VersionMaster.ps1
    Exit
}


$ToShow = @()
$DaysBack = Read-Host "How many Days Since Patch"
$DaysBack = [int]$DaysBack
(Get-ChildItem -Attributes !D -exclude Results.txt,!resource_folder.txt,!help_entities.txt,LICENSE_OFL.txt -Recurse) | foreach {    
    $ParentFolder = ($_).Directory.Name
    $Name = ($_).Name
    
    if (($_).LastWriteTime.Year -lt (Get-Date).Year) {$Modified = 0} else {
        if (($_).LastWriteTime.Month -lt (Get-Date).Month) {$Modified = 0} else {
            If (($_).LastWriteTime.Day -gt (Get-Date).Day -$DaysBack) {$Modified = 1} else {
                if ($DaysBack -eq 0 -and ($_).LastWriteTime.Day -eq (Get-Date).Day) {
                    if (($_).LastWriteTime.Hour -lt (Get-Date).Hour) {$Modified = 1}
                } else {$Modified = 0}
            }
        }
    }
    
    if ($Modified) {
        if ($Modified) {$Modified = "True"}
        $Object = New-Object -TypeName PSObject
        Add-Member -InputObject $Object -MemberType NoteProperty -Name Modified -Value $Modified
        Add-Member -InputObject $Object -MemberType NoteProperty -Name ParentFolder -Value $ParentFolder
        Add-Member -InputObject $Object -MemberType NoteProperty -Name Name -Value $Name
        $ToShow += $Object
    }
}
Clear-Content Results.txt
$ToShow | Format-Table -Autosize 
Write-Host "Press Any Key to Output to Text"
cmd /c pause | out-null
$ToShow | Format-Table -Autosize >> Results.txt
