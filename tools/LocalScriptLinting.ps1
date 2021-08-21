function Invoke-ScriptLinting {
    [CmdletBinding()]
    param(
        [string]$Path
    )
    $Result = Invoke-ScriptAnalyzer -Path $Path -Severity @('Error', 'Warning') -Recurse
    if ($Result) {
        $Result | Format-Table
        Write-Host -AnsiColors "$($Result.SuggestedCorrections.Count) linting errors or warnings were found." -ForegroundColor Red
        EXIT 1
    }
}

$BuildHelperVars = Get-Item ENV:BH*
if (!$BuildHelperVars) {
    Set-BuildEnvironment
}

Write-Host "Linting Module"
Invoke-ScriptLinting -Path $ENV:BHModulePath

Write-Host "Linting Tests"
Invoke-ScriptLinting -Path "$($ENV:BHProjectPath)/tests"
