param(
    [Parameter(Mandatory=$true)] $originalPackageJsonPath
)

$deps = node "$psscriptroot/get-ts-deps.js" $originalPackageJsonPath | out-string | convertfrom-json

write-host "Got these tsReferences from node:"
$deps.tsReferences