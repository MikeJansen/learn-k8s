#!/bin/env bash

echo '---------------------------------------------------------------'
echo 'Step 6 - gen-encrypt.sh'
echo '---------------------------------------------------------------'

source ../common/get-vars.sh

mkdir -p ../artifacts/encrypt
rm -f ../artifacts/encrypt/*
pushd ../artifacts/encrypt

ENCRYPTION_KEY=$(head -c 32 /dev/urandom | base64)

cat > encryption-config.yaml <<EOF
kind: EncryptionConfig
apiVersion: v1
resources:
  - resources:
      - secrets
    providers:
      - aescbc:
          keys:
            - name: key1
              secret: ${ENCRYPTION_KEY}
      - identity: {}
EOF

for instance in $TF_CP_LIST; do
  gcloud compute scp encryption-config.yaml ${instance}:~/
done

popd
