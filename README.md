# Docker Monitoring Stack

Webová aplikácia na monitorovanie servera, nasadená pomocou Docker Compose. Skladá sa zo 4 služieb: **Nginx** (statický frontend), **Prometheus** (zber metrík), **Node Exporter** (systémové metriky) a **Grafana** (vizualizácia).

---

## Podmienky na nasadenie

- **Operačný systém:** Linux
- **Docker Engine:** verzia 20.10+
- **Docker Compose:** verzia 2.0+ (príkaz `docker compose`)
- **Voľné porty:** 81, 3000, 9090, 9100
- **Prístup na internet** (na stiahnutie Docker obrazov z Docker Hub)

---

## Opis aplikácie

Aplikácia poskytuje kompletný monitorovací stack servera:

1. **Nginx** — webový server, ktorý zobrazuje statickú HTML stránku (frontend) s odkazmi na všetky služby.
2. **Prometheus** — systém na zber a ukladanie časových metrík. Zbiera dáta z Node Exporter každých 5 sekúnd.
3. **Node Exporter** — exportér systémových metrík (CPU, pamäť, disk, sieť) vo formáte Prometheus.
4. **Grafana** — webové rozhranie na vizualizáciu metrík z Prometheus pomocou dashboardov.

---

## Virtuálne siete

| Sieť | Typ | Opis |
|-------|-----|------|
| `monitor-network` | bridge | Všetky 4 kontajnery sú pripojené do tejto siete a môžu medzi sebou komunikovať pomocou mien kontajnerov (napr. `prometheus:9090`, `node-exporter:9100`). |

---

## Pomenované zväzky

| Zväzok | Pripojený ku | Cesta v kontajneri | Opis |
|--------|-------------|---------------------|------|
| `prometheus-data` | Prometheus | `/prometheus` | Trvalé ukladanie zozbieraných metrík. Dáta prežijú reštart aj zastavenie aplikácie. |
| `grafana-data` | Grafana | `/var/lib/grafana` | Trvalé ukladanie dashboardov, dátových zdrojov a nastavení Grafany. |

---

## Konfigurácia kontajnerov

### Prometheus
- **Obraz:** `prom/prometheus:main`
- **Port:** `9090:9090`
- **Konfigurácia:** súbor `./prometheus/prometheus.yml` pripojený ako read-only
- **Zväzok:** `prometheus-data` pre trvalé ukladanie dát
- **Restart:** `unless-stopped`

### Node Exporter
- **Obraz:** `prom/node-exporter:latest`
- **Port:** `9100:9100`
- **Konfigurácia:** prístup k hostiteľským `/proc`, `/sys` a `/` ako read-only pre čítanie systémových metrík
- **Argumenty:** `--path.procfs=/host/proc --path.sysfs=/host/sys --path.rootfs=/rootfs`
- **Restart:** `unless-stopped`

### Grafana
- **Obraz:** `grafana/grafana:latest`
- **Port:** `3000:3000`
- **Zväzok:** `grafana-data` pre trvalé ukladanie nastavení
- **Premenné prostredia:**
  - `GF_SECURITY_ADMIN_USER=admin`
  - `GF_SECURITY_ADMIN_PASSWORD=admin`
  - `GF_USERS_ALLOW_SIGN_UP=false`
- **Restart:** `unless-stopped`

### Nginx
- **Obraz:** `nginx:stable`
- **Port:** `81:80`
- **Konfigurácia:** vlastný `nginx.conf` s gzip kompresiou a bezpečnostnými hlavičkami
- **Obsah:** priečinok `./frontend` pripojený ako read-only na `/usr/share/nginx/html`
- **Restart:** `unless-stopped`

---

## Zoznam kontajnerov

| Kontajner | Obraz | Port | Opis |
|-----------|-------|------|------|
| `nginx` | `nginx:stable` | 81 | Webový server pre statický frontend |
| `prometheus` | `prom/prometheus:main` | 9090 | Zber a ukladanie metrík |
| `node-exporter` | `prom/node-exporter:latest` | 9100 | Exportér systémových metrík |
| `grafana` | `grafana/grafana:latest` | 3000 | Vizualizácia metrík |

---

## Návod na prácu s aplikáciou

### Príprava
```bash
./prepare-app.sh
```
Stiahne Docker obrazy, vytvorí siete, zväzky a kontajnery.

### Spustenie
```bash
./start-app.sh
```
Spustí všetky kontajnery. Vypíše adresy služieb a prihlasovacie údaje.

### Pozastavenie
```bash
./stop-app.sh
```
Zastaví kontajnery bez straty dát. Opätovné spustenie cez `./start-app.sh` obnoví aplikáciu v pôvodnom stave.

### Vymazanie
```bash
./remove-app.sh
```
Odstráni všetky kontajnery, siete, pomenované zväzky a stiahnuté obrazy.

---

## Ako si pozrieť aplikáciu

Po spustení (`./start-app.sh`) otvorte v prehliadači:

| Služba | URL | Prihlasovacie údaje |
|--------|-----|---------------------|
| Frontend | [http://localhost:81](http://localhost:81) | — |
| Prometheus | [http://localhost:9090](http://localhost:9090) | — |
| Grafana | [http://localhost:3000](http://localhost:3000) | admin / admin |
| Node Exporter | [http://localhost:9100/metrics](http://localhost:9100/metrics) | — |

### Prvé kroky v Grafane
1. Prihláste sa: `admin` / `admin`
2. Pridajte dátový zdroj: **Configuration → Data Sources → Add → Prometheus**
3. URL: `http://prometheus:9090`
4. Kliknite **Save & Test**
5. Importujte dashboard alebo vytvorte vlastný

---

## Použité zdroje

- [Docker dokumentácia](https://docs.docker.com/)
- [Docker Compose dokumentácia](https://docs.docker.com/compose/)
- [Prometheus dokumentácia](https://prometheus.io/docs/)
- [Grafana dokumentácia](https://grafana.com/docs/)
- [Node Exporter – GitHub](https://github.com/prometheus/node_exporter)
- [Nginx dokumentácia](https://nginx.org/en/docs/)

---

## Použitie umelej inteligencie

Pri tvorbe projektu bol použitý AI agent **Gemini (Antigravity)** na nasledujúce rutinné úlohy:

- Generovanie bash skriptov (`prepare-app.sh`, `start-app.sh`, `stop-app.sh`, `remove-app.sh`) — najmä echo výstupy a štruktúra
- Tvorba statickej HTML stránky (`index.html`) — dizajn a vizualizácia komponentov
- Preklad textov do slovenčiny
- Pomoc pri diagnostike problémov — agent upozorňoval na chyby v konfigurácii

Architektúru aplikácie, výber služieb, konfiguráciu Docker Compose a celkový návrh riešenia som realizoval **samostatne**.
