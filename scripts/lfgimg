#!/usr/bin/env fish

for i in [1-10]
    set url (curl https://www.lfg.co/page/$i |
    rg '<img src="https://www.lfg.co' |
    sed 's/\s*<.*="\(.*\)".*/\1/' )
    echo $url\n >images.txt
    curl -o $i.gif $url
end
#wget -O $i
