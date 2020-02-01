param(
    [Parameter(Mandatory=$true)] $workingDirectory,
    [switch] $skipNpm,
    [string] $additionalNpmArguments = ''
)

#clean out all current ts_modules
Write-Host "Cleaning out all ts_modules in $psscriptroot/../";

get-childitem 'ts_modules' -path "$psscriptroot/../../"|
remove-item -recurse -force

$beginningLocation = Get-Location
set-location $workingDirectory

if(!$skipNpm) {
    write-host "Installing own npm dependencies in $(get-location)"
    & "npm" -argumentlist @('i', $additionalNpmArguments) # first thing's first: install all local modules.
}

$updateRefsOutput = node "$psscriptroot/update-ts-refs.js" $workingDirectory | convertfrom-json

if(!$skipNpm) {
    # run all NPM commands
    foreach($cmd in $updateRefsOutput.npmInstallationCommands) {
        $cmd = "$cmd $additionalNpmArguments"
        write-host "Command: $cmd`nCWD: $(get-location)"
        & ([Scriptblock]::Create($cmd))
    }
}

# make a copy of all tsReference mappings
foreach($map in $updateRefsOutput.tsReferences) {
    remove-item $map.to -recurse -force -erroraction silentlycontinue
    copy-item -path $map.from -destination $map.to -recurse
}

set-location $beginningLocation

# update all references to ts_modules to be one level deeper, to accomodate nested ts_modules references.
get-childitem '*.ts' -path ts_modules -recurse |
foreach-object { (get-content $_ -raw) -replace '../../ts_modules','../../../ts_modules' | out-file -filepath $_ -encoding 'UTF8' }
