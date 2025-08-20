<#
.SYNOPSIS
Opdaterer en eksisterende A-record i Windows DNS på den lokale maskine.

.DESCRIPTION
Dette script finder en eksisterende A-record i en DNS-zone og opdaterer dens IP-adresse til den angivne værdi på den lokale DNS-server. Det bruger DnsServer-modulet, som findes på Windows Server med DNS-rollen installeret.

.PARAMETER ZoneName
Navnet på DNS-zonen som indeholder recordet.

.PARAMETER RecordName
Navnet på recordet der skal opdateres.

.PARAMETER NewIPAddress
Ny IPv4-adresse til A-recordet.

.EXAMPLE
.\Update-DnsARecord.ps1 -ZoneName "contoso.com" -RecordName "www" -NewIPAddress "192.0.2.10"
#>

[CmdletBinding()]
param(
    [string]$ZoneName,

    [string]$RecordName,

    [System.Net.IPAddress]$NewIPAddress
)

if (-not $ZoneName) {
    $ZoneName = Read-Host "Indtast DNS-zonens navn"
}

if (-not $RecordName) {
    $RecordName = Read-Host "Indtast recordnavn"
}

if (-not $NewIPAddress) {
    try {
        $NewIPAddress = [System.Net.IPAddress]::Parse((Read-Host "Indtast ny IPv4-adresse"))
    } catch {
        Write-Error "Ugyldig IP-adresse: $_"
        exit 1
    }
}

try {
    $oldRecord = Get-DnsServerResourceRecord -ZoneName $ZoneName -Name $RecordName -RRType 'A'
} catch {
    Write-Error "Kunne ikke forespørge den lokale DNS-server: $_"
    exit 1
}

if (-not $oldRecord) {
    Write-Error "A-record '$RecordName' blev ikke fundet i zonen '$ZoneName'."
    exit 1
}

$newRecord = $oldRecord.Clone()
$newRecord.RecordData.IPv4Address = $NewIPAddress

Set-DnsServerResourceRecord -ZoneName $ZoneName -OldInputObject $oldRecord -NewInputObject $newRecord
Write-Host "Opdaterede $RecordName.$ZoneName til $NewIPAddress"

