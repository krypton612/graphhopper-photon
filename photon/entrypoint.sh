#!/bin/sh
set -e

STATUS_FILE="/app/photon_data/.status"

write_status() {
    echo "$1" > "$STATUS_FILE"
}

echo "--- Verificando estado de Photon ---"

if [ ! -d "/app/photon_data/photon_data" ]; then
    echo "[IMPORT] No se detectó base de datos. Iniciando importación..."
    write_status "importing"

    zstd --stdout -d /app/bolivia.jsonl.zst | \
    java $JAVA_OPTS -jar photon.jar import \
        -data-dir /app/photon_data \
        -import-file - \
        -languages es,en

    echo "[IMPORT] Importación finalizada con éxito."
    write_status "ready"
else
    echo "[SKIP] Base de datos existente detectada. Saltando importación."
    write_status "ready"
fi

echo "--- Iniciando servidor Photon ---"
write_status "starting"

exec java $JAVA_OPTS -jar photon.jar serve \
    -data-dir /app/photon_data \
    -listen-ip 0.0.0.0 \
    -listen-port 2322 \
    -languages es,en \
    -cors-any
