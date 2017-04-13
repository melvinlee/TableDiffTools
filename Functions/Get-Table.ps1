function Get-Table
{
    <#
    .SYNOPSIS
    Populate table and schema name from database

    .DESCRIPTION
    Populate table and schema name from database

    .PARAMETER Server
    Specifies the server name.

    .PARAMETER Database
    Specifies the database name.

    .PARAMETER IsReplicated
    Identicate to retrieve replicated table only.

    .LINK
    Import-Module "sqlps"

    .NOTES
    #>

    [CmdletBinding()]
    [OutputType([PSObject])]
    param(
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]$Server,

        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]$Database,
        
        [Parameter()]
        [switch]$IsReplicated
    )          
    
    try {
        
        Import-Module "sqlps" -DisableNameChecking

        Write-Verbose "Connecting to server $Server ..."
        Write-Verbose "Querying $Database database schema ..."

        $schemas = Get-ChildItem SQLSERVER:\SQL\$Server\Default\Databases\$Database\schemas\ | Select-Object name

        $outputArray = @()

        foreach ($schema in $schemas)
        {           

            if($IsReplicated){

                Write-Verbose "Querying replicated table in $($schema.name) ..."

                $tables = Get-ChildItem SQLSERVER:\SQL\$Server\Default\Databases\$Database\tables\ `
                | Where-Object {$_.schema -eq $schema.name -and $_.replicated -eq $true } | Select-Object name

            }else{
                
                Write-Verbose "Querying all table in $($schema.name) ..."

                $tables = Get-ChildItem SQLSERVER:\SQL\$Server\Default\Databases\$Database\tables\ `
                | Where-Object {$_.schema -eq $schema.name} | Select-Object name

            }

            foreach ($table in $tables)
            {
                
                $outputObject = New-Object -TypeName PSObject
                $outputObject | Add-Member -Name 'Schema' -MemberType Noteproperty -Value $schema.name
                $outputObject | Add-Member -Name 'Table' -MemberType Noteproperty -Value $table.name
                $outputArray += $outputObject

                Write-Verbose "Found table $($schema.name).$($table.name)"
            }
        }
            
        return $outputArray
    }
    catch {
        Write-Error "Error on schema. $_.Exception.Message"
    }
}

