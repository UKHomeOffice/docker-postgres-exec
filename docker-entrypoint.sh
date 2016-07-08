#!/usr/bin/env bash

set -e

# Config
POSTGRES_PORT="${POSTGRES_PORT:-5432}"

POSTGRES_USER_SECRET=${POSTGRES_USER_SECRET:-/etc/postgres/user}
POSTGRES_PASSWORD_SECRET=${POSTGRES_PASSWORD_SECRET:-/etc/postgres/password}
POSTGRES_DB_SECRET=${POSTGRES_DB_SECRET:-/etc/postgres/db}

# Sanity check input
if [ -z ${POSTGRES_HOST+x} ]; then
  echo "Error: POSTGRES_HOST undefined"
  exit 1
elif [[ -z ${POSTGRES_PASSWORD+x} && ! -f ${POSTGRES_PASSWORD_SECRET} ]]; then
  echo "Error: POSTGRES_PASSWORD undefined and secret not mounted at ${POSTGRES_PASSWORD_SECRET}"
  exit 2
fi

# Convert secrets to bash vars
function read_secret {
  file=$1
  default=$2

  if [ -f ${file} ]; then
    cat "${file}"
  else
    echo "${default}"
  fi
}

POSTGRES_USER=${POSTGRES_USER:-`read_secret "${POSTGRES_USER_SECRET}" "root"`}
POSTGRES_PASSWORD=${POSTGRES_PASSWORD:-`cat "${POSTGRES_PASSWORD_SECRET}"`}
POSTGRES_DB=${POSTGRES_DB:-`read_secret "${POSTGRES_DB_SECRET}" "${POSTGRES_USER}"`}

# Set up psql command
export PGPASSWORD="${POSTGRES_PASSWORD}"
psql=( psql \
  -v ON_ERROR_STOP=1 \
  --host="${POSTGRES_HOST}" \
  --port="${POSTGRES_PORT}" \
  --username="$POSTGRES_USER" \
  --dbname="$POSTGRES_DB" )

# Execute all the things
for f in /docker-entrypoint-initdb.d/*; do
	case "$f" in
		*.sh)     echo "$0: running $f"; . "$f" ;;
		*.sql)    echo "$0: running $f"; "${psql[@]}" < "$f"; echo ;;
		*.sql.gz) echo "$0: running $f"; gunzip -c "$f" | "${psql[@]}"; echo ;;
		*)        echo "$0: ignoring $f" ;;
	esac
	echo
done
