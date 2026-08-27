.PHONY: check up down local-deploy argocd-password argocd-start argocd-stop argocd-port-forward test

check:
	./scripts/check-prereqs.sh

up:
	./scripts/lab-up.sh

down:
	./scripts/lab-down.sh

local-deploy:
	./scripts/deploy-local-dev.sh

argocd-password:
	./scripts/show-argocd-password.sh

argocd-start:
	./scripts/start-argocd-forward.sh

argocd-stop:
	./scripts/stop-argocd-forward.sh

argocd-port-forward:
	./scripts/port-forward-argocd.sh

test:
	cd app && npm test
