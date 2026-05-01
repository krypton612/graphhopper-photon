# Usamos una imagen ligera de JRE para ejecución
FROM eclipse-temurin:17-jre-focal

# Crear directorio de trabajo
WORKDIR /app

# Copiar el binario ejecutable
COPY graphhopper-web-11.0.jar /app/graphhopper.jar

# Copiar la configuración
COPY config/config.yml /app/config.yml

# Copiar el mapa de Bolivia
COPY pbf/bolivia-latest.osm.pbf /app/bolivia-latest.osm.pbf

# Crear directorios para datos y logs (para asegurar permisos)
RUN mkdir -p /app/graph-cache /app/logs

# Exponer el puerto por defecto de GraphHopper
EXPOSE 8989

# Variables de entorno para la JVM (ajustar según tu RAM disponible)
# -Xmx: Memoria máxima, -Xms: Memoria inicial
ENV JAVA_OPTS="-Xmx4g -Xms1g -server"

# Comando de arranque
ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -jar graphhopper.jar server config.yml"]
