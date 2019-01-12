param(
    [Parameter(Mandatory=$true)] $workingDirectory
)

$packageDirectory = "$workingDirectory/.."

npm i $packageDirectory -g # https://stackoverflow.com/questions/14469515/how-to-npm-install-to-a-specified-directory

$packageJson = get-content "$packageDirectory/package.json" -raw | ConvertFrom-Json

# pull in all of the source code.
$mapping = $packageJson.tsReferences
$containerDirectory = "ts_modules"

function Abs($path) {
    $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($path)
}

foreach($map in $mapping) {
    $fromSrc = Abs $map.from
    $toSrc = Abs ($containerDirectory + '/' + $map.to)
    remove-item $to -recurse -force -erroraction silentlycontinue

    copy-item -path $fromSrc -destination $toSrc -recurse
    copy-item -path 
}

# install any dependencies that may be present on the dependent project, but install them without including them as dependencies.