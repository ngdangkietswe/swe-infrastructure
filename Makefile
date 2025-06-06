# Makefile for managing Kubernetes resources, secrets, and Docker containers

# Configurable variables
K8S_DIR := k8s
SERVICES := nginx zookeeper kafka minio redis \
	swe-notification-service swe-storage-service swe-auth-service \
	swe-task-service swe-gateway-service
SECRETS := common integration notification

.PHONY: apply-argocd apply-namespace delete-namespace \
	$(addprefix apply-,$(SERVICES)) \
	$(addprefix delete-,$(SERVICES)) \
	$(addprefix create-,$(addsuffix -secret,$(SECRETS))) \
	apply-all delete-all create-all-secrets \
	docker-run docker-stop

# --- Argo CD ---
apply-argocd:
	kubectl create namespace argocd || true
	kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# --- Namespace ---
apply-namespace:
	kubectl apply -f $(K8S_DIR)/namespace.yml

delete-namespace:
	kubectl delete -f $(K8S_DIR)/namespace.yml

# --- Apply/Delete Service Definitions ---
define APPLY_SERVICE_template
apply-$(1):
	cd $(K8S_DIR)/$(1) && kubectl apply -f .
endef

define DELETE_SERVICE_template
delete-$(1):
	cd $(K8S_DIR)/$(1) && kubectl delete -f .
endef

$(foreach svc,$(SERVICES),$(eval $(call APPLY_SERVICE_template,$(svc))))
$(foreach svc,$(SERVICES),$(eval $(call DELETE_SERVICE_template,$(svc))))

# --- Secret Management ---
define CREATE_SECRET_template
create-$(1)-secret:
	cd $(K8S_DIR)/secret && bash $(1).sh
endef

$(foreach s,$(SECRETS),$(eval $(call CREATE_SECRET_template,$(s))))

create-all-secrets: $(addprefix create-,$(addsuffix -secret,$(SECRETS)))

# --- All apply/delete ---
apply-all: apply-namespace create-all-secrets $(addprefix apply-,$(SERVICES))

delete-all: $(addprefix delete-,$(SERVICES)) delete-namespace

delete-all-pods:
	kubectl delete pods --all --all-namespaces

# --- Docker Helpers (customize as needed) ---
docker-run:
	@echo "Starting Docker containers..."
	# docker-compose up -d

docker-stop:
	@echo "Stopping Docker containers..."
	# docker-compose down
