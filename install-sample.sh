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

# health check
status="$(docker inspect -f '{{.State.Status}}' "$ORACLE_CONTAINER_NAME")"
if [[ $status != "running" ]]; then
  echo -e "\n\033[36mContainer $ORACLE_CONTAINER_NAME is $status\033[0m"
  exit 1
fi
health="$(docker inspect -f '{{.State.Health.Status}}' "$ORACLE_CONTAINER_NAME")"
if [[ $health != "healthy" ]]; then
  echo -e "\n\033[36mContainer $ORACLE_CONTAINER_NAME is $health\033[0m"
  exit 1
fi

docker container exec -i "$ORACLE_CONTAINER_NAME" bash <<EOT
curl -sSL https://github.com/oracle/db-sample-schemas/archive/refs/tags/v21.1.tar.gz | tar xzf -
cd db-sample-schemas-21.1
/opt/oracle/product/21c/dbhome_1/perl/bin/perl -p -i.bak -e 's#__SUB__CWD__#'/home/oracle/db-sample-schemas-21.1'#g' ./*.sql ./*/*.sql ./*/*.dat
echo "@mksample $ORACLE_PWD $ORACLE_PWD $ORACLE_PWD $ORACLE_PWD $ORACLE_PWD $ORACLE_PWD $ORACLE_PWD $ORACLE_PWD users temp /home/oracle/log/ $ORACLE_PDB" \
  | sqlplus system/"$ORACLE_PWD"@"$ORACLE_PDB"
EOT
