#!/bin/bash

set -e

echo "========================================="
echo "  Spúšťanie aplikácie..."
echo "========================================="

docker compose up -d

echo ""
echo "========================================="
echo "  Aplikácia beží!"
echo "========================================="
echo ""
echo "  Dostupné služby:"
echo "    Frontend (Nginx):    http://localhost:81"
echo "    Prometheus:          http://localhost:9090"
echo "    Grafana:             http://localhost:3000"
echo "    Node Exporter:       http://localhost:9100/metrics"
echo ""
echo "  Grafana prihlasovacie údaje:"
echo "    Používateľ: admin"
echo "    Heslo:      admin"
echo ""
echo "  Zastavenie: ./stop-app.sh"
echo "========================================="
