#!/bin/bash
set -eu -o pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
readonly SCRIPT_DIR

# load environment variables from .env
if [ -e "$SCRIPT_DIR"/.env ]; then
  # shellcheck disable=SC1091
  . "$SCRIPT_DIR"/.env
else
  echo 'Environment file .env not found. Therefore, dotenv.sample will be used.'
  # shellcheck disable=SC1091
  . "$SCRIPT_DIR"/dotenv.sample
fi

echo 'Starting an Oracle Database Server Instance.'
docker container run \
  -d \
  --name "$ORACLE_CONTAINER_NAME" \
  -p "$ORACLE_LISTENER_PORT":1521 \
  -p "$OEM_EXPRESS_PORT":5500 \
  -e ORACLE_SID="$ORACLE_SID" \
  -e ORACLE_PDB="$ORACLE_PDB" \
  -e ORACLE_PWD="$ORACLE_PWD" \
  -e ORACLE_EDITION="$ORACLE_EDITION" \
  -e ORACLE_CHARACTERSET="$ORACLE_CHARACTERSET" \
  -e ENABLE_ARCHIVELOG="$ENABLE_ARCHIVELOG" \
  container-registry.oracle.com/database/enterprise:21.3.0.0

echo -n "Waiting for $ORACLE_CONTAINER_NAME to get healthy ..."
while true; do
  status="$(docker inspect -f '{{.State.Status}}' "$ORACLE_CONTAINER_NAME")"
  if [[ $status != "running" ]]; then
    echo -e "\n\033[36mContainer $ORACLE_CONTAINER_NAME is $status\033[0m"
    exit 1
  fi
  if [[ "$(docker inspect -f '{{.State.Health.Status}}' "$ORACLE_CONTAINER_NAME")" == "healthy" ]]; then
    break
  fi
  sleep 1
  echo -n .
done
echo -e " \033[32mdone\033[0m"
