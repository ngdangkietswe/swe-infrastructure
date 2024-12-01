apply-zookeeper:
	cd k8s/zookeeper && kubectl apply -f .
delete-zookeeper:
	cd k8s/zookeeper && kubectl delete -f .
apply-kafka:
	cd k8s/kafka && kubectl apply -f .
delete-kafka:
	cd k8s/kafka && kubectl delete -f .
apply-swe-notification:
	cd k8s/swe-notification-service && kubectl apply -f .
delete-swe-notification:
	cd k8s/swe-notification-service && kubectl delete -f .