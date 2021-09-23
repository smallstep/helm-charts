ROOT_CA_NAME='example-root-ca'
INTERMEDIATE_CA_NAME='example-intermediate-ca'
CA_ORG_NAME='Example CA Org'
CA_COUNTRY_NAME='US'
CA_LOCALITY_NAME='Minnesota'
export ROOT_CA_NAME INTERMEDIATE_CA_NAME CA_ORG_NAME CA_COUNTRY_NAME CA_LOCALITY_NAME

# Write Out Root and Intermediate Certificate Templates
cat root-tls.json.tpl | envsubst | tee root-tls.json
cat intermediate-tls.json.tpl | envsubst | tee intermediate-tls.json

# Generate Root and Intermediate Passwords
ROOT_TLS_PASSWORD_B64=`tr -dc 'A-Za-z0-9!"#$%&'\''()*+,-./:;<=>?@[\]^_\`{|}~' </dev/urandom | head -c 64 | tee root-tls.password | base64 --wrap=0`
INTERMEDIATE_TLS_PASSWORD_B64=`tr -dc 'A-Za-z0-9!"#$%&'\''()*+,-./:;<=>?@[\]^_\`{|}~' </dev/urandom | head -c 64 | tee intermediate-tls.password | base64 --wrap=0`

# Generate Root CA Certificate Pair
step certificate create \
  "${ROOT_CA_NAME}" \
  "root-tls.crt" \
  "root-tls.key" \
  --template="root-tls.json" \
  --kty="EC" \
  --curve="P-256" \
  --password-file="root-tls.password" \
  --not-before="0s" \
  --not-after="44520h"

TLS_ROOT_CRT=`cat root-tls.crt | sed 's/^/        /'`
TLS_ROOT_KEY=`cat root-tls.key | sed 's/^/        /'`

# Generate Intermediate CA Certificate Pair
step certificate create \
  "${INTERMEDIATE_CA_NAME}" \
  "intermediate-tls.crt" \
  "intermediate-tls.key" \
  --template="intermediate-tls.json" \
  --kty="EC" \
  --curve="P-256" \
  --password-file="intermediate-tls.password" \
  --not-before="0s" \
  --not-after="17760h" \
  --ca="root-tls.crt" \
  --ca-key="root-tls.key" \
  --ca-password-file="root-tls.password"

TLS_INTERMEDIATE_CRT=`cat intermediate-tls.crt | sed 's/^/        /'`
TLS_INTERMEDIATE_KEY=`cat intermediate-tls.key | sed 's/^/        /'`

# Generate SSH Host CA Password
SSH_HOST_PASSWORD=`tr -dc 'A-Za-z0-9!"#$%&'\''()*+,-./:;<=>?@[\]^_\`{|}~' </dev/urandom | head -c 64 | tee host-ssh.password`
SSH_HOST_PASSWORD_B64=`echo ${SSH_HOST_PASSWORD} | base64 --wrap=0`

# Generate SSH Host CA Keypair
ssh-keygen -q -t ecdsa -b 256 -f host-ssh.key -C "SSH Host Key" -N ${SSH_HOST_PASSWORD}

SSH_HOST_CRT=`cat host-ssh.key.pub`
SSH_HOST_KEY=`cat host-ssh.key | sed 's/^/        /'`

# Generate SSH User CA Password
SSH_USER_PASSWORD=`tr -dc 'A-Za-z0-9!"#$%&'\''()*+,-./:;<=>?@[\]^_\`{|}~' </dev/urandom | head -c 64 | tee user-ssh.password`
SSH_USER_PASSWORD_B64=`echo ${SSH_USER_PASSWORD} | base64 --wrap=0`

# Generate SSH User CA Keypair
ssh-keygen -q -t ecdsa -b 256 -f user-ssh.key -C "SSH User Key" -N ${SSH_USER_PASSWORD}

SSH_USER_CRT=`cat user-ssh.key.pub`
SSH_USER_KEY=`cat user-ssh.key | sed 's/^/        /'`

export ROOT_TLS_PASSWORD_B64 INTERMEDIATE_TLS_PASSWORD_B64 TLS_ROOT_CRT TLS_ROOT_KEY TLS_INTERMEDIATE_CRT TLS_INTERMEDIATE_KEY SSH_HOST_PASSWORD_B64 SSH_HOST_CRT SSH_HOST_KEY SSH_USER_PASSWORD_B64 SSH_USER_CRT SSH_USER_KEY

cat values.yml.tpl | envsubst | tee values.yml