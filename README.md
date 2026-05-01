# 🚀 Transitabilidad Backend - Bolivia (GraphHopper + Photon)

Este repositorio contiene una infraestructura Dockerizada lista para producción de servicios de enrutamiento y geocodificación, optimizada específicamente para el mapa de Bolivia.

---

## 🛠 Componentes

- **GraphHopper 11.0**: Motor de enrutamiento de alto rendimiento.
- **Photon 1.0.1**: Buscador de direcciones (geocoding) basado en OpenSearch.
- **Zstd Integration**: Importación eficiente de datos comprimidos para ahorrar espacio.

---

## 📦 Requisitos Previos

- Docker & Docker Compose.
- Mínimo **8GB de RAM libre** (se recomiendan 12GB para la importación inicial).
- Archivo de mapa: `bolivia-latest.osm.pbf`.
- Dump de Photon: `photon-dump-bolivia-1.0-latest.jsonl.zst`.

---

## Ejecucion con imagenes GHCR
---
```yml
services:
  graphhopper:
    image: ghcr.io/krypton612/graphhopper-bolivia:11.0
    container_name: graphhopper_bolivia
    ports:
      - "8989:8989"
    volumes:
      - gh_data:/app/graph-cache
      - gh_logs:/app/logs
    environment:
      - JAVA_OPTS=-Xmx4g -Xms2g
    networks:
      - transit-net
    restart: unless-stopped
    healthcheck:
      test: ["CMD", "wget", "-qO-", "http://localhost:8989/health"]
      interval: 30s
      timeout: 10s
      retries: 5
      start_period: 60s

  photon:
    image: ghcr.io/krypton612/photon-bolivia:1.0.1
    container_name: photon_bolivia
    ports:
      - "2322:2322"
    volumes:
      - photon_db:/app/photon_data
    environment:
      - JAVA_OPTS=-Xmx4g -Xms2g
    networks:
      - transit-net
    restart: unless-stopped
    healthcheck:
      test:
        - "CMD-SHELL"
        - |
          STATUS=$(cat /app/photon_data/.status 2>/dev/null || echo 'unknown')
          if [ "$STATUS" = "importing" ] || [ "$STATUS" = "starting" ]; then
            echo "Photon aún no listo: $STATUS" && exit 1
          fi
          wget -qO- "http://localhost:2322/api?q=cochabamba&limit=1" > /dev/null 2>&1
      interval: 20s
      timeout: 10s
      retries: 10
      start_period: 120s

volumes:
  gh_data:
  gh_logs:
  photon_db:

networks:
  transit-net:
    driver: bridge
```
## 🚀 Instalación Rápida

**1. Clonar el repositorio:**
```bash
git clone https://github.com/krypton612/transitabilidad-backend.git
cd transitabilidad-backend
```

**2. Preparar directorios de datos:**
```bash
mkdir -p graphhopper/graph-cache photon/photon_data
```

**3. Levantar los servicios:**
```bash
docker compose up -d --build
```

---

## 🚦 Endpoints Disponibles

| Servicio     | Puerto | Descripción                          |
|--------------|--------|--------------------------------------|
| GraphHopper  | 8989   | API de ruteo e isocronas.            |
| Photon       | 2322   | API de búsqueda y autocompletado.    |

**Test de Ruteo:**
```
http://localhost:8989/route?point=-16.489,-68.119&point=-16.495,-68.123&profile=car

**Test de Búsqueda:**
```
http://localhost:2322/api?q=La+Paz

---

## 📖 Documentación Oficial

### GraphHopper
| Recurso | Link |
|---------|------|
| Repositorio | [github.com/graphhopper/graphhopper](https://github.com/graphhopper/graphhopper) |
| Índice de docs | [docs/index.md](https://github.com/graphhopper/graphhopper/blob/11.x/docs/index.md) |
| Web API | [docs/web/api-doc.md](https://github.com/graphhopper/graphhopper/blob/master/docs/web/api-doc.md) |
| Custom Models | [docs/custom-models.md](https://github.com/graphhopper/graphhopper/blob/master/docs/core/custom-models.md) |
| Deployment Guide | [docs/deploy.md](https://github.com/graphhopper/graphhopper/blob/master/docs/core/deploy.md) |

### Photon
| Recurso | Link |
|---------|------|
| Repositorio | [github.com/komoot/photon](https://github.com/komoot/photon) |
| Uso e importación | [docs/usage.md](https://github.com/komoot/photon/blob/master/docs/usage.md) |
| API Reference | [docs/api-v1.md](https://github.com/komoot/photon/blob/master/docs/api-v1.md) |
| Releases | [github.com/komoot/photon/releases](https://github.com/komoot/photon/releases) |
| Demo público | [photon.komoot.io](https://photon.komoot.io) |

---

## ⚙️ Configuración de Memoria

Por defecto, ambos contenedores están configurados con un límite de **4GB de RAM**. Puedes ajustar esto en el archivo `docker-compose.yml`:

```yaml
environment:
  - JAVA_OPTS=-Xmx4g -Xms2g
```
