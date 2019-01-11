$refConfig = get-content "$psscriptroot/../tsreferences.json" -raw | ConvertFrom-Json

function Abs($path) {
    $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($path)
}

foreach($map in $refConfig.mapping) {
    $from = Abs $map.from
    $to = Abs ($refConfig.containerDirectory + '/' + $map.to)
    remove-item $to -recurse -force -erroraction silentlycontinue

    copy-item -path $from -destination $to -recurse
}