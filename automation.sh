#!/bin/bash

#variables
TEMP_DIR="tempdir"
DOCKER_IMAGE="cars-management-app"
CONTAINER_NAME="cars-management-container"
PORT=3000

#Eliminar Dockers antiguos
docker rm -f $CONTAINER_NAME
docker rmi -f $DOCKER_IMAGE


#Crear la estructura de directorios
echo "Crea carpetas del proyecto"
mkdir -p $TEMP_DIR/{public,src}
cp -r src/* $TEMP_DIR/src/
cp -r public/* $TEMP_DIR/public/
cp package*.json server.js $TEMP_DIR/

#Crear Dockerfile
echo "Crea el Dockerfile"
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
echo "Crea la imagen de Docker"
docker build -t $DOCKER_IMAGE $TEMP_DIR

#Iniciar contenedor
echo "Inicia el contenedor"
docker run -d -p $PORT:$PORT --name $CONTAINER_NAME $DOCKER_IMAGE

#Le doy tiempo al contenedor  
echo "Espero unos segundos a que arranque el contenedor"
sleep 3

#Ver logs
echo "Mostrar logs"
docker logs $CONTAINER_NAME


#mostrar ip
echo "Mostrar ip"
CONTAINER_IP=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $CONTAINER_NAME)
echo "IP del contenedor $CONTAINER_IP"
HOST_IP=$(hostname -I | awk '{print $1}')
echo "IP del host $HOST_IP"
echo "Chequear web en http://$HOST_IP:$PORT"

#Cheque servicio activo
echo "Servicio activo?"
curl http://$HOST_IP:$PORT
