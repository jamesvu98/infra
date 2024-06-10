tfInit:
	terraform init

plan-infra: tfInit
	cd terraform && terraform plan

deploy-infra: tfInit
	cd terraform && terraform apply -auto-approve

caddy:
	rsync -tz --progress Caddyfile root@$(SERVER_IP):~
	ssh root@$(SERVER_IP) "docker compose exec -w /etc/caddy caddy sh -c 'caddy fmt --overwrite && caddy reload'"