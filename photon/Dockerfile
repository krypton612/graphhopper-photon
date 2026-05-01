FROM eclipse-temurin:21-jre

WORKDIR /app

# instalar zstd
RUN apt-get update && apt-get install -y zstd && rm -rf /var/lib/apt/lists/*

# Copiar archivos necesarios
COPY photon-1.0.1.jar /app/photon.jar
COPY photon-dump-bolivia-1.0-latest.jsonl.zst /app/bolivia.jsonl.zst
COPY entrypoint.sh /app/entrypoint.sh

# Dar permisos de ejecución al script y crear carpeta de datos
RUN chmod +x /app/entrypoint.sh && mkdir -p /app/photon_data

EXPOSE 2322

ENV JAVA_OPTS="-Xmx4g -Xms2g"

# Usar el script como punto de entrada
ENTRYPOINT ["/app/entrypoint.sh"]
