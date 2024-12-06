build:
	docker compose build

up: build
	docker compose up -d

shell: up
	docker compose exec app bash

format: up
	docker compose exec app ruff format .

lint: up
	docker compose exec app ruff check --fix .

typecheck: up
	docker compose exec app mypy .

test: up
	docker compose exec app pytest

run: up
	docker compose exec app python -m autostrava