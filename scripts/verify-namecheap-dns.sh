#!/usr/bin/env bash
# Check that a Namecheap domain's DNS points at Firebase Hosting for
# project colette-memorial (https://colette-memorial.web.app).
set -euo pipefail

DOMAIN="${1:-}"
if [[ -z "$DOMAIN" ]]; then
  echo "Usage: $0 yourdomain.com" >&2
  exit 1
fi

FIREBASE_A="199.36.158.100"
HOSTING="https://colette-memorial.web.app"

echo "Firebase Hosting: $HOSTING"
echo "Expected A record: $FIREBASE_A"
echo

check_host() {
  local host="$1"
  echo "== $host =="
  local records
  records="$(dig +short "$host" A | sed '/^$/d' || true)"
  if [[ -z "$records" ]]; then
    echo "No A records yet (DNS not propagated, or still on Namecheap parking/URL Redirect)."
    return 1
  fi
  echo "$records"
  if echo "$records" | grep -qx "$FIREBASE_A"; then
    echo "OK: points at Firebase Hosting."
    return 0
  fi
  echo "NOT pointing at Firebase. Remove Namecheap URL Redirect / parking CNAMEs and set A → $FIREBASE_A."
  return 1
}

apex_ok=0
www_ok=0
check_host "$DOMAIN" && apex_ok=1 || true
check_host "www.$DOMAIN" && www_ok=1 || true

echo
echo "== HTTPS =="
for url in "https://$DOMAIN" "https://www.$DOMAIN" "$HOSTING"; do
  code="$(curl -sI -o /dev/null -w '%{http_code} cert:%{ssl_verify_result}' -m 15 "$url" || echo 'failed')"
  echo "$url → $code"
done

if [[ "$apex_ok" -eq 1 && "$www_ok" -eq 1 ]]; then
  echo
  echo "DNS looks good. If Firebase still says Needs setup, wait for TXT/SSL (up to 24h),"
  echo "then add $DOMAIN to Authentication → Settings → Authorized domains."
  exit 0
fi
exit 1
