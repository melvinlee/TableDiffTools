function Invoke-TableDiff
{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]$SourceServer,

        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]$SourceDatabase,

        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]$SourceTable,
        
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]$DestinationServer,

        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]$DestinationDatabase,

        [Parameter(Mandatory=$true)]
        [string]$DestinationTable,

        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]$OutputLocation,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]$TableDiffTool,

        [Parameter()]
        [bool]$OverwriteFixSql = $false

    )        

    Set-Folder -Folder $OutputLocation
        
    $output = $OutputLocation + "\Output.txt"
    
    # Set fixSql script
    $fixSql = $OutputLocation + "\" + $SourceTable + ".sql"
                
    # If file exists throw the errror.
    if ((Test-Path $fixSql) -eq $true)
    {
        if($OverwriteFixSql){
            Remove-Item $fixSql | Out-Null
        }else{
            throw "The file " + $fixSql + " already exists."
        }
    }

    $processSourceSchema = Set-Schema -Table $SourceTable

    $SourceSchema = $processSourceSchema[0]
    $SourceTable = $processSourceSchema[1]

    $processDestinationSchema = Set-Schema -Table $DestinationTable

    $DestinationSchema = $processDestinationSchema[0]
    $DestinationTable = $processDestinationSchema[1]

    Write-Verbose "SourceServer: $SourceServer"
    Write-Verbose "SourceDatabase: $SourceDatabase"
    Write-Verbose "SourceSchema: $SourceSchema"
    Write-Verbose "SourceTable: $SourceTable"
    Write-Verbose "DestinationServer: $DestinationServer"
    Write-Verbose "DestinationDatabase: $DestinationDatabase"
    Write-Verbose "DestinatioSchema: $DestinationSchema"
    Write-Verbose "DestinationTable: $DestinationTable"
    Write-Verbose "OutputLocation: $OutputLocation"
    Write-Verbose "FixSql: $fixSql"
    Write-Verbose "TableDiffTool: $TableDiffTool"

    & $TableDiffTool -sourceserver $SourceServer `
    -sourcedatabase $SourceDatabase `
    -sourceschema $SourceSchema `
    -sourcetable $SourceTable `
    -destinationserver $DestinationServer `
    -destinationdatabase $DestinationDatabase `
    -destinationschema $DestinationSchema `
    -destinationtable $DestinationTable `
    -f $fixSql -o $output
    
    if ($LastExitCode -eq 1)
    {
        throw "Error on table " + $SourceTable + " with exit code $LastExitCode"
    }
}

