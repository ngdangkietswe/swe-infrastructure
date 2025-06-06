#!/usr/bin/env sh

set -e

NAMESPACE="swe-prod"
SECRET_NAME="swe-integration-service-secret"

echo "------------------------------------------------------------"
echo "SWE Integration Service Secret Manager"
echo "------------------------------------------------------------"

# Confirm deletion of the existing secret
printf "You are about to delete the Kubernetes secret '%s' in namespace '%s'.\n" "$SECRET_NAME" "$NAMESPACE"
# shellcheck disable=SC2039
read -rp "Are you sure you want to continue? [y/N]: " confirm
if [ "$confirm" != "y" ] && [ "$confirm" != "Y" ]; then
  echo "Operation cancelled by user."
  exit 0
fi

echo "🔄 Deleting existing secret '$SECRET_NAME'..."
kubectl delete secret "$SECRET_NAME" -n "$NAMESPACE" --ignore-not-found
echo "✅ Secret deleted successfully."

# Function to prompt for a required non-empty input
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

# Collect new secret values
prompt_required_input STRAVA_CLIENT_ID "Enter the strava client id"
prompt_required_input STRAVA_CLIENT_SECRET "Enter the strava client secret"

# Create the secret
echo "🔐 Creating secret '$SECRET_NAME' in namespace '$NAMESPACE'..."
kubectl create secret generic "$SECRET_NAME" -n "$NAMESPACE" \
  --from-literal=STRAVA_CLIENT_ID="$STRAVA_CLIENT_ID" \
  --from-literal=STRAVA_CLIENT_SECRET="$STRAVA_CLIENT_SECRET"
echo "✅ Secret '$SECRET_NAME' created successfully."

# Show the decoded secret data
echo "📦 Retrieving and decoding secret values:"
kubectl get secret "$SECRET_NAME" -n "$NAMESPACE" -o json | jq -r '.data | map_values(@base64d)'

echo "------------------------------------------------------------"
echo "SWE Integration Service secret setup completed successfully."
echo "You can now use the secret in your Kubernetes deployments."
echo "------------------------------------------------------------"