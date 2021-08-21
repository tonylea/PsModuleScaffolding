$RootFolder = (Get-Item -Path $PSScriptRoot).Parent

Import-Module "$RootFolder/helpers/Export-NUnitXml/Export-NUnitXml.psm1" -Force
Import-Module "$RootFolder/helpers/Set-BuildHelperEnvVars/Set-BuildHelperEnvVars.psm1" -Force

Set-BuildHelperEnvVars

$ModulePath = $ENV:BHModulePath

$ScriptAnalyzerRules = Get-ScriptAnalyzerRule -Severity @("Error", "Warning")
$ScriptAnalyzerResult = Invoke-ScriptAnalyzer -Path $ModulePath -IncludeRule $ScriptAnalyzerRules -Recurse
If ( $ScriptAnalyzerResult ) {
    $ScriptAnalyzerResultString = $ScriptAnalyzerResult | Out-String
    Write-Warning $ScriptAnalyzerResultString
}
Export-NUnitXml -ScriptAnalyzerResult $ScriptAnalyzerResult -Path ".\ScriptAnalyzerResult.xml"

If ( $ScriptAnalyzerResult ) {
    # Failing the build
    Throw "There was PSScriptAnalyzer violation(s). See test results for more information."
}
