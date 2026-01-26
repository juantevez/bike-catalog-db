# Detectar el sistema operativo
ifeq ($(OS),Windows_NT)
    SLEEP := timeout /t 5 /nobreak > nul
else
    SLEEP := sleep 5
endif

.PHONY: db-up db-down db-migrate db-clean db-logs db-status db-shell db-wait

db-up:
	docker-compose up -d postgres

db-wait:
	@echo "Esperando que postgres este listo..."
	@docker-compose exec -T postgres pg_isready -U bike_user -d bike_registry -t 30 || $(SLEEP) && docker-compose exec -T postgres pg_isready -U bike_user -d bike_registry -t 30

db-migrate: db-up
	@echo "Esperando que postgres este completamente listo..."
	@$(SLEEP)
	@echo "Ejecutando migraciones con Flyway..."
	docker-compose run --rm flyway

db-status:
	@echo "Verificando estado de las migraciones..."
	docker-compose run --rm flyway info

db-down:
	docker-compose down

db-clean:
	@echo "Limpiando base de datos y volumenes..."
	docker-compose down -v

db-logs:
	docker-compose logs -f postgres

db-shell:
	docker exec -it bike-registry-db psql -U bike_user -d bike_registry

db-reset: db-clean db-migrate
	@echo "Base de datos reiniciada y migrada"
