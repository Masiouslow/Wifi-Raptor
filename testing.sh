#!/bin/bash

searchString="Homebema"

expect << EOF
    # Definición de la función dentro de expect
    proc filtrar_essid {} {
        set searchString "Homebema"
        set output [exec sh -c {cat Output_Networks.txt | grep -m 1 "$searchString" | tail -n 3 | cut -d ')' -f 1 | sed 's/^ //' | tr -d '[:space:]'}]
        return \$output
    }

    # Primer spawn
    spawn sudo /home/kali/tools/airgeddon/airgeddon.sh
    expect "Press \[Enter\] key to continue..."
    send -- "\r"
    expect "Press \[Enter\] key to continue..."
    send -- "\r"
    expect "Press \[Enter\] key to continue..."
    send -- "\r"
    expect "> "
    
    # Llamada a la función y envío de su salida
    send -- "[filtrar_essid]\r"

    expect eof
EOF
