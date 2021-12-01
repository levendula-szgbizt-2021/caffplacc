#!/bin/sh -e

errcho() { echo "$@" >&2; exit 1; }

# check dependencies
for cmd in docker javac openssl; do
        command -v $cmd >/dev/null 2>&1 || errcho $cmd is required
done

# build & install native libraries
printf '>>>>>>>>>>>>>>>> Build & install libciff and libcaff? [y/n] '
read -r choice
case $choice in
[yY]*)
        command -v make >/dev/null 2>&1 || errcho make is required
        [ -n "$CC" ] || errcho please set CC
        [ -n "$PREFIX" ] || errcho please set PREFIX
        (cd ciff/ && make clean all && sudo make install-noman)
        (cd caff/ && make clean all && sudo make install-noman)
        ;;
esac

# build base docker image
echo '>>>>>>>> Building base docker image'
docker build -t caffplacc-base .

# build backend docker image
echo '>>>>>>>> Building backend docker image'
(cd caffplacc-backend/ \
    && ./mvnw -B clean install \
    && ./mvnw -B -pl caffplacc-backend-core jib:dockerBuild)

# generate self-signed certificates
printf '>>>>>>>>>>>>>>>> Generate self-signed certificates into ./cert/? [y/n] '
read -r choice
case $choice in
[yY]*)
        mkdir -p certs/
        openssl req -x509 -newkey rsa:4096 -nodes -sha256 -days 3650 \
            -keyout certs/nginx.key -out certs/nginx.crt
        ;;
esac
