<#
-> Finding the location of input files AllowedExtensionsOnDesktop.txt, DestinationPathOfFiles.txt on this PC
-> Reading the content of input files AllowedExtensionsOnDesktop.txt, DestinationPathOfFiles.txt
#>
$scriptLocationOnThisPC = split-path -parent $MyInvocation.MyCommand.Definition
$configFilesLocationOnThisPC = "$scriptLocationOnThisPC\Config files"
$allowedExtensionsOnDesktopFilePath = "$configFilesLocationOnThisPC\AllowedExtensionsOnDesktop.txt"
$destinationPathOfFilesFilePath = "$configFilesLocationOnThisPC\DestinationPathOfFiles.txt"

$listOfAllowedExtensionsOnDesktop = Get-Content -Path $allowedExtensionsOnDesktopFilePath
$destinationPathOfFiles = Get-Content -Path $destinationPathOfFilesFilePath



<#
-> Finding the location of Desktop on this PC
-> Finding the files from Desktop
#>
$DesktopPath = [Environment]::GetFolderPath("Desktop")
$DesktopFiles = Get-ChildItem -Path $DesktopPath 
$DesktopPath = [Environment]::GetFolderPath("Desktop")



<#
-> Finding the location of input files with the prefix "Path"
-> Reading the content of input files with the prefix "Path"
-> Moving from Desktop the files related to input files with the prefix "Path"
#>
$additionalFiles = Get-ChildItem -Path $configFilesLocationOnThisPC | Where-Object Name -like 'Path_*'

foreach ($f in $additionalFiles) {
    [System.Collections.ArrayList] $contentOfAdditionalFile = Get-Content -Path $f.PSPath
    if($contentOfAdditionalFile -ne "") {
        $destinationPathOfThisFile = $contentOfAdditionalFile[0]
        $contentOfAdditionalFile.Remove($destinationPathOfThisFile)
        $DesktopFiles | ForEach-Object {
            if( ((-not (Test-Path -Path $_.PSPath  -PathType Container)) -and ($contentOfAdditionalFile -contains $_.Extension)) -or 
            ((Test-Path -Path $_.PSPath  -PathType Container) -and ($contentOfAdditionalFile -contains ".dir"))) {
                $num=1
                $nextName = Join-Path -Path $destinationPathOfThisFile -ChildPath $_.name
                while(Test-Path -Path $nextName)
                {
                    $nextName = Join-Path $destinationPathOfThisFile ($_.BaseName + " ($num)" + $_.Extension)    
                    $num+=1   
                }
                Move-Item -LiteralPath $_.PSPath -Destination $nextName
            }    
        }
    }
}



<#
-> Moving the rest of files from Desktop to the path defined in "DestinationPathOfFiles.txt"
#>
$DesktopFiles | ForEach-Object {
    if  (((Test-Path -Path $_.PSPath  -PathType Container) -and ($listOfAllowedExtensionsOnDesktop -notcontains ".dir")) -or 
    ((-not (Test-Path -Path $_.PSPath  -PathType Container)) -and ($listOfAllowedExtensionsOnDesktop -notcontains $_.Extension))){
            $num=1
            $nextName = Join-Path -Path $destinationPathOfFiles -ChildPath $_.name
            while(Test-Path -Path $nextName)
            {
                $nextName = Join-Path $destinationPathOfFiles ($_.BaseName + " ($num)" + $_.Extension)    
                $num+=1   
            }
            Move-Item -LiteralPath $_.PSPath -Destination $nextName -Force
    }  
}
