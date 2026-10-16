#!/bin/sh
# Railway wrapper around the upstream Supabase Envoy entrypoint:
#  - derives ANON_KEY / SERVICE_ROLE_KEY from JWT_SECRET when not set (zero deploy-time input)
#  - points clusters at Railway private domains
set -e
b64url() { openssl base64 -A | tr '+/' '-_' | tr -d '='; }
mint() {
  h=$(printf '%s' '{"alg":"HS256","typ":"JWT"}' | b64url)
  p=$(printf '{"role":"%s","iss":"supabase","iat":1760000000,"exp":2075000000}' "$1" | b64url)
  s=$(printf '%s' "$h.$p" | openssl dgst -sha256 -hmac "$JWT_SECRET" -binary | b64url)
  printf '%s.%s.%s' "$h" "$p" "$s"
}
if [ -n "$JWT_SECRET" ]; then
  [ -n "$ANON_KEY" ] || ANON_KEY=$(mint anon)
  [ -n "$SERVICE_ROLE_KEY" ] || SERVICE_ROLE_KEY=$(mint service_role)
fi
if [ -z "$ANON_KEY" ] || [ -z "$SERVICE_ROLE_KEY" ]; then echo "JWT_SECRET (or ANON_KEY + SERVICE_ROLE_KEY) is required" >&2; exit 1; fi
echo "Supabase URL:      ${SUPABASE_PUBLIC_URL}"
echo "anon key:          ${ANON_KEY}"
echo "service_role key:  (derived from JWT_SECRET; see Studio > Project Settings > API, or the README)"

PASSWORD_HASH=$(printf '%s' "${DASHBOARD_PASSWORD}" | openssl sha1 -binary | openssl base64)
DASHBOARD_BASIC_AUTH="${DASHBOARD_USERNAME}:{SHA}${PASSWORD_HASH}"

sed -e "s|\${ANON_KEY}|${ANON_KEY}|g" \
    -e "s|\${ANON_KEY_ASYMMETRIC}|${ANON_KEY_ASYMMETRIC}|g" \
    -e "s|\${SERVICE_ROLE_KEY}|${SERVICE_ROLE_KEY}|g" \
    -e "s|\${SERVICE_ROLE_KEY_ASYMMETRIC}|${SERVICE_ROLE_KEY_ASYMMETRIC}|g" \
    -e "s|\${SUPABASE_PUBLISHABLE_KEY}|${SUPABASE_PUBLISHABLE_KEY}|g" \
    -e "s|\${SUPABASE_SECRET_KEY}|${SUPABASE_SECRET_KEY}|g" \
    -e "s|\${SUPABASE_PUBLIC_URL}|${SUPABASE_PUBLIC_URL}|g" \
    -e "s|\${DASHBOARD_BASIC_AUTH}|${DASHBOARD_BASIC_AUTH}|g" \
    /etc/envoy/lds.template.yaml > /etc/envoy/lds.yaml

sed -e "s|\${AUTH_HOST}|${AUTH_HOST:-auth.railway.internal}|g" \
    -e "s|\${REST_HOST}|${REST_HOST:-rest.railway.internal}|g" \
    -e "s|\${REALTIME_HOST}|${REALTIME_HOST:-realtime.railway.internal}|g" \
    -e "s|\${STORAGE_HOST}|${STORAGE_HOST:-storage.railway.internal}|g" \
    -e "s|\${FUNCTIONS_HOST}|${FUNCTIONS_HOST:-functions.railway.internal}|g" \
    -e "s|\${META_HOST}|${META_HOST:-meta.railway.internal}|g" \
    -e "s|\${STUDIO_HOST}|${STUDIO_HOST:-studio.railway.internal}|g" \
    /etc/envoy/cds.template.yaml > /etc/envoy/cds.yaml

echo "Starting Envoy..."
exec envoy -c /etc/envoy/envoy.yaml "$@"
