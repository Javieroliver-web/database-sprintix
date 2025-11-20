# ========================================
# MAKEFILE PARA GESTIÓN DE BASE DE DATOS
# ========================================

.PHONY: help build up down logs restart backup restore clean

# Variables
COMPOSE := docker-compose
DB_CONTAINER := sprintix-db
BACKUP_DIR := ./backups

help: ## Mostrar ayuda
	@echo "Comandos disponibles:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2}'

build: ## Construir la imagen de Docker
	$(COMPOSE) build

up: ## Iniciar los servicios
	$(COMPOSE) up -d
	@echo "✅ Base de datos iniciada"
	@echo "📊 PostgreSQL: localhost:5432"
	@echo "🖥️  PgAdmin: http://localhost:5050"

down: ## Detener los servicios
	$(COMPOSE) down
	@echo "✅ Servicios detenidos"

logs: ## Ver logs
	$(COMPOSE) logs -f postgres

restart: ## Reiniciar servicios
	$(COMPOSE) restart
	@echo "✅ Servicios reiniciados"

backup: ## Crear backup de la base de datos
	@mkdir -p $(BACKUP_DIR)
	@BACKUP_FILE="$(BACKUP_DIR)/backup_$$(date +%Y%m%d_%H%M%S).sql"; \
	docker exec -t $(DB_CONTAINER) pg_dump -U myuser mydb > $$BACKUP_FILE && \
	gzip $$BACKUP_FILE && \
	echo "✅ Backup creado: $$BACKUP_FILE.gz"

restore: ## Restaurar backup (uso: make restore FILE=backup.sql.gz)
	@if [ -z "$(FILE)" ]; then \
		echo "❌ Error: Debes especificar el archivo con FILE=backup.sql.gz"; \
		exit 1; \
	fi
	@if [[ "$(FILE)" == *.gz ]]; then \
		gunzip -c $(FILE) | docker exec -i $(DB_CONTAINER) psql -U myuser -d mydb; \
	else \
		cat $(FILE) | docker exec -i $(DB_CONTAINER) psql -U myuser -d mydb; \
	fi
	@echo "✅ Backup restaurado desde: $(FILE)"

clean: ## Detener y eliminar volúmenes
	$(COMPOSE) down -v
	@echo "✅ Servicios y volúmenes eliminados"

psql: ## Conectar a PostgreSQL con psql
	docker exec -it $(DB_CONTAINER) psql -U myuser -d mydb

stats: ## Ver estadísticas de la base de datos
	docker exec -it $(DB_CONTAINER) psql -U myuser -d mydb -c "\
		SELECT \
			schemaname, \
			tablename, \
			pg_size_pretty(pg_total_relation_size(schemaname||'.'||tablename)) AS size \
		FROM pg_tables \
		WHERE schemaname = 'public' \
		ORDER BY pg_total_relation_size(schemaname||'.'||tablename) DESC;"

rebuild: down build up ## Reconstruir y reiniciar
	@echo "✅ Reconstrucción completa"
```

---

## 📂 **Estructura final del proyecto**
```
proyecto-database/
├── Dockerfile                    # ⭐ NUEVO
├── .dockerignore                 # ⭐ NUEVO
├── docker-compose.yml            # Actualizado
├── .env
├── Makefile                      # ⭐ NUEVO (opcional)
├── config/                       # ⭐ NUEVO (opcional)
│   └── postgresql.conf
├── init-scripts/
│   ├── 01-create-schema.sql
│   ├── 02-insert-sample-data.sql
│   └── 03-create-indexes.sql
├── backups/
│   └── .gitkeep
├── scripts/
│   ├── backup.sh
│   └── restore.sh
└── README.md