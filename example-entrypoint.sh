#!/bin/sh

set -e
LOCUST_MODE=${LOCUST_MODE:-standalone}
LOCUST_MASTER_BIND_PORT=${LOCUST_MASTER_BIND_PORT:-5557}
LOCUST_FILE=${LOCUST_FILE:-locustfile.py}

if [ -z ${LOADTEST_ENDPOINT+x} ] ; then
    echo "You need to set the URL of the host to be tested (LOADTEST_ENDPOINT)."
    exit 1
fi

LOCUST_OPTS="-f ${LOCUST_FILE} --host=${LOADTEST_ENDPOINT} -c ${NUMBER_OF_USERS} -r ${SPAWN_RATE} -t ${TOTAL_TIME} $LOCUST_OPTS"

case $(echo "${LOCUST_MODE}" | tr '[:lower:]' '[:upper:]') in
"MASTER")
    LOCUST_OPTS="--master --master-bind-port=${LOCUST_MASTER_BIND_PORT} $LOCUST_OPTS"
    ;;

"SLAVE")
    LOCUST_OPTS="--slave --master-host=${LOCUST_MASTER_HOST} --master-port=${LOCUST_MASTER_BIND_PORT} $LOCUST_OPTS"
    if [ -z ${LOCUST_MASTER_HOST+x} ] ; then
        echo "You need to set LOCUST_MASTER_HOST."
        exit 1
    fi
    ;;
esac

cd /locust
locust ${LOCUST_OPTS}

