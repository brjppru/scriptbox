#!/bin/bash
echo "copying from $1"

find $1 -type f -print0 | while read -d $'\0' -r file ; do
    echo Processing "$file"
    target="$2""$file"
    if (test -f "$target") then
        echo File Exists:  "$target"
    else
        echo copying to "$target"
        targetDir=`dirname "$target"`

        if (! [ -d "$targetDir" ]) then
            mkdir "$targetDir"
        fi

        ddrescue -e0 -r0 -v -n "$file" "$target"
        if ([ $? -ne 0 ]) then
            echo Copy failed, deleting "$target"
            rm -f "$target"
        fi
    fi
done