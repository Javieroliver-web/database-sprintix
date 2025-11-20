# ========================================
# DOCKERFILE PARA POSTGRESQL - DATABASE-SPRINTIX
# ========================================

FROM postgres:17-alpine

# Metadata
LABEL maintainer="sprintix@example.com"
LABEL description="PostgreSQL 17 database for Sprintix project management system"
LABEL version="1.0"

# Variables de entorno por defecto (Se pueden sobrescribir desde docker-compose)
ENV POSTGRES_USER=myuser \
    POSTGRES_PASSWORD=mypass \
    POSTGRES_DB=mydb \
    PGDATA=/var/lib/postgresql/data/pgdata

# Copiar scripts de inicialización (Schema, Data, Indexes)
# Se ejecutarán en orden alfabético: 01..., 02..., 03...
COPY ./init-scripts/*.sql /docker-entrypoint-initdb.d/

# Crear directorio para backups y asignar permisos al usuario postgres
RUN mkdir -p /backups && \
    chown -R postgres:postgres /backups

# Exponer puerto estándar
EXPOSE 5432

# Volúmenes anónimos para persistencia interna
VOLUME ["/var/lib/postgresql/data", "/backups"]

# Health check robusto
HEALTHCHECK --interval=30s --timeout=5s --start-period=30s --retries=3 \
    CMD pg_isready -U ${POSTGRES_USER} -d ${POSTGRES_DB} || exit 1