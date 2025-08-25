<#
.SYNOPSIS
Deaktiverer et netværksinterface på Windows Server 2022.

.DESCRIPTION
Scriptet bruger cmdleten Disable-NetAdapter til at slukke for et angivet netværksinterface.
Hvis interfacets navn ikke angives som parameter, spørger scriptet brugeren.

.PARAMETER InterfaceAlias
Navnet på netværksadapteren der skal deaktiveres.

.EXAMPLE
.\Disable-NetworkInterface.ps1 -InterfaceAlias 'Ethernet0'
Deaktiverer netværksinterfacet med aliaset 'Ethernet0'.
#>
[CmdletBinding()]
param(
    [string]$InterfaceAlias
)

if (-not $InterfaceAlias) {
    $InterfaceAlias = Read-Host 'Indtast navnet på det interface der skal slukkes'
}

try {
    Disable-NetAdapter -Name $InterfaceAlias -Confirm:$false
    Write-Host ("Interface '{0}' er deaktiveret." -f $InterfaceAlias)
} catch {
    Write-Error ("Kunne ikke deaktivere interface '{0}': {1}" -f $InterfaceAlias, $_)
    exit 1
}
