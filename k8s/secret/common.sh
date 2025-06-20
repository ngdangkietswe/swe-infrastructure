#!/usr/bin/env sh

set -e

NAMESPACE="swe-prod"
SECRET_NAME="swe-common-secret"

echo "------------------------------------------------------------"
echo "SWE Common Secret Manager"
echo "------------------------------------------------------------"

# Confirm deletion of existing secret
printf "You are about to delete the Kubernetes secret '%s' in namespace '%s'.\n" "$SECRET_NAME" "$NAMESPACE"
# shellcheck disable=SC2039
read -rp "Are you sure you want to proceed? [y/N]: " confirm
if [ "$confirm" != "y" ] && [ "$confirm" != "Y" ]; then
  echo "Operation cancelled by user."
  exit 0
fi

echo "🔄 Deleting existing secret '$SECRET_NAME'..."
kubectl delete secret "$SECRET_NAME" -n "$NAMESPACE" --ignore-not-found
echo "✅ Secret deleted successfully."

# Function to prompt for a non-empty input
prompt_required_input() {
  # shellcheck disable=SC2039
  local var_name="$1"
  # shellcheck disable=SC2039
  local prompt_message="$2"
  # shellcheck disable=SC2039
  local input_value=""

  while [ -z "$input_value" ]; do
    # shellcheck disable=SC2039
    read -rp "$prompt_message: " input_value
    if [ -z "$input_value" ]; then
      echo "⚠️  $var_name cannot be empty. Please try again."
    fi
  done

  eval "$var_name=\$input_value"
}

# Prompt for secret values
prompt_required_input DB_HOST "Enter the database host"
prompt_required_input DB_PORT "Enter the database port"
prompt_required_input DB_USER "Enter the database username"

# Silent prompt for password
while [ -z "$DB_PASSWORD" ]; do
  # shellcheck disable=SC2039
  read -rsp "Enter the database password: " DB_PASSWORD
  echo
  [ -z "$DB_PASSWORD" ] && echo "⚠️  Password cannot be empty. Please try again."
done

while [ -z "$JWT_SECRET" ]; do
  # shellcheck disable=SC2039
  read -rsp "Enter the JWT secret: " JWT_SECRET
  echo
  [ -z "$JWT_SECRET" ] && echo "⚠️  JWT secret cannot be empty. Please try again."
done

while [ -z "$JWT_ISSUER" ]; do
  # shellcheck disable=SC2039
  read -rsp "Enter the JWT issuer: " JWT_ISSUER
  echo
  [ -z "$JWT_ISSUER" ] && echo "⚠️  JWT issuer cannot be empty. Please try again."
done

# Create new Kubernetes secret
echo "🔐 Creating secret '$SECRET_NAME' in namespace '$NAMESPACE'..."
kubectl create secret generic "$SECRET_NAME" -n "$NAMESPACE" \
  --from-literal=DB_HOST="$DB_HOST" \
  --from-literal=DB_PORT="$DB_PORT" \
  --from-literal=DB_USER="$DB_USER" \
  --from-literal=DB_PASSWORD="$DB_PASSWORD" \
  --from-literal=JWT_SECRET="$JWT_SECRET" \
  --from-literal=JWT_ISSUER="$JWT_ISSUER"
echo "✅ Secret '$SECRET_NAME' created successfully."

# Show the decoded secret data
echo "📦 Retrieving and decoding secret values:"
kubectl get secret "$SECRET_NAME" -n "$NAMESPACE" -o json | jq -r '.data | map_values(@base64d)'

echo "------------------------------------------------------------"
echo "SWE Common secret setup completed successfully."
echo "You can now use this secret in your Kubernetes deployments."
echo "------------------------------------------------------------"
