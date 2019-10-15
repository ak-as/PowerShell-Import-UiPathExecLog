
[CmdletBinding()]
Param
(
	[Parameter(Position=0, Mandatory=$true)]
	[Alias("p")]
	[ValidateNotNullOrEmpty()]
	[string[]]
	$Path,

	[Alias("e")]
	[Microsoft.PowerShell.Commands.FileSystemCmdletProviderEncoding]
	$Encoding,

	[Alias("sl")]
	[Int64]
	$StartLine = 1,

	[Alias("el", "Head", "h", "n")]
	[Int64]
	$EndLine,

	[Alias("t")]
	[Int64]
	$Tail,

	[Alias("f")]
	[ScriptBlock]
	$Filter = {$true}
)

$CatCmd = 'cat -ReadCount 1'
if ($PSBoundParameters.ContainsKey("Encoding")) {
	$CatCmd += ' -Encoding $Encoding'
}
if ($PSBoundParameters.ContainsKey("EndLine")) {
	$CatCmd += ' -Head $EndLine'
}
if ($PSBoundParameters.ContainsKey("Tail")) {
	$CatCmd += ' -Tail $Tail'
}

Convert-Path -Path $Path | %{
	$FullPath = $_
	$CurrLineNum = 1
	iex ($CatCmd + ' -Path $FullPath') | %{
		if ($StartLine -le $CurrLineNum) {
			$_
		}
		$CurrLineNum++
	}
}

