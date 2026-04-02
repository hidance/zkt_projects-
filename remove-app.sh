#!/bin/bash
set -e

echo "========================================="
echo "  Odstraňovanie aplikácie..."
echo "========================================="

# Zastavenie a odstránenie kontajnerov, sietí
echo "[1/3] Zastavovanie a odstraňovanie kontajnerov a sietí..."
docker compose down

# Odstránenie pomenovaných zväzkov
echo "[2/3] Odstraňovanie pomenovaných zväzkov..."
docker volume rm web-monitoring-stack_prometheus-data web-monitoring-stack_grafana-data 2>/dev/null || true

# Odstránenie stiahnutých obrazov
echo "[3/3] Odstraňovanie Docker obrazov..."
docker rmi prom/prometheus:main prom/node-exporter:latest grafana/grafana:latest nginx:stable 2>/dev/null || true

echo ""
echo "========================================="
echo "  Aplikácia bola úplne odstránená."
echo "========================================="
