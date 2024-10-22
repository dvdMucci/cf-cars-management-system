#!/bin/bash
# Colores para mensajes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

print_message() {
    local color=$1
    local message=$2
    echo -e "${color}${message}${NC}"
}
print_message $YELLOW "En 15 segundos este sctript clona el repositorio https://github.com/dvdMucci/cf-cars-management-system/\ny ejetuta lo neseario para dejar corriendo un contenedor de docker con una aplicacion web"
print_message $YELLOW 'Si desea cancelar precione las teclas "ctrl" y "c"'

countdown() {
    for (( i=15; i>=0; i-- ))
    do
        if [ $i -le 4 ]; then
            print_message "$RED" "Quedan $i segundos"
        elif [ $i -le 15 ] && [ $i -gt 4 ]; then
            print_message "$YELLOW" "Quedan $i segundos"
        fi
        sleep 1
    done
}
countdown

print_message $YELLOW "Se clona repositorio"
cd ~/
git clone https://github.com/dvdMucci/cf-cars-management-system/
cd cf-cars-management-system
print_message $YELLOW "Se ejecuta automatizacion de tareas"
sh automation.sh