param(
    [Parameter(Mandatory=$true)] $packageJsonPath
)

$packageJsonFolder = split-path $packageJsonPath

write-host "[getTsDependencies] Inspecting $packageJsonPath"

# get all dependencies and put them into a single array
$packageJson = get-content $packageJsonPath -raw | convertfrom-json

function IfGithubLeaveBlank($val) {
    if($val.Contains("github")) { "" }
    else { $val }
}

function ToKvpArray($dictionary) {
    $dictionary | get-member | where-object MemberType -eq NoteProperty | 
                select-object -expandproperty Name |
                select-object -Property @{ Name = "name"; Expression = { $_ } }, @{ Name = "Version"; Expression = { IfGithubLeaveBlank $dictionary."$_" } }
}

$thisPackageDeps = (ToKvpArray $packageJson.dependencies) + (ToKvpArray $packageJson.devDependencies)

if($null -eq $packageJson.tsReferences) {
    @{
        npmPackages = $thisPackageDeps;
        tsMappings = @()
    }
}
else {
    $recursiveResults = $packageJson.tsReferences | foreach-object { & "$psscriptroot/getTsDependencies " (resolve-path "$packageJsonFolder/$($_.packageJson)") }
}