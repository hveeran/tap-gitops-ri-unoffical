#!/usr/bin/env bash
set -o errexit -o nounset -o pipefail
#set -o xtrace

function usage() {
  cat << EOF
$0 :: configure Tanzu Sync for use with External Secrets Operator (ESO)

Required Environment Variables:
- TENANT_ID -- Azure tenant ID
- VAULT_URL -- Azure Key Vault URL
- AUTH_SECRET_NAME -- Name of the kubernetes secret where client id and client secret is stored
- CLIENT_ID_KEY --  Key in the secret for Client id 
- CLIENT_SECRET_KEY -- Key in the secret for Client secret 

EOF
}

error_msg="Expected env var to be set, but was not."
: "${TENANT_ID?$error_msg}"
: "${VAULT_URL?$error_msg}"
: "${AUTH_SECRET_NAME?$error_msg}"
: "${CLIENT_ID_KEY?$error_msg}"
: "${CLIENT_SECRET_KEY?$error_msg}"

# configure
# (see: tanzu-sync/app/config/.tanzu-managed/schema.yaml)
ts_values_path=tanzu-sync/app/values/tanzu-sync-vault-values.yaml
cat > ${ts_values_path} << EOF
---
secrets:
  eso:
      azurekv:
        tenantId: ${TENANT_ID}
        vaultUrl: ${VAULT_URL}
        authSecretRef:
          clientId:
            name: ${AUTH_SECRET_NAME}
            key: ${CLIENT_ID_KEY}
          clientSecret:
            name: ${AUTH_SECRET_NAME}
            key: ${CLIENT_SECRET_KEY}
      remote_refs:
        sync_git:
          # TODO: Fill in your configuration for ssh or basic auth here (see tanzu-sync/app/config/.tanzu-managed/schema--eso.yaml)
        install_registry_dockerconfig:
          dockerconfigjson:
            key: ${CLUSTER_NAME}-install-registry-dockerconfig
EOF

echo "wrote ESO configuration for Tanzu Sync to: ${ts_values_path}"

tap_install_values_path=cluster-config/values/tap-install-vault-values.yaml
cat > ${tap_install_values_path} << EOF
---
tap_install:
  secrets:
    eso:
      azurekv:
        tenantId: ${TENANT_ID}
        vaultUrl: ${VAULT_URL}
        authSecretRef:
          clientId:
            name: ${AUTH_SECRET_NAME}
            key: ${CLIENT_ID_KEY}
          clientSecret:
            name: ${AUTH_SECRET_NAME}
            key: ${CLIENT_SECRET_KEY}
      remote_refs:
        tap_sensitive_values:
          sensitive_tap_values_yaml:
            key: ${CLUSTER_NAME}-sensitive-values.yaml
EOF

echo "wrote Vault configuration for TAP install to: ${tap_install_values_path}"
echo ""
echo "Please edit '${ts_values_path}' filling in values for each 'TODO' comment"