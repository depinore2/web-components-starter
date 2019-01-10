param(
    [Parameter(Mandatory=$true)]$buildNumber
)

get-childitem -recurse -path "$psscriptroot/.." |
where-object { ($_.name -like '*.json') -or ($_.name -like '*.ts') -or ($_.name -like '*.html')  } |
foreach-object { 
    write-host "Replacing buildNumber in $($_.fullname)."
    ((get-content -path $_.fullname -raw) -ireplace "--buildnumber--", $buildNumber) | set-content -path $_.fullname
}


& "$psscriptroot/install.ps1" 
& "$psscriptroot/build.ps1"