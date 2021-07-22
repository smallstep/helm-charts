# Helm Configuration Examples

## Registration Authority Connected to Smallstep Certificate Manager Hosted Certificate Authority.

```bash
CA_NAME='example-ca'
CA_FINGERPRINT='ca-fingerprint'
ORG_NAME='example-org'

# Install Step If Not already installed.
brew install step

# Bootstrap Step against the CA if not already bootstrapped.
step ca bootstrap --ca-url https://${CA_NAME}.${ORG_NAME}.ca.smallstep.com --fingerprint ${CA_FINGERPRINT}

# Create a registration-authority JWK Provisioner
step beta ca provisioner add registration-authority --create

# Encode the JWK Provisioner password in base64
JWK_ISSUER_PASSWORD=`echo 'your-password-here' | base64`

# Download the example values.yml
curl -o step_values.yml https://raw.githubusercontent.com/smallstep/helm-charts/master/step-certificates/examples/registration_authority/values.yml

# Replace dummy values with your own values
sed -e "s/your-ca-name/${CA_NAME}/g" -i step_values.yml
sed -e "s/your-org/${ORG_NAME}/g" -i step_values.yml
sed -e "s/your-ca-fingerprint-here/${CA_FINGERPRINT}/g" -i step_values.yml
sed -e "s/your-base-64-encoded-key-password/${JWK_ISSUER_PASSWORD}/g" -i step_values.yml

# Add the smallstep helm repo, if not already added
helm repo add smallstep https://smallstep.github.io/helm-charts/

# Update helm repos to ensure you have the latest version
helm repo update smallstep

# Install the step-certificates helm chart.
helm install -f step_values.yml smallstep/step-certificates
```