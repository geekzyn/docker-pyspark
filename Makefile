up:
	docker compose up -d --build

up-scaled:
	make down && docker-compose up -d --scale spark-worker=2

down:
	docker compose down --rmi all

dev:
	docker exec -it spark-master bash
