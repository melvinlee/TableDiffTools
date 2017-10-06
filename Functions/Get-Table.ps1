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

    .PARAMETER FilterBySchema
    Filter table by schema.

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
        [string[]]$FilterBySchema,
        
        [Parameter()]
        [switch]$IsReplicated
    )          
    
    try {
        
        if (-Not (Get-Module -Name SQLASCMDLETS))
        {
            Import-Module "sqlps" -DisableNameChecking
        }
        
        Write-Verbose "Connecting to server $Server ..."
        Write-Verbose "Querying $Database database schema ..."
                
        # filter schema if filter exists
        if($FilterBySchema -gt 0)
        {
             $schemas = Get-ChildItem SQLSERVER:\SQL\$Server\Default\Databases\$Database\schemas\ | Where-Object {$FilterBySchema -CContains $_.name } | Select-Object name
        }
        else
        {
            $schemas = Get-ChildItem SQLSERVER:\SQL\$Server\Default\Databases\$Database\schemas\ | Select-Object name
        }


        $outputArray = @()

        foreach ($schema in $schemas)
        {           

            if($schemas.length -gt 1 )
            {
                Write-Progress -Activity "Processing database $Database" -status "Reading schema $($schema.name)" -percentComplete ($schemas.IndexOf($schema) / $schemas.count*100)
            }

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
                
                if($tables.length -gt 1 )
                {
                    Write-Progress -Activity "Processing database $Database" -status "Reading table $($table.name)" -percentComplete ($schemas.IndexOf($schema) / $schemas.count*100)
                }
                
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

