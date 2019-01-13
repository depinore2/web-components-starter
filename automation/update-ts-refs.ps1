param(
    [Parameter(Mandatory=$true)] $workingDirectory,
    [switch] $skipNpm
)

if(!$skipNpm) {
    npm i # first thing's first: install all local modules.
}

$updateRefsOutput = node "$psscriptroot/update-ts-refs.js" $workingDirectory | convertfrom-json

if(!$skipNpm) {
    # run all NPM commands
    foreach($cmd in $updateRefsOutput.npmInstallationCommands) {
        & ([Scriptblock]::Create($cmd))
    }
}

# make a copy of all tsReference mappings
foreach($map in $updateRefsOutput.tsReferences) {
    remove-item $map.to -recurse -force -erroraction silentlycontinue
    copy-item -path $map.from -destination $map.to -recurse
}