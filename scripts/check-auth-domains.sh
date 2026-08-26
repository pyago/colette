#!/usr/bin/env bash
# Confirms Firebase Auth authorized domains include the Namecheap hosts.
set -euo pipefail

API_KEY="${FIREBASE_WEB_API_KEY:-AIzaSyCfrCgihdjYH4mmbdvxL6XpabgZUDo6jpA}"
NEED=(
  "colletemariefoundation.com"
  "www.colletemariefoundation.com"
)

json="$(curl -fsS "https://www.googleapis.com/identitytoolkit/v3/relyingparty/getProjectConfig?key=${API_KEY}")"
echo "$json" | python3 -c '
import json, sys
cfg = json.load(sys.stdin)
domains = cfg.get("authorizedDomains") or []
print("Authorized domains:")
for d in domains:
    print(f"  - {d}")
missing = [d for d in sys.argv[1:] if d not in domains]
if missing:
    print("")
    print("Missing (Google sign-in from the custom domain will fail):")
    for d in missing:
        print(f"  - {d}")
    print("Add them at:")
    print("  https://console.firebase.google.com/project/colette-memorial/authentication/settings")
    sys.exit(1)
print("")
print("Custom domain is authorized for OAuth.")
' "${NEED[@]}"
