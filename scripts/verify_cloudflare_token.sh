#!/usr/bin/env bash
set -euo pipefail

if [ -z "${CLOUDFLARE_API_TOKEN:-}" ]; then
  echo "CLOUDFLARE_API_TOKEN is not set"
  exit 1
fi

status=$(curl -s -o /dev/null -w "%{http_code}" -H "Authorization: Bearer ${CLOUDFLARE_API_TOKEN}" "https://api.cloudflare.com/client/v4/user/tokens/verify")
if [ "$status" != "200" ]; then
  echo "Cloudflare token verify failed: $status"
  exit 1
fi

echo "Cloudflare token verified"
