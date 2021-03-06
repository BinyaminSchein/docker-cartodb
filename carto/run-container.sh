#!/bin/bash

WORKING_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
VOLUME_BASE_CONFS="-v $WORKING_DIR/../base/opt:/home/opt/base"
VOLUME_CONFS="-v $WORKING_DIR/opt:/home/opt"
source $WORKING_DIR/../scripts/utils/general.sh
source $WORKING_DIR/../scripts/utils/docker.sh

usage()
{
cat << EOF
usage: $0 options

This script runs a new docker cartodb instance for you.

OPTIONS:
   -h      show this message
   -n      container name
   -c      network domain
   -d      carto domain
   -e      carto host machine
   -a      postgres address
   -b      postgres password
EOF
}

while getopts ":h:n:c:d:e:a:b:" OPTION
do
     case $OPTION in
         n)
             CONTAINER_NAME=${OPTARG}
             ;;
         c)
             NET_DOMAIN=${OPTARG}
             ;;
         d)
             DOMAIN=${OPTARG}
             ;;
         e)
             HOST=${OPTARG}
             ;;
         a)
             POSTGRES_ADDRESS=${OPTARG}
             ;;
         b)
             POSTGRES_PASSWORD=${OPTARG}
             ;;
         *)
             usage
             exit 1
             ;;
     esac
done

checkOption CONTAINER_NAME
checkOption DOMAIN
checkOption HOST
checkOption POSTGRES_ADDRESS
checkOption POSTGRES_PASSWORD

killContainer $CONTAINER_NAME true

CMD="sudo docker run --name="${CONTAINER_NAME}" \
                     ${VOLUME_BASE_CONFS} \
                     ${VOLUME_CONFS} \
                     --net=host \
                     --restart=always \
                     -e NET_DOMAIN=${NET_DOMAIN} \
                     -e CARTO_DOMAIN=${DOMAIN} \
                     -e CARTO_HOST=${HOST} \
                     -e POSTGRES_ADDRESS=${POSTGRES_ADDRESS} \
                     -e POSTGRES_PASSWORD=${POSTGRES_PASSWORD} \
	             -it \
	             carto:base /home/opt/start.sh"

echo "********************"
echo "       carto        "
echo "********************"

eval $CMD
