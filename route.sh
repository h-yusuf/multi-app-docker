#!/bin/bash

# Buat network jika belum ada
docker network inspect route >/dev/null 2>&1 || docker network create --driver bridge route

# Build image
docker build -t route:latest -f ./dockerfile/route.dockerfile .

# Stop & remove container jika ada
if docker ps -a --format '{{.Names}}' | grep -q "^route$"; then
  docker rm -f route
fi

# Jalankan container baru
docker run -dit \
    -v "$PWD"/log/route:/var/log/nginx:Z \
    -v "$PWD"/config/route:/etc/nginx/conf.d:Z \
    --restart=always \
    --network=route \
    --name route \
    -p 80:80 \
    route:latest \
    nginx -g 'daemon off;'
