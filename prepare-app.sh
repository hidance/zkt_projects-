#!/bin/bash

set -e

echo "========================================="
echo "  Príprava aplikácie..."
echo "========================================="

# Stiahnutie Docker obrazov
echo "[1/3] Sťahovanie Docker obrazov..."
docker compose pull

# Vytvorenie siete a zväzkov (docker compose create ich vytvorí automaticky)
echo "[2/3] Vytváranie sietí a pomenovaných zväzkov..."
docker compose create

echo "[3/3] Kontrola..."
echo ""
echo "Vytvorené siete:"
docker network ls --filter "name=web-monitoring-stack" --format "  - {{.Name}}"
echo ""
echo "Vytvorené zväzky:"
docker volume ls --filter "name=web-monitoring-stack" --format "  - {{.Name}}"
echo ""

echo "========================================="
echo "  Príprava dokončená!"
echo "  Spustite aplikáciu: ./start-app.sh"
echo "========================================="
