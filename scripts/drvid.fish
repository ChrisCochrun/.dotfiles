#!/usr/bin/env fish

mkdir transcoded
for vid in *.mp4
    touch $vid.txt
    echo $vid >>$vid.txt
    set newvid (sed "s/\.mp4//g" $vid.txt)
    echo $newvid
    ffmpeg -i $vid -c:v dnxhd -profile:v 3 -qscale:v 9 -c:a pcm_s16le $newvid.mov
    mv $newvid.mov ./transcoded/$newvid.mov
    rm $vid.txt
    echo \n finished transcoding new file is in transcoded/$newvid.mov
end
