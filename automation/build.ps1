param(
    $BuildNumber = "--buildnumber--",
    $IncludeCompatBuild = $false,
    $ProductionMode = $false
)

function RunNodeBinary($commandName, $argList) {
    (start-process "$psscriptroot/../node_modules/.bin/$commandName" -ArgumentList $argList -PassThru).WaitForExit()
}

$builds = @( @{ friendlyName = "Default Build"; config = "tsconfig.json"; output = "dist/$buildNumber.js" } )

if($includeCompatBuild) {
    $builds = $builds += @{ friendlyName = "Compatibility Build"; config = "tsconfig-compat.json"; output = "dist/compat_$buildNumber.js" }
}

$buildStagingDirectory = "$psscriptroot/../dist_staging_directory"

foreach($build in $builds) {
    write-host "Building $($build.friendlyName)."

    mkdir $buildStagingDirectory | out-null

    write-host "`tCompiling TypeScript using $($build.config)."

    RunNodeBinary 'tsc' @('-p',$build.config,'--outDir',$buildStagingDirectory)

    write-host "`tBrowserifying"

    $browserifyArguments = @("$buildStagingDirectory/index.js", '-o', $build.output)

    if($productionMode) {
        RunNodeBinary 'browserify' $browserifyArguments

        write-host "`tMinifying"

        RunNodeBinary 'uglifyjs' @($build.output, '-c', '-o', $build.output, '-m')
    }
    else {
        RunNodeBinary 'browserify' ($browserifyArguments += '--debug')
    }

    remove-item $buildStagingDirectory -recurse -force
}