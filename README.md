# TableDiff Tools

## PowerShell Version

Please ensure you're running PowerShell version 3.0+

## Import Module

```Powershell
PS C:\>Import-Module .\TableDiffTools.psd1
```

To verify the module is loaded

```Powershell
PS C:\>Get-Module -Name "TableDiffTools"
```

## List of commands

The following is a list of commands which are available

|Command|Description|
|-------|-----------|
|Compare-Table|Execute tablediff to compere and find differences in table between 2 databases|
|Get-Table|Populate table and schema name from database|


## Usage

To retrieve tables by specific schema

```Powershell
PS C:\>Get-Table -Server <server> -Database <database> -FilterBySchema  "Foo","Bar" 
```

To retrieve tables participate in replication only

```Powershell
PS C:\>Get-Table -Server <server> -Database <database> -IsReplicated 
```

To compare single table

```Powershell
PS C:\>Compare-Table `
    -SourceTable "Foo.Config" `
    -SourceServer "<sourceserver>" `
    -SourceDatabase "<sourcedatabase>" `
    -TableDiffTool "C:\Program Files\Microsoft SQL Server\120\COM\tablediff.exe" `
    -DestinationServer "<destServer>" `
    -DestinationDatabase "<destdatabase>" `
    -OutputLocation "D:\Tablediff"
```

To compare tables by populating table detail from database using Get-Table cmdlet

```Powershell
PS C:\>$tables = Get-Table -Server <server> -Database <database> -IsReplicated 

PS C:\>$tables | Compare-Table `
    -SourceServer "<sourceserver>" `
    -SourceDatabase "<sourcedatabase>" `
    -TableDiffTool "C:\Program Files\Microsoft SQL Server\120\COM\tablediff.exe" `
    -DestinationServer "<destServer>" `
    -DestinationDatabase "<destdatabase>" `
    -OutputLocation "D:\Tablediff"
```

To compare tables by specific tables name

```Powershell
PS C:\>$table = @('Foo.Info','Bar.Config')

 PS C:\>$tables | Compare-Table `
    -InputTable $table
    -SourceServer "<sourceserver>" `
    -SourceDatabase "<sourcedatabase>" `
    -TableDiffTool "C:\Program Files\Microsoft SQL Server\120\COM\tablediff.exe" `
    -DestinationServer "<destServer>" `
    -DestinationDatabase "<destdatabase>" `
    -OutputLocation "D:\Tablediff"
```