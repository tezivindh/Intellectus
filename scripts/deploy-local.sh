#!/usr/bin/env bash
set -euo pipefail
# The images must have passed tests and scans first (scripts/verify.sh).
minikube start --driver=docker
kubectl apply -f k8s/namespace.yaml
python3 scripts/bootstrap-secrets.py
for image in Intellectus-backend:local Intellectus-frontend:local Intellectus-next:local; do
  minikube image load "$image"
done
INGRESS_SERVICE_TYPE=NodePort bash scripts/install-monitoring.sh
helm upgrade --install Intellectus helm/Intellectus --namespace Intellectus \
  --set metrics.serviceMonitor.enabled=true --wait --wait-for-jobs --timeout 15m
kubectl get pods,svc,ingress -n Intellectus
helm list -n Intellectus
printf 'Local Ingress: http://%s:30080 (send Host: Intellectus.local)\n' "$(minikube ip)"
