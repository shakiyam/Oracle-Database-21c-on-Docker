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

docker container start "$ORACLE_CONTAINER_NAME"

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
