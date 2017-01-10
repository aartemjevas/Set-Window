$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

Describe "Unit Tests" {
    Context "Parameter validation" {
        $func = Get-Command -Name Set-Window

        It 'MainWindowHandle parameter is mandatory' {
            $func.Parameters.MainWindowHandle.Attributes.Mandatory | should be $true    
        }
        It "MainWindowHandle parameter accepts ValueFromPipeline" {
            $func.Parameters.MainWindowHandle.Attributes.ValueFromPipeline | should be $true
        }
        It "MainWindowHandle parameter accepts ValueFromPipelineByPropertyName" {
            $func.Parameters.MainWindowHandle.Attributes.ValueFromPipelineByPropertyName | should be $true
        }
        It "Position parameter has predefined values" {
            $func.Parameters.Position.Attributes.ValidValues | Should Not BeNullOrEmpty
        }
        It "Returns a System.Automation.WindowInfo" {
           $func.OutputType.Name -eq 'System.Automation.WindowInfo' | should be $true
        }

    }
}