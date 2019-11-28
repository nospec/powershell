Add-Type -AssemblyName System.Windows.Forms

$Form = New-Object System.Windows.Forms.Form
$Form.Text = "Stephane"

$Label = New-Object System.Windows.Forms.Label
$Label.Text = "Hello World"

$Label.AutoSize = $true
$Form.Controls.Add($Label)


$Form.ShowDialog()