FROM node:18-alpine
LABEL org.opencontainers.image.authors="RoxsRoss"
RUN apk add --update python3 make g++ && rm -rf /var/cache/apk/*
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
EXPOSE 3000
CMD ["npm", "start"]
