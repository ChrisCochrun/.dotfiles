#!/usr/bin/fish

set arg (getopt -s sh : $argv)
set arg (fish -c "for el in $arg; echo \$el; end")

echo "arguments are: " $arg

for val in $arg
           if test $val = "--"
              echo "value in arg is: " $val
           else
              echo "value in arg is: " $val
              mpv -(youtube-dl (curl $arg | rg embed | sed 's/.*embed\(.*\)">.*/\1/' | cut -d '"' -f1 | awk -v prefix="https://cdn.lbryplayer.xyz/api/v2/streams/free" '{print prefix $0}'))
           end
end
