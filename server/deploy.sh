#!/bin/sh

./gradlew assemble

docker build -t gustiemenu .
docker save -o build/image.tar gustiemenu

scp build/image.tar ${GUSTIE_MENU_HOST}:/tmp/gustiemenu.tar
ssh ${GUSTIE_MENU_HOST} "docker load -i /tmp/gustiemenu.tar"
