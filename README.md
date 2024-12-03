# SWE-INFRASTRUCTURE

This is a simple infrastructure project that uses Kubernetes(K8s) for container orchestration.

## Tech stack

- [x] [Docker](https://www.docker.com/)
- [x] [Kubernetes](https://kubernetes.io/)

## How to run

1. Install [minikube](https://minikube.sigs.k8s.io/docs/start/)
2. Start minikube

    ```bash
    minikube start
    ```

3. Apply the k8s configuration

    ```bash
    make apply-all
    ```
4. Check the pods

    ```bash
    kubectl get pods -n swe-prod
    ```
5. Check the services

    ```bash
    kubectl get svc -n swe-prod
    ```
6. Check the deployments

    ```bash
    kubectl get deploy -n swe-prod

7. Updating...