# This script installs the Microsoft SSO extension for Google Chrome.

$RegPath = "HKLM:\Software\Policies\Google\Chrome\ExtensionInstallForcelist"
$ExtensionID = "ppnbnpeolgkicgegkbkbjmhlideopiji"
$UpdateURL = "https://clients2.google.com/service/update2/crx"

if (Test-Path $RegPath) {
    $props = (Get-ItemProperty -Path $RegPath).PSObject.Properties
    $exists = $props | Where-Object { $_.Value -like "$ExtensionID;*" }

    if ($exists) {
        exit 0
    }
} else {
    New-Item -Path $RegPath -Force | Out-Null
}

$existingProps = (Get-ItemProperty -Path $RegPath).PSObject.Properties
$indexes = $existingProps | Where-Object { $_.Name -match '^\d+$' } | Select-Object -ExpandProperty Name
if ($indexes) {
    $NextIndex = ([int]($indexes | Measure-Object -Maximum).Maximum) + 1
} else {
    $NextIndex = 1
}

New-ItemProperty -Path $RegPath -Name $NextIndex -Value "$ExtensionID;$UpdateURL" -PropertyType String -Force | Out-Null
exit 0
