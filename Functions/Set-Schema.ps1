function Set-Schema{

    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]$Table
    )
    
    # Extract schema
    if ($Table.Contains("."))
    {
        $temp = $Table.Split(".")
        $schema = $temp[0]
        $table = $temp[1]
    }else {
        $schema = "dbo"
        $table = $Table
    }

    return $schema, $table
}   