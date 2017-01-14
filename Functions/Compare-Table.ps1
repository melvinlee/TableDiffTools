
function Compare-Table
{
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

    .PARAMETER TableDiffTool
    Specifies the TableDiff.exe file location.

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

        [Parameter()]
        [string]$DestinationTable,

        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]$OutputLocation,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]$TableDiffTool="C:\Program Files\Microsoft SQL Server\120\COM\tablediff.exe",

        [Parameter()]
        [Switch]$Force

    )

    If ($PSCmdlet.ShouldProcess("SourceServer: [$SourceServer], DestinationServer: [$DestinationServer]","Executing tableDiff.exe") ) 
    {        

        $OverwriteFixSql = $false

        If($Force){
            $OverwriteFixSql = $true
        }
        
        # If destinationTable not define, use sourceTable name
        if (!$DestinationTable){
            $DestinationTable = $SourceTable
        }

        Try{
            
            Invoke-TableDiff -SourceServer $SourceServer -SourceDatabase $SourceDatabase -SourceTable $SourceTable `
            -DestinationServer $DestinationServer -DestinationDatabase $DestinationDatabase -DestinationTable $DestinationTable `
            -OutputLocation $OutputLocation -TableDiffTool $TableDiffTool -OverwriteFixSql $OverwriteFixSql

        }Catch{
            
            Write-Error "Error on Invoke-TableDiff. $_.Exception.Message"

        }
        
    }
}

