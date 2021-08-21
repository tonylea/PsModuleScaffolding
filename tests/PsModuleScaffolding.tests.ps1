$ManifestPath = $ENV:BHPSModuleManifest
$ModuleName = $ENV:BHProjectName
$ModulePath = $ENV:BHModulePath

Describe "$ModuleName Manifest" {

    $ManifestHash = Import-PowerShellDataFile -Path $ManifestPath

    It "Has a valid manifest" {
        {
            $null = Test-ModuleManifest -Path $ManifestPath -ErrorAction Stop -WarningAction SilentlyContinue
        } | Should -Not -Throw
    }

    It "Has a valid root module" {
        $ManifestHash.RootModule | Should -Be "$ModuleName.psm1"
    }

    It "has a valid Description" {
        $ManifestHash.Description | Should -Not -BeNullOrEmpty
    }

    It "has a valid guid" {
        $ManifestHash.Guid | Should -Be "9a10b073-289a-4813-82a7-81ec95361a35"
    }

    It "has a valid copyright" {
        $ManifestHash.CopyRight | Should -Not -BeNullOrEmpty
    }

    It "exports all public functions" {
        $FunctionFiles = Get-ChildItem "$ModulePath/public" -Filter *.ps1 | Select-Object -ExpandProperty BaseName
        $ExportedFunctions = $ManifestHash.FunctionsToExport
        if ($FunctionFiles) {
            $ModulePath = (Get-Item -Path $ManifestPath).DirectoryName
            $FunctionNames = $FunctionFiles
            foreach ($Function in $FunctionNames) {
                $ExportedFunctions -contains $Function | Should -Be $true
            }
        }
        else {
            $ExportedFunctions | Should -BeNullOrEmpty
        }
    }

    It "Version number that matches Semantic Versioning Specification" {
        $VersionNumber = $ManifestHash.ModuleVersion
        $VersionNumber -match "^\d+.\d+.\d+$" | Should -Be $true
    }
}
