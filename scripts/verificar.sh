#!/bin/bash

set -uo pipefail

NS="devops-portfolio"
ERRORS=0

ok()   { echo "  [OK]   $1"; }
fail() { echo "  [FAIL] $1"; ERRORS=$((ERRORS+1)); }

echo "=== Verificación Helm + Ingress — TP 10 ==="
echo ""

echo "--- Helm release ---"
if helm status mi-app -n "$NS" &>/dev/null; then
    STATUS=$(helm status mi-app -n "$NS" | awk -F': ' '/^STATUS:/ {print $2; exit}')
    if [ "$STATUS" = "deployed" ]; then
        ok "Release mi-app → $STATUS"
    else
        fail "Release mi-app → ${STATUS:-estado desconocido}"
    fi
else
    fail "Release mi-app no encontrado"
fi

echo ""
echo "--- Pods ---"
while read -r NAME READY STATUS; do
    [ -z "${NAME:-}" ] && continue
    [ "$STATUS" = "Running" ] && ok "$NAME → $STATUS ($READY)" || fail "$NAME → $STATUS"
done < <(kubectl get pods -n "$NS" --no-headers 2>/dev/null | awk '{print $1, $2, $3}')

echo ""
echo "--- Ingress ---"
while read -r NAME HOST; do
    [ -z "${NAME:-}" ] && continue
    ok "$NAME → host: $HOST"
done < <(kubectl get ingress -n "$NS" -o custom-columns=NAME:.metadata.name,HOST:.spec.rules[0].host --no-headers 2>/dev/null)

echo ""
echo "--- Healthcheck via Ingress ---"
NODE_IP=$(kubectl get nodes -o jsonpath='{.items[0].status.addresses[0].address}' 2>/dev/null)

for path in "/" "/health" "/api/notes"; do
    CODE=$(curl -s -o /dev/null -w "%{http_code}" \
      -H "Host: devops-portfolio.dev" \
      --max-time 5 \
      "http://$NODE_IP:30080$path" 2>/dev/null || true)

    [ "$CODE" = "200" ] && ok "$path → HTTP $CODE" || fail "$path → HTTP ${CODE:-000}"
done

echo ""
[ "$ERRORS" -eq 0 ] && echo "TP 10 OK" || echo "$ERRORS checks fallaron"
