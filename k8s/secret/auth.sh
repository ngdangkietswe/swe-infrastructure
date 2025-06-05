#!/usr/bin/env sh

set -e

NAMESPACE="swe-prod"
SECRET_NAME="swe-auth-service-secret"

echo "--------------------------------------------------"
echo "SWE Secrets Management Script"
echo "--------------------------------------------------"

# Confirm secret deletion
# shellcheck disable=SC2039
read -r -p "Are you sure you want to delete the existing secret '$SECRET_NAME' in namespace '$NAMESPACE'? [y/N]: " confirm
if [ "$confirm" != "y" ] && [ "$confirm" != "Y" ]; then
  echo "Operation cancelled."
  exit 0
fi

echo "Deleting existing secret '$SECRET_NAME'..."
kubectl delete secret "$SECRET_NAME" -n "$NAMESPACE" --ignore-not-found
echo "Secret deleted successfully."

# Function to prompt for non-empty input
prompt_required_input() {
  var_name="$1"
  prompt_message="$2"
  input_value=""

  while [ -z "$input_value" ]; do
    # shellcheck disable=SC2039
    read -r -p "$prompt_message: " input_value
    if [ -z "$input_value" ]; then
      echo "$var_name cannot be empty. Please try again."
    fi
  done

  eval "$var_name=\$input_value"
}

# Prompting for values
prompt_required_input JWT_SECRET "Enter the JWT secret"
prompt_required_input JWT_ISSUER "Enter the JWT issuer"

echo "Creating secret '$SECRET_NAME' in namespace '$NAMESPACE'..."
kubectl create secret generic "$SECRET_NAME" -n "$NAMESPACE" \
  --from-literal=JWT_SECRET="$JWT_SECRET" \
  --from-literal=JWT_ISSUER="$JWT_ISSUER"
echo "Secret created successfully."

echo "Retrieving and decoding secret values..."
kubectl get secret "$SECRET_NAME" -n "$NAMESPACE" -o json |
  jq -r '.data | to_entries[] | "\(.key): \(.value | @base64d)"'
