apply-argocd:
	kubectl create namespace argocd && kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

apply-namespace:
	cd k8s && kubectl apply -f namespace.yml
delete-namespace:
	cd k8s && kubectl delete -f namespace.yml

apply-nginx:
	cd k8s/nginx && kubectl apply -f .
delete-nginx:
	cd k8s/nginx && kubectl delete -f .

apply-zookeeper:
	cd k8s/zookeeper && kubectl apply -f .
delete-zookeeper:
	cd k8s/zookeeper && kubectl delete -f .

apply-kafka:
	cd k8s/kafka && kubectl apply -f .
delete-kafka:
	cd k8s/kafka && kubectl delete -f .

apply-minio:
	cd k8s/minio && kubectl apply -f .
delete-minio:
	cd k8s/minio && kubectl delete -f .

apply-redis:
	cd k8s/redis && kubectl apply -f .
delete-redis:
	cd k8s/redis && kubectl delete -f .

apply-swe-notification:
	cd k8s/swe-notification-service && kubectl apply -f .
delete-swe-notification:
	cd k8s/swe-notification-service && kubectl delete -f .

apply-swe-storage:
	cd k8s/swe-storage-service && kubectl apply -f .
delete-swe-storage:
	cd k8s/swe-storage-service && kubectl delete -f .

apply-swe-auth:
	cd k8s/swe-auth-service && kubectl apply -f .
delete-swe-auth:
	cd k8s/swe-auth-service && kubectl delete -f .

apply-swe-task:
	cd k8s/swe-task-service && kubectl apply -f .
delete-swe-task:
	cd k8s/swe-task-service && kubectl delete -f .

apply-swe-gateway:
	cd k8s/swe-gateway-service && kubectl apply -f .
delete-swe-gateway:
	cd k8s/swe-gateway-service && kubectl delete -f .

apply-all:
	./scripts/apply.sh

delete-all:
	./scripts/delete.sh

docker-run:
	cd docker && docker-compose up -d
docker-stop:
	cd docker && docker-compose down