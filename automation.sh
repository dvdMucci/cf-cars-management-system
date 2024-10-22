#!/bin/bash

#modo depuracion descomentar el set -x
#set -x

# Colores para mensajes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

#variables
TEMP_DIR="tempdir"
DOCKER_IMAGE="cars-management-app"
CONTAINER_NAME="cars-management-container"
PORT=3000

print_message() {
    local color=$1
    local message=$2
    echo -e "${color}${message}${NC}"
}

check_tools(){
    if command -v $1 &>/dev/null; then 
        print_message $GREEN "$1 esta instalado."
    else 
        print_message $RED "$1 no esta instalado. Por favor, instale $1 e intente nuevamente."
        exit 1
    fi
}

check_tools docker

#Eliminar Dockers antiguos
print_message $YELLOW "Eliminando contenedores antiguos..."
docker rm -f $CONTAINER_NAME &>/dev/null || true
docker rmi -f $DOCKER_IMAGE &>/dev/null || true

#Crear la estructura de directorios
print_message $YELLOW "Creando estructura de directorios..."
mkdir -p $TEMP_DIR/{public,src}
cp -r src/* $TEMP_DIR/src/
cp -r public/* $TEMP_DIR/public/
cp package*.json server.js $TEMP_DIR/

#Crear Dockerfile
print_message $YELLOW "Creando estructura de directorios..."
cat <<EOF > $TEMP_DIR/Dockerfile
FROM node:18-alpine
LABEL org.opencontainers.image.authors="RoxsRoss"
RUN apk add --update python3 make g++ && rm -rf /var/cache/apk/*
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
EXPOSE $PORT
CMD ["npm", "start"]
EOF

#Crea docker image
print_message $YELLOW "Construyendo imagen Docker..."
docker build -t $DOCKER_IMAGE $TEMP_DIR

#Iniciar contenedor
print_message $YELLOW "Listando contenedores..."
docker run -d -p $PORT:$PORT --name $CONTAINER_NAME $DOCKER_IMAGE

#Le doy tiempo al contenedor  
print_message $YELLOW "Espero unos segundos a que arranque el contenedor"
sleep 3

#Ver logs
print_message $YELLOW "Mostrando logs del contenedor..."
docker logs $CONTAINER_NAME

#mostrar ip
print_message $YELLOW "Obteniendo direccion IP del host..."
HOST_IP=$(hostname -I | awk '{print $1}')
print_message $GREEN "Direccion IP del host: $HOST_IP"
print_message $YELLOW "Obteniendo direccion IP del contenedor..."
CONTAINER_IP=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $CONTAINER_NAME)
print_message $GREEN "Direccion IP del contenedor: $CONTAINER_IP"
print_message $GREEN "Chequear web en http://$HOST_IP:$PORT"

#Cheque servicio activo
print_message $YELLOW "Probando contenedor..."
if nc -vz -w1 $HOST_IP $PORT 2>/dev/null; then
    print_message $GREEN "La web está en linea"
else
    print_message $RED "La web no funciona"
fi

### limpieza del directorio temporal
print_message $GREEN "Limpiando directorio temporal..."
rm -rf $TEMP_DIR

set +x
