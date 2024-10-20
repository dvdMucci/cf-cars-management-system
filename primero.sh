#!/bin/bash
echo "En 10 segundos este sctript clona el repositorio https://github.com/dvdMucci/cf-cars-management-system/"
echo "y ejetuta lo neseario para dejar corriendo un contenedor de docker con una aplicacion web"
echo 'Si desea cancelar precione las teclas "ctrl" y "c"'
sleep 10 
cd ~/
git clone https://github.com/dvdMucci/cf-cars-management-system/
cd cf-cars-management-system
sh automation.sh