echo "Deleting zookeeper to k8s cluster..."
make delete-zookeeper

echo "Deleting kafka to k8s cluster..."
make delete-kafka

echo "Deleting redis to k8s cluster..."
make delete-redis

echo "Deleting mino to k8s cluster..."
make delete-minio

echo "Deleting swe notification service to k8s cluster..."
make delete-swe-notification

echo "Deleting swe storage service to k8s cluster..."
make delete-swe-storage

echo "Deleting swe auth service to k8s cluster..."
make delete-swe-auth

echo "Deleting swe task service to k8s cluster..."
make delete-swe-task

echo "Deleting swe gateway service to k8s cluster..."
make delete-swe-gateway

echo "Deleting namespace to k8s cluster..."
make delete-namespace