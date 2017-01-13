#requires -version 4

<#
.SYNOPSIS
Execute tablediff to compere and find differences in table between 2 databases.

.DESCRIPTION
Execute tablediff to compere and find differences in table between 2 databases.

.PARAMETER SourceServer
Specifies the source server.

.PARAMETER SourceDatabase
Specifies the source database.

.PARAMETER SourceTable
Specifies the source table.

.PARAMETER DestinationServer
Specifies the destination server.

.PARAMETER DestinationDatabase
Specifies the destination database.

.PARAMETER DestinationTable
Specifies the destination table.

.PARAMETER TableDiffToolPath
Specifies the TableDiff.exe path.

.PARAMETER OutputLocation
Specifies the path of the output file.

.PARAMETER Force
Indicates that output scripts will be overwrite if exists

.EXAMPLE
Compare-Table -SourceServer "server1" -SourceDatabase "mydb" -SourceTable "customer" -DestinationServer "server2" -DestinationDatabase "mydb" -DestinationTable "customer" -OutputLocation "D:\Result"
Description
-----------
This command will execute tableDiff.exe using parameter -SourceDatabase "mydb" -SourceTable "customer" -DestinationServer "server2" -DestinationDatabase "mydb" -DestinationTable "customer", result will be output to folder "D:\Result"

.EXAMPLE
Compare-Table -SourceServer "server1" -SourceDatabase "mydb" -SourceTable "sale.customer" -DestinationServer "server2" -DestinationDatabase "mydb" -DestinationTable "sale.customer" -OutputLocation "D:\Result"
Description
-----------
This command will execute tableDiff.exe using schema "sale" on source table and destination table

.EXAMPLE
Compare-Table -SourceServer "server1" -SourceDatabase "mydb" -SourceTable "customer" -DestinationServer "server2" -DestinationDatabase "mydb" -DestinationTable "customer" -OutputLocation "D:\Result" -TableDiffToolPath "D:\Tools"
Description
-----------
This command will execute tableDiff.exe located in path "D:\Tools"

.NOTES
#>

function Compare-Table
{
    [CmdletBinding(SupportsShouldProcess=$true)]
    param(
        [Parameter(Mandatory=$true,Position=1)]
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
        [ValidateNotNullOrEmpty()]
        [string]$DestinationTable,

        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]$OutputLocation,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]$TableDiffToolPath="C:\Program Files\Microsoft SQL Server\120\COM",

        [Parameter()]
        [Switch]$Force

    )

    If ($PSCmdlet.ShouldProcess("SourceServer: [$SourceServer], DestinationServer: [$DestinationServer]","Executing tableDiff.exe") ) 
    {        

        If(!(Test-path $OutputLocation))
        {
            New-Item -ItemType Directory -Force -Path $OutputLocation | Out-Null
        }

        # Validate folder
        
        # Set tablediff.exe location
        $TableDiffTool = $TableDiffToolPath + "\tablediff.exe"

        $output = $OutputLocation + "\Output.txt"
        
        # Set diff script
        $diffScript = $OutputLocation + "\" + $SourceTable + ".sql"
                 
        # If file exists throw the errror.
        if ((Test-Path $diffScript) -eq $true)
        {
            if($Force){
                Remove-Item $diffScript | Out-Null
            }else{
                throw "The file " + $diffScript + " already exists."
            }
        }

        $SourceSchema = "dbo"
        $DestinationSchema = "dbo"

        # Extract schema
        if ($SourceTable.Contains("."))
        {
            $temp = $SourceTable.Split(".")
            $SourceSchema = $temp[0]
            $SourceTable = $temp[1]
        }

        if ($DestinationTable.Contains("."))
        {
            $temp = $DestinationTable.Split(".")
            $DestinationSchema = $temp[0]
            $DestinationTable = $temp[1]
        }

        Write-Verbose "SourceServer: $SourceServer"
        Write-Verbose "SourceDatabase: $SourceDatabase"
        Write-Verbose "SourceSchema: $SourceSchema"
        Write-Verbose "SourceTable: $SourceTable"
        Write-Verbose "DestinationServer: $DestinationServer"
        Write-Verbose "DestinationDatabase: $DestinationDatabase"
        Write-Verbose "DestinatioSchema: $DestinationSchema"
        Write-Verbose "DestinationTable: $DestinationTable"
        Write-Verbose "OutputLocation: $OutputLocation"
        Write-Verbose "TableDiffToolPath: $TableDiffToolPath"

        & $TableDiffTool -sourceserver $SourceServer `
        -sourcedatabase $SourceDatabase `
        -sourceschema $SourceSchema `
        -sourcetable $SourceTable `
        -destinationserver $DestinationServer `
        -destinationdatabase $DestinationDatabase `
        -destinationschema $DestinationSchema `
        -destinationtable $DestinationTable `
        -f $diffScript -o $output
        
        if ($LastExitCode -eq 1)
        {
            throw "Error on table " + $SourceTable + " with exit code $LastExitCode"
        }

    }
}

