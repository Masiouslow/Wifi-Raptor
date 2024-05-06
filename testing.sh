#!/bin/bash

searchString="Livebox6-00F7"

expect << EOF
    # Definición de la función dentro de expect
    proc filtrar_essid {} {
        set searchString " Livebox6-00F7"
        set output [exec sh -c {cat Output_Networks.txt | grep -m 1 "$searchString" | tail -n 3 | cut -d ')' -f 1 | sed 's/^ //' | tr -d '[:space:]'| sed 's/\x1B\[[0-9;]*[a-zA-Z]//g'}]
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
