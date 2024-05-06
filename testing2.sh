#!/bin/bash

searchString="Homebema"

expect << EOF
    # Definición de la función dentro de expect
    proc filtrar_essid {} {
        global searchString
        set output [exec sh -c {cat Output_Networks.txt | grep -m 1 "$searchString" | tail -n 3 | cut -d ')' -f 1 | sed 's/^ //' | tr -d '[:space:]' | sed 's/\x1B\[[0-9;]*[a-zA-Z]//g'}]
        return \$output
    }
    spawn sudo /home/kali/tools/airgeddon/airgeddon.sh
    send -- "[filtrar_essid]\r"

    expect eof

    # Almacenar el valor de output en un archivo
    set outputFile "output.txt"
    set fd [open \$outputFile "w"]
    puts \$fd \$output
    close \$fd
EOF
