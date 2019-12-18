# Dinoyan Ganeshalingam

Function install {
    param([int] $type, $filter_3)

    write-host "*Uninstall previous version*" -ForegroundColor Red
    $input = read-host "Uninstall ? [y][n]"

    if ($input -eq "y") {
        control panel
    }

    write-host "Installing"
    cd $filter_3
	cd
    switch ($type) {
	1 {write-host "VBS File"
           Start-process ./install.vbs -wait}
	2 {write-host "EXE File"
           Start-process -FilePath "setup.exe" -wait}	
    }

    write-host "DONE INSTALLING"
}

#$dir = Test-Path -Path C:\Users\$env:UserName\Desktop\dirList.txt
$dir = Test-Path .\dirList.txt

if ($dir -eq $true) {
    write-host("File exist")
} else {
    # TO-DO: map drive here
    #Get-ChildItem  \\sccmdpprod01\sources$\software -Recurse > C:\Users\$env:UserName\Desktop\good.txt
    Get-ChildItem \\sccmdpprod01\sources$\software -Recurse > .\good.txt
    get-content .\good.txt | Where-object  {$_.Contains("Directory:")} > dirList.txt
}

[string]$reg = Read-Host "Enter software name "

#$temp = Get-Content C:\Users\$env:UserName\Desktop\dirList.txt
$temp = Get-Content .\dirList.txt

Foreach ($line in $temp) {
    $filter_1 = $line | Where-Object {$_.Contains("Directory:")} | Where-Object {$_.Contains($reg)}
    $len = $filter_1.length
 
    if ($len -gt 1) {
	$filter_2 = $filter_1.Replace("Directory:", "")
	[string] $filter_3 = $filter_2.Trim()

	$foundFileT1 = Test-path -path $filter_3\install.vbs
	$foundFileT2 = Test-path -path $filter_3\setup.exe 

	if (($foundFileT1 -eq $true) -or ($foundFileT2 -eq $true)) {
	    write-host "FOUND IT" -ForegroundColor green

	    write-host $filter_3

	    $op = Read-host "Install? [y] [n]"

	    if ($op -eq "y") {
		     if ($foundFileT1 -eq $true) {
                 install 1 $filter_3
              } else {
                  install 2 $filter_3
              }

	    } else {
		write-host "Next..." -foregroundColor Cyan
            }
	}	
    }
}

write-host "Done Searching..." -ForegroundColor red