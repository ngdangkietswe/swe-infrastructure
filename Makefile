apply-namespace:
	cd k8s && kubectl apply -f namespace.yml

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

apply-swe-notification:
	cd k8s/swe-notification-service && kubectl apply -f .
delete-swe-notification:
	cd k8s/swe-notification-service && kubectl delete -f .

apply-swe-storage:
	cd k8s/swe-storage-service && kubectl apply -f .
delete-swe-storage:
	cd k8s/swe-storage-service && kubectl delete -f .