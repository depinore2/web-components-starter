get-childitem -path "$psscriptroot/../dist*" |
remove-item -recurse -force

(start-process "$psscriptroot/../node_modules/.bin/tsc" @('--build','--clean'))

remove-item "ts_modules" -recurse -force -erroraction silentlycontinue