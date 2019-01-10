get-childitem -path "$psscriptroot/../tsconfig*" |
foreach-object { 
    $process = start-process -filepath "$psscriptroot/../node_modules/.bin/tsc" -ArgumentList '-p', $_.fullname -PassThru;
    $process.WaitForExit();
}
