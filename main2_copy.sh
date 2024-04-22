#!/bin/bash

# expect instalado ?
if ! command -v expect &> /dev/null; then
    echo "Instalando expect..."
    sudo apt-get install -y expect || sudo yum install -y expect || { echo "No se pudo instalar expect."; exit 1; }
fi

# Mostrar el menú
mostrar_menu() {
    whiptail --title "Menú" --menu "Selecciona una opción:" 15 40 3 \
    "1" "Opción 1" \
    "2" "Opción 2" \
    "3" "Salir" 3>&1 1>&2 2>&3
}

# Selección del usuario
manejar_opcion() {
    local opcion=$(mostrar_menu)
    case "$opcion" in
        1)
	   valor1=$(whiptail --title "Opción 1" --inputbox "Ingresa un valor para la Opción 1:" 10 30 3>&1 1>&2 2>&3)
           valor2=$(whiptail --title "Opción 1" --inputbox "Ingresa otro valor para la Opción 2:" 10 30 3>&1 1>&2 2>&3)
            ejecutar_airgeddon
            ;;
        2)
            valor=$(whiptail --title "Opción 2" --inputbox "Ingresa un valor para la Opción 2:" 10 30 3>&1 1>&2 2>&3)
            ejecutar_airgeddon
            ;;
        3)
            whiptail --title "Salir" --msgbox "Saliendo..." 10 30
            exit 0
            ;;
    esac
}

# Ejecutar airgeddon con expect
ejecutar_airgeddon() {
    sudo iwconfig wlan1 mode managed && sudo iwconfig wlan2 mode managed
    expect << EOF

	# Inicio
        spawn sudo /home/kali/tools/airgeddon/airgeddon.sh
        expect "Press \[Enter\] key to continue..."
        send -- "\r"
        expect "Press \[Enter\] key to continue..."
        send -- "\r"
        expect "Press \[Enter\] key to continue..."
        send -- "\r"

	# Escoger adaptador
	expect "> "
	send -- "3"
	send -- "\r"

	# Monitor mode
	expect "Select an option from menu:"
	send -- "2"
	send -- "\r" 
	expect "Press \[Enter\] key to continue..."
	send -- "\r"

	# Evil Twin Select
	expect "Select an option from menu:"
	send -- "7"
	send -- "\r"
	expect "Select an option from menu:"
	send -- "9"
	send -- "\r"
	expect "making it probably ineffective \[y/N\]"
	send -- "y"
	send -- "\r"
	expect "> "
	send -- "\r"

	# Escaneando  APS
	expect "Press \[Enter\] key to continue..."
	send -- "\r"
	sleep 15
	send -- "\003"
	expect "Select the order in which to display the list of targets:"
	send -- "7"
	send -- "\r"
	log_file "/home/kali/tools/airgeddon/autom/Output_Networks.txt"
	sleep 10
	expect "Select target network:"
	log_file
	expect "> "




	# Salir de la herramienta
#	send -- "\003"
#	send -- "y"
#	send -- "\r"
#	send -- "y"
#	send -- "\r"
	expect eof

EOF
}

# Ejecutar el menú y manejar la opción seleccionada
while true; do
    manejar_opcion
done
