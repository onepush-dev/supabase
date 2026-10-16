#!/bin/sh
# Derive API keys from JWT_SECRET when they are not set explicitly, then hand over to the image entrypoint.
set -e
eval "$(node /railway/mint-keys.js)"
: "${SUPABASE_ANON_KEY:=$ANON_KEY}"; : "${SUPABASE_SERVICE_KEY:=$SERVICE_ROLE_KEY}"; : "${SERVICE_KEY:=$SERVICE_ROLE_KEY}"
export SUPABASE_ANON_KEY SUPABASE_SERVICE_KEY SERVICE_KEY
exec docker-entrypoint.sh "$@"
