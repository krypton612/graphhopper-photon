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
