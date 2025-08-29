<#
.SYNOPSIS
  Applies DISA STIG-aligned Windows Advanced Audit Policy baselines.

.DESCRIPTION
  - Enables "Force audit policy subcategory settings to override category settings".
  - Sets Advanced Audit Policy subcategories per DISA STIG themes.
  - Profiles: Workstation, MemberServer, DomainController.
  - Run as Administrator. Reboot not required (effective immediately).

.PARAMETER Profile
  Workstation | MemberServer | DomainController

.EXAMPLE
  .\Set-StigAuditPolicy.ps1 -Profile Workstation

.NOTES
  Aligns with current DISA Windows STIG families (Win10/11, Server 2019/2022/2025) and Microsoft advanced audit guidance.
#>

param(
  [ValidateSet("Workstation","MemberServer","DomainController")]
  [string]$Profile = "Workstation"
)

# --- Require elevation ---
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()
    ).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
  Write-Error "Run this script from an elevated PowerShell prompt."
  exit 1
}

Write-Host "==> Enforcing subcategory audit policy (SCENoApplyLegacyAuditPolicy=1) ..." -ForegroundColor Cyan
# STIG: Force subcategory settings to override category settings
New-Item -Path "HKLM:\System\CurrentControlSet\Control\Lsa" -Force | Out-Null
New-ItemProperty -Path "HKLM:\System\CurrentControlSet\Control\Lsa" `
  -Name "SCENoApplyLegacyAuditPolicy" -PropertyType DWord -Value 1 -Force | Out-Null

# Helper to emit auditpol command
function Set-Audit {
  param(
    [Parameter(Mandatory)][string]$Subcategory,
    [bool]$Success = $false,
    [bool]$Failure = $false
  )
  $s = if ($Success) { "enable" } else { "disable" }
  $f = if ($Failure) { "enable" } else { "disable" }
  Write-Host (" - {0} (Success:{1}, Failure:{2})" -f $Subcategory,$Success,$Failure) -ForegroundColor Yellow
  & auditpol /set /subcategory:"$Subcategory" /success:$s /failure:$f | Out-Null
}

# --- Common baseline for all profiles (Workstation/MemberServer/DC) ---
$common = @(
  # Account Logon
  @{Subcategory="Credential Validation";                Success=$true;  Failure=$true}
  @{Subcategory="Kerberos Authentication Service";      Success=$true;  Failure=$true}
  @{Subcategory="Kerberos Service Ticket Operations";   Success=$true;  Failure=$true}
  @{Subcategory="Other Account Logon Events";           Success=$true;  Failure=$true}

  # Account Management
  @{Subcategory="User Account Management";              Success=$true;  Failure=$false}
  @{Subcategory="Computer Account Management";          Success=$true;  Failure=$false}
  @{Subcategory="Security Group Management";            Success=$true;  Failure=$false}
  @{Subcategory="Distribution Group Management";        Success=$true;  Failure=$false}
  @{Subcategory="Other Account Management Events";      Success=$true;  Failure=$false}

  # Logon/Logoff
  @{Subcategory="Logon";                                Success=$true;  Failure=$true}
  @{Subcategory="Logoff";                               Success=$true;  Failure=$false}
  @{Subcategory="Account Lockout";                      Success=$true;  Failure=$true}
  @{Subcategory="Special Logon";                        Success=$true;  Failure=$false}
  @{Subcategory="Group Membership";                     Success=$true;  Failure=$false}
  @{Subcategory="Other Logon/Logoff Events";            Success=$true;  Failure=$true}

  # Object Access
  @{Subcategory="File Share";                           Success=$true;  Failure=$true}
  @{Subcategory="File System";                          Success=$true;  Failure=$true}
  @{Subcategory="Registry";                             Success=$true;  Failure=$true}
  @{Subcategory="SAM";                                  Success=$true;  Failure=$true}
  @{Subcategory="Removable Storage";                    Success=$true;  Failure=$true}
  @{Subcategory="Filtering Platform Connection";        Success=$true;  Failure=$true}
  @{Subcategory="Filtering Platform Packet Drop";       Success=$false; Failure=$true}
  @{Subcategory="Other Object Access Events";           Success=$true;  Failure=$true}
  @{Subcategory="Certification Services";               Success=$true;  Failure=$true}

  # Policy Change
  @{Subcategory="Audit Policy Change";                  Success=$true;  Failure=$true}
  @{Subcategory="Authentication Policy Change";         Success=$true;  Failure=$true}
  @{Subcategory="Authorization Policy Change";          Success=$true;  Failure=$false}
  @{Subcategory="MPSSVC Rule-Level Policy Change";      Success=$true;  Failure=$true} # Windows Firewall
  @{Subcategory="Filtering Platform Policy Change";     Success=$true;  Failure=$true}
  @{Subcategory="Other Policy Change Events";           Success=$false; Failure=$true}

  # Privilege Use
  @{Subcategory="Sensitive Privilege Use";              Success=$true;  Failure=$true}
  # (Non-Sensitive/Other Privilege Use left disabled unless required)

  # Detailed Tracking
  @{Subcategory="Process Creation";                     Success=$true;  Failure=$false}
  @{Subcategory="Process Termination";                  Success=$true;  Failure=$false}
  @{Subcategory="DPAPI Activity";                       Success=$true;  Failure=$true}
  @{Subcategory="RPC Events";                           Success=$true;  Failure=$true}
  @{Subcategory="Plug and Play Events";                 Success=$true;  Failure=$false}

  # System
  @{Subcategory="Security State Change";                Success=$true;  Failure=$false}
  @{Subcategory="Security System Extension";            Success=$true;  Failure=$true}
  @{Subcategory="System Integrity";                     Success=$true;  Failure=$true}
  @{Subcategory="IPsec Driver";                         Success=$false; Failure=$true}
  @{Subcategory="Other System Events";                  Success=$true;  Failure=$true}
)

# --- Extra auditing for Domain Controllers (Directory Service/DS Replication) ---
$dcOnly = @(
  # Directory Service Access (Domain Controllers)
  @{Subcategory="Directory Service Access";             Success=$true;  Failure=$true}
  @{Subcategory="Directory Service Changes";            Success=$true;  Failure=$false}
  @{Subcategory="Detailed Directory Service Replication"; Success=$true; Failure=$true}
  @{Subcategory="Directory Service Replication";        Success=$true;  Failure=$true}
)

# --- Apply policies ---
Write-Host "==> Applying STIG-aligned Advanced Audit Policy: $Profile" -ForegroundColor Cyan
$toApply = @()
$toApply += $common
if ($Profile -eq "DomainController") { $toApply += $dcOnly }

foreach ($item in $toApply) {
  Set-Audit @item
}

Write-Host "`n==> Effective audit policy (verify against STIG):" -ForegroundColor Cyan
& auditpol /get /category:* | Out-String | Write-Host
