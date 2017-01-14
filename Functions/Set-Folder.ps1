function Set-Folder{

    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]$Folder
    ) 
  
    Try
    {
        If(!(Test-path $Folder))
        {
            Write-Verbose "Creating directory: $Folder ..."
            New-Item -ItemType Directory -Force -Path $Folder | Out-Null
        }
    }
    Catch
    {
        Write-Error "Error on creating directory. $_.Exception.Message"
        break
    }
}