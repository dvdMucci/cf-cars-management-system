#!/bin/bash

# Colores para mensajes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

print_message() {
    local flag=$1
    local color=$2
    local message=$3
    echo $flag "${color}${message}${NC}"
}
print_message -e $YELLOW "En 15 segundos este sctript clona el repositorio https://github.com/dvdMucci/cf-cars-management-system/\ny ejetuta lo neseario para dejar corriendo un contenedor de docker con una aplicacion web"
print_message -e $YELLOW 'Si desea cancelar precione las teclas "ctrl" y "c"'

countdown() {
    for (( i=15; i>=0; i-- ))
    do
        if [ $i -le 4 ]; then
            print_message -ne "$RED" "                         \r"
            print_message -ne "$RED" "Quedan $i segundos\r"            
        elif [ $i -le 15 ] && [ $i -gt 4 ]; then
            print_message -ne "$RED" "                         \r"
            print_message -ne "$YELLOW" "Quedan $i segundos\r"
        fi
        sleep 1
    done
    print_message -e "$RED" ""
}
countdown

print_message -e $YELLOW "Se clona repositorio"
cd ~/
git clone https://github.com/dvdMucci/cf-cars-management-system/
cd cf-cars-management-system
print_message -e $YELLOW "Se ejecuta automatizacion de tareas"
bash automation.sh