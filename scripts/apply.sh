echo "Applying namespace to k8s cluster..."
make apply-namespace

echo "Applying zookeeper to k8s cluster..."
make apply-zookeeper

echo "Applying kafka to k8s cluster..."
make apply-kafka

echo "Applying redis to k8s cluster..."
make apply-redis

echo "Applying mino to k8s cluster..."
make apply-minio

echo "Applying swe notification service to k8s cluster..."
make apply-swe-notification

echo "Applying swe storage service to k8s cluster..."
make apply-swe-storage

echo "Applying swe auth service to k8s cluster..."
make apply-swe-auth

echo "Applying swe task service to k8s cluster..."
make apply-swe-task

echo "Applying swe gateway service to k8s cluster..."
make apply-swe-gateway