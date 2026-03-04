<#
.SYNOPSIS
    Configures Teams Rooms resource account sign-in via SkypeSettings.xml.

.DESCRIPTION
    Deploys resource account credentials to a Teams Rooms on Windows device by writing
    a SkypeSettings.xml file to the MTR app's LocalState directory. The Teams Rooms app
    reads the file at next startup, signs in with the provided credentials, and deletes
    the file automatically.

    This script supports two credential sources:
    - Azure Key Vault (recommended for production)
    - Direct parameter input (for testing only)

    Deploy this script via Intune (Devices > Windows > Scripts) targeting your MTR device group.

    For new Windows 11 deployments, consider using Pro Management Portal Autologin instead,
    which handles credentials entirely in the cloud with no local file.

.PARAMETER ResourceAccountUPN
    The UPN (email address) of the Teams Rooms resource account.
    Example: mtr-hq-101@contoso.com

.PARAMETER KeyVaultName
    The name of the Azure Key Vault containing the resource account password.
    The secret name is derived from the UPN by replacing @ and . with hyphens.
    Example: If UPN is mtr-hq-101@contoso.com, secret name is mtr-hq-101-contoso-com

.PARAMETER Password
    Direct password input. USE ONLY FOR TESTING. In production, use -KeyVaultName
    to retrieve the password from Azure Key Vault at runtime.

.PARAMETER RestartApp
    Restart the Teams Rooms app after writing the XML file. Default: $true.

.EXAMPLE
    # Production: Retrieve password from Azure Key Vault
    .\Set-MTRAutoLogin.ps1 -ResourceAccountUPN "mtr-hq-101@contoso.com" -KeyVaultName "kv-mtr-prod"

.EXAMPLE
    # Testing only: Direct password
    .\Set-MTRAutoLogin.ps1 -ResourceAccountUPN "mtr-hq-101@contoso.com" -Password "TestPassword123!"

.NOTES
    Requirements:
    - Must run as SYSTEM (Intune scripts run as SYSTEM by default)
    - For Key Vault: Az.KeyVault module and device managed identity or pre-configured authentication
    - The Skype user profile must exist (standard on all MTR-W devices)

    Security considerations:
    - The password exists in plaintext in the XML file briefly until the app processes and deletes it
    - Key Vault retrieval ensures the password is never stored in the script source
    - Intune script source is visible to Intune administrators — never hardcode passwords
#>

[CmdletBinding(SupportsShouldProcess)]
param(
    [Parameter(Mandatory = $true)]
    [ValidatePattern('^[^@]+@[^@]+\.[^@]+$')]
    [string]$ResourceAccountUPN,

    [Parameter(Mandatory = $true, ParameterSet = 'KeyVault')]
    [string]$KeyVaultName,

    [Parameter(Mandatory = $true, ParameterSet = 'Direct')]
    [string]$Password,

    [Parameter()]
    [bool]$RestartApp = $true
)

$ErrorActionPreference = 'Stop'

# Constants
$LocalStatePath = "C:\Users\Skype\AppData\Local\Packages\Microsoft.SkypeRoomSystem_8wekyb3d8bbwe\LocalState"
$XmlFilePath = Join-Path $LocalStatePath "SkypeSettings.xml"

# Validate the LocalState directory exists (confirms this is an MTR device)
if (-not (Test-Path $LocalStatePath)) {
    Write-Error "Teams Rooms LocalState directory not found at '$LocalStatePath'. Is this a Teams Rooms on Windows device?"
    exit 1
}

# Retrieve password
if ($PSCmdlet.ParameterSetName -eq 'KeyVault') {
    Write-Verbose "Retrieving password from Azure Key Vault '$KeyVaultName'..."

    # Derive secret name from UPN: mtr-hq-101@contoso.com -> mtr-hq-101-contoso-com
    $secretName = $ResourceAccountUPN -replace '[@.]', '-'

    try {
        # Import Az.KeyVault if not already loaded
        if (-not (Get-Module -Name Az.KeyVault -ListAvailable)) {
            Write-Error "Az.KeyVault module is not installed. Install with: Install-Module Az.KeyVault -Scope CurrentUser"
            exit 1
        }
        Import-Module Az.KeyVault -ErrorAction Stop

        # Connect using managed identity (for Intune-deployed scripts on Entra ID joined devices)
        if (-not (Get-AzContext -ErrorAction SilentlyContinue)) {
            Connect-AzAccount -Identity -ErrorAction Stop
        }

        $secret = Get-AzKeyVaultSecret -VaultName $KeyVaultName -Name $secretName -ErrorAction Stop
        $Password = $secret.SecretValue | ConvertFrom-SecureString -AsPlainText
        Write-Verbose "Password retrieved successfully from Key Vault."
    }
    catch {
        Write-Error "Failed to retrieve secret '$secretName' from Key Vault '$KeyVaultName': $_"
        exit 1
    }
}
elseif ($PSCmdlet.ParameterSetName -eq 'Direct') {
    Write-Warning "Using direct password input. This is acceptable for testing but NOT recommended for production. Use -KeyVaultName for secure credential retrieval."
}

# Validate we have a password
if ([string]::IsNullOrWhiteSpace($Password)) {
    Write-Error "Password is empty. Cannot configure Autologin."
    exit 1
}

# Escape XML special characters in the password
$escapedPassword = [System.Security.SecurityElement]::Escape($Password)
$escapedUPN = [System.Security.SecurityElement]::Escape($ResourceAccountUPN)

# Build the SkypeSettings.xml content
$xmlContent = @"
<SkypeSettings>
  <UserAccount>
    <SkypeSignInAddress>$escapedUPN</SkypeSignInAddress>
    <Password>$escapedPassword</Password>
  </UserAccount>
</SkypeSettings>
"@

# Write the XML file
if ($PSCmdlet.ShouldProcess($XmlFilePath, "Write SkypeSettings.xml with resource account credentials")) {
    try {
        $xmlContent | Out-File -FilePath $XmlFilePath -Encoding UTF8 -Force
        Write-Verbose "SkypeSettings.xml written to '$XmlFilePath'."
    }
    catch {
        Write-Error "Failed to write SkypeSettings.xml: $_"
        exit 1
    }

    # Verify the file was written
    if (-not (Test-Path $XmlFilePath)) {
        Write-Error "SkypeSettings.xml was not created at '$XmlFilePath'."
        exit 1
    }

    # Validate XML is well-formed
    try {
        [xml]$null = Get-Content $XmlFilePath
        Write-Verbose "XML validation passed."
    }
    catch {
        Remove-Item $XmlFilePath -Force -ErrorAction SilentlyContinue
        Write-Error "Generated XML is malformed. File removed. Error: $_"
        exit 1
    }

    # Restart the Teams Rooms app to trigger credential processing
    if ($RestartApp) {
        $process = Get-Process -Name "Microsoft.SkypeRoomSystem" -ErrorAction SilentlyContinue
        if ($process) {
            Write-Verbose "Restarting Teams Rooms app to process credentials..."
            $process | Stop-Process -Force
            # The app will restart automatically via Shell Launcher V2
            Write-Verbose "Teams Rooms app stopped. Shell Launcher will restart it automatically."
        }
        else {
            Write-Verbose "Teams Rooms app is not currently running. Credentials will be processed at next app launch."
        }
    }

    Write-Output "Autologin configured for '$ResourceAccountUPN'. The Teams Rooms app will sign in and delete the XML file automatically."
}

# Clear the password from memory
$Password = $null
[System.GC]::Collect()
