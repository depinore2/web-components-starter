get-childitem -path "$psscriptroot/../dist*" |
remove-item -recurse -force

& "$psscriptroot/../node_modules/.bin/tsc" --build --clean

remove-item "ts_modules" -recurse -force -erroraction silentlycontinue