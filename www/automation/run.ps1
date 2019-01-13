# build and browserify it fully once, before beginning watch mode.
# & "$psscriptroot/build.ps1"

#do it again, but in watch mode now.
$tscCmd = "`'$(resolve-path "$psscriptroot/../node_modules/.bin/tsc") -p $(resolve-path $psscriptroot/../tsconfig.json) --watch`'"
$browserifyCmd = "`"pwsh $(resolve-path "$psscriptroot/browserify.ps1") -watchMode`""
$httpCmd = "`'http-server -s -o -c-1`'"

$wholeCommand = "$(resolve-path $psscriptroot/../node_modules/.bin/concurrently) $tscCmd $browserifyCmd $httpCmd"

write-host $wholeCommand

& ([Scriptblock]::Create($wholeCommand))

# start-process "$psscriptroot/../node_modules/.bin/tsc" -argumentlist @("--build","$psscriptroot/../tsconfig.json","--watch")
# start-sleep -seconds 1
# start-process "pwsh" -ArgumentList @("$psscriptroot/browserify.ps1", '-watchMode')

# start-process "$psscriptroot/../node_modules/.bin/http-server" # serve it up on an HTTP server
# start-process "http://localhost:8080/" # open system browser