npm i;
$process = Start-Process "$psscriptroot/../node_modules/.bin/jspm" -argumentlist 'install' -PassThru
$process.WaitForExit();