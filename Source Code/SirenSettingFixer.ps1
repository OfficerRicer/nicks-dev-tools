
function Get-FileName
{

    [CmdletBinding()]
    [OutputType([string])]
    Param
    (
        # WindowsTitle help description
        [Parameter(
            Mandatory = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = "Message Box Title",
            Position = 0)]
        [String]$WindowTitle,

        # InitialDirectory help description
        [Parameter(
            Mandatory = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = "Initial Directory for browsing",
            Position = 1)]
        [String]$InitialDirectory,

        # Filter help description
        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = "Filter to apply",
            Position = 2)]
        [String]$Filter = "All files (*.*)|*.*",

        # AllowMultiSelect help description
        [Parameter(
            Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = "Allow multi files selection",
            Position = 3)]
        [Switch]$AllowMultiSelect
    )

    # Load Assembly
    Add-Type -AssemblyName System.Windows.Forms

    # Open Class
    $OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog

    # Define Title
    $OpenFileDialog.Title = $WindowTitle

    # Define Initial Directory
    if (-Not [String]::IsNullOrWhiteSpace($InitialDirectory))
    {
        $OpenFileDialog.InitialDirectory = $InitialDirectory
    }

    # Define Filter
    $OpenFileDialog.Filter = $Filter

    # Check If Multi-select if used
    if ($AllowMultiSelect)
    {
        $OpenFileDialog.MultiSelect = $true
    }
    $OpenFileDialog.ShowHelp = $true    # Without this line the ShowDialog() function may hang depending on system configuration and running from console vs. ISE.
    $OpenFileDialog.ShowDialog() | Out-Null
    if ($AllowMultiSelect)
    {
        return $OpenFileDialog.FileNames
    }
    else
    {
        return $OpenFileDialog.Filename
    }
}
function Randomize()
{
foreach($select in $filename)
{
    #$file = $select
    $global:counter=0
    $xml = [xml](get-content -LiteralPath $select) 
    foreach($item in $xml.CVehicleModelInfoVariation.variationData.Item.sirenSettings){
        $item.value = $random
    }
    foreach($item in $xml.CVehicleModelInfoVarGlobal.Sirens.Item.id){
        $item.value = $random
    }
    $xml.Save($select)
    Write-Host $xml.CVehicleModelInfoVariation.variationData.Item.sirenSettings
    }
}
#  ============== Form to display GUI =======================================
 Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()
Add-Type -Assembly System.Drawing 
$Form = New-Object system.Windows.Forms.Form
                         
[int32]$height = 80
[int32]$width = 300
$Form.ClientSize                 = "$width,$height"
$Form.text                       = "SirenSetting Fixer (Patched by NickR#8733)"
$Form.TopMost                    = $true

$button = New-Object system.Windows.Forms.Button
$button.width                   = 100	
$button.height                  = 50
$button.text					= "Select Files"
$button.location                = New-Object System.Drawing.Point(30,10)
$button.Font                    = 'Roman,12'
$button.Add_Click({
$global:filename = Get-FileName -WindowTitle "Select File" -InitialDirectory "C:\" -Filter "Meta files (*.meta)|*.meta| XML files (*.xml)|*.xml" -AllowMultiSelect
})
$button2 = New-Object system.Windows.Forms.Button
$button2.width                  = 100	
$button2.height                 = 50
$button2.text					= "Randomize Siren"
$button2.location               = New-Object System.Drawing.Point(175,10)
$button2.Font                   = 'Roman,12'
$button2.Add_Click({
$global:random = (Get-Random -Minimum 0 -Maximum 255 ).ToString('###')
Randomize
})
$Form.controls.Add($button)
$Form.controls.Add($button2)
#Start form 
[void]$Form.ShowDialog()