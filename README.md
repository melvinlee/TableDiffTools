# TableDiff Tools

## PowerShell Version

Please ensure you're running PowerShell version 3.0+

## Import Module

    Import-Module .\TableDiffTools.psd1

To verify the module is loaded

    Get-Module -Name "TableDiffTools"

## List of commands

The following is a list of commands which are available

|Command|Description|
|-------|-----------|
|Compare-Table|Execute tablediff to compere and find differences in table between 2 databases|
|Get-Table|Populate table and schema name from database|


## Usage

To retrieve tables by specific schema
    
    Get-Table -Server <server> -Database <database> -FilterBySchema  "SI","SM" 

To retrieve tables participate in replication only

    Get-Table -Server <server> -Database <database> -IsReplicated 

To compare single table

    Compare-Table `
    -SourceTable "SI.Config" `
    -SourceServer <sourceserver> `
    -SourceDatabase <sourcedatabase> `
    -TableDiffTool "C:\Program Files\Microsoft SQL Server\120\COM\tablediff.exe" `
    -DestinationServer <destServer> `
    -DestinationDatabase <destdatabase> `
    -OutputLocation D:\Tablediff

To compare tables by populating table detail from database using Get-Table cmdlet

     $tables = Get-Table -Server <server> -Database <database> -IsReplicated 

     $tables | Compare-Table `
    -SourceServer <sourceserver> `
    -SourceDatabase <sourcedatabase> `
    -TableDiffTool "C:\Program Files\Microsoft SQL Server\120\COM\tablediff.exe" `
    -DestinationServer <destServer> `
    -DestinationDatabase <destdatabase> `
    -OutputLocation D:\Tablediff

To compare tables by specific tables name

     $table = @('SI.GameType','SI.Config')

     $tables | Compare-Table `
    -InputTable $table
    -SourceServer <sourceserver> `
    -SourceDatabase <sourcedatabase> `
    -TableDiffTool "C:\Program Files\Microsoft SQL Server\120\COM\tablediff.exe" `
    -DestinationServer <destServer> `
    -DestinationDatabase <destdatabase> `
    -OutputLocation D:\Tablediff
