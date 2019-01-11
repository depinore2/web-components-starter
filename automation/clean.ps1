get-childitem -path "$psscriptroot/../dist*" |
remove-item -recurse -force

(start-process "$psscriptroot/../node_modules/.bin/tsc" @('--build','--clean'))

$tsConfig = get-content "$psscriptroot/../tsreferences.json" -raw | convertfrom-json

remove-item $tsConfig.containerDirectory -recurse -force -erroraction silentlycontinue