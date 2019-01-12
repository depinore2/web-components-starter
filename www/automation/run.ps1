# build and browserify it fully once, before beginning watch mode.
(start-process "pwsh" -argumentlist @("$psscriptroot/build.ps1") -PassThru).WaitForExit()

#do it again, but in watch mode now.
start-process "$psscriptroot/../node_modules/.bin/tsc" -argumentlist @("--build","$psscriptroot/../tsconfig.json","--watch")
start-sleep -seconds 1
start-process "pwsh" -ArgumentList @("$psscriptroot/browserify.ps1", '-watchMode')

start-process "$psscriptroot/../node_modules/.bin/http-server" # serve it up on an HTTP server
start-process "http://localhost:8080/" # open system browser