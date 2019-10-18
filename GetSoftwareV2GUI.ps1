# Dinoyan Ganeshalingam

Add-type -assembly System.Windows.Forms

$main_form = New-Object system.windows.Forms.form
$main_form.Text = "Find Software"
$main_form.Width = 400
$main_form.height = 200
$main_form.MaximizeBox = $false
$main_form.FormBorderStyle = 'Fixed3D'

$Tb = New-Object system.Windows.Forms.Textbox
$Tb.Location = New-Object System.Drawing.point(55, 1)
$Tb.Size = New-Object System.Drawing.Size(100,100)

$name = New-Object System.Windows.Forms.Label
$name.Text = "Software: "
$name.Location  = New-Object System.Drawing.Point(0,3)
$name.AutoSize = $true

$Find = New-Object System.Windows.Forms.Button
$Find.Location = New-Object System.Drawing.Size(150,1)
$Find.Size = New-Object System.Drawing.Size(60,20)
$Find.Text = "Search"

$Install = New-Object System.Windows.Forms.Button
$Install.Location = New-Object System.Drawing.Size(250,120)
$Install.Size = New-Object System.Drawing.Size(120,23)
$Install.Text = "Install"

$QueueApps = New-Object System.Windows.Forms.Button
$QueueApps.Location = New-Object System.Drawing.Size(50,120)
$QueueApps.Size = New-Object System.Drawing.Size(120,23)
$QueueApps.Text = "Queue"

$loc = New-Object System.Windows.Forms.Label
$loc.Text = "Locations"
$loc.Location  = New-Object System.Drawing.Point(10,35)
$loc.AutoSize = $true

$listBox = New-Object System.Windows.Forms.ListBox
$listBox.Location = New-Object System.Drawing.Point(10,50)
$listBox.Size = New-Object System.Drawing.Size(360,20)
$listBox.Height = 80

$main_form.Controls.Add($listBox)
$main_form.Controls.Add($Install)
$main_form.Controls.Add($Find)
$main_form.controls.add($tb)
$main_form.Controls.Add($name)
$main_form.Controls.Add($loc)
$main_form.Controls.add($QueueApps)

$global:queue = New-Object System.Collections.Queue

Function install {
    param([int] $type, $filter_3)

    #cd $filter_3
    switch ($type) {
	1 {Start-process $filter_3/install.vbs -wait}
	2 {Start-process -FilePath "$filter_3/setup.exe" -wait}	
    }
}

$Find.Add_Click( 
{
    $listBox.Items.Clear()
    $searchItem = $Tb.Text

    $temp = Get-Content C:\Users\$env:UserName\Desktop\main.txt
  
    Foreach ($line in $temp) {
        $filter_1 = $line | Where-Object {$_.Contains("Directory:")} | Where-Object {$_.Contains($searchItem)}
        $len = $filter_1.length

        if ($len -gt 1) {
	    $filter_2 = $filter_1.Replace("Directory:", "")
	    [string] $filter_3 = $filter_2.Trim()

	    $foundFileT1 = Test-path -path $filter_3\install.vbs
	    $foundFileT2 = Test-path -path $filter_3\setup.exe   

	    if (($foundFileT1 -eq $true) -or ($foundFileT2 -eq $true)) {
	       [void] $listBox.Items.Add($filter_3)
	    }
        }
    }

    $QueueApps.Add_Click({
        $global:queue.Enqueue($listBox.SelectedItem)
        write-host $global:queue.count
        write-host $global:queue
    })

    $Install.Add_Click({
        install 1 $listBox.SelectedItem
    })
 
}
)

$main_form.showDialog()