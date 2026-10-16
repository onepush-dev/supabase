#!/bin/bash
# Railway: pgsodium/vault root key from PGSODIUM_ROOT_KEY (per-deploy secret), else a key file on the data volume.
set -euo pipefail
if [[ -n "${PGSODIUM_ROOT_KEY:-}" ]]; then printf '%s' "$PGSODIUM_ROOT_KEY"; exit 0; fi
KEY_FILE=/var/lib/postgresql/data/pgsodium_root.key
if [[ ! -f "${KEY_FILE}" ]]; then head -c 32 /dev/urandom | od -A n -t x1 | tr -d ' \n' > "${KEY_FILE}"; fi
cat "$KEY_FILE"
