<#
    .SYNOPSIS
    Saves the CA policies to files in the current working directory.

    .DESCRIPTION
    The script requires the Microsoft.Graph module to be installed. 
    It connects to the Microsoft Graph API with the permissions to read Conditional Access policies. 
    It retrieves all CA policies and saves them to files in the current working directory. 
    The files are named after the display name of the policy.

    .INPUTS
    None.

    .OUTPUTS
    Logs the status of the backup operation to the console.

    .EXAMPLE
    PS> Install-Module Microsoft.Graph -Force
    PS> .\Backup-CAPolicies.ps1

    .NOTES
    Written by: Robbert Verbruggen
    Website:    www.iamrobbert.com
    LinkedIn:   linkedin.com/in/rfverbruggen
#>

# Connect to Microsoft Graph API with the permissions to read Conditional Access policies
Connect-MgGraph -NoWelcome -Scopes 'Policy.Read.All'

try {
    # Retrieve all CA policies from Microsoft Graph API
    $CAPolicies = Get-MgIdentityConditionalAccessPolicy -All

    if ($CAPolicies.Count -eq 0) {
        Write-Host "WARN: No CA policies found to export." -ForegroundColor Yellow
    }
    else {
        # Iterate through each policy
        foreach ($CAPolicy in $CAPolicies) {
            try {
                # Get the display name of the policy
                $CAPolicyName = $CAPolicy.DisplayName
            
                # Convert the policy object to JSON
                $CAPolicyJSON = $CAPolicy | ConvertTo-Json -Depth 6
            
                # Write the JSON to a file in the current working directory
                $CAPolicyJSON | Out-File "$CAPolicyName.json" -Force
            
                Write-Host "INFO: CA policy: $($CAPolicyName) exported." -ForegroundColor Green
            }
            catch {
                Write-Host "ERROR: CA policy: $($Policy.DisplayName) export failed. $($_.Exception.Message)" -ForegroundColor Red
            }
        }
    }
}
catch {
    # Print a generic error message
    Write-Host "ERROR: $($_.Exception.Message)" -ForegroundColor Red
}
