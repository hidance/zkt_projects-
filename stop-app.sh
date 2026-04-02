#!/bin/bash

set -e

echo "========================================="
echo "  Zastavovanie aplikácie..."
echo "========================================="

docker compose stop

echo ""
echo "========================================="
echo "  Aplikácia zastavená."
echo "  Dáta sú zachované v pomenovaných zväzkoch."
echo "  Opätovné spustenie: ./start-app.sh"
echo "========================================="
