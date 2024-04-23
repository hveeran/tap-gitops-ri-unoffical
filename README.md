# Tanzu GitOps Reference Implementation

Use this archive contains an opinionated approach to implementing GitOps workflows on Kubernetes clusters.

This reference implementation is pre-configured to install Tanzu Application Platform.

For detailed documentation, refer to [VMware Tanzu Application Platform Product Documentation](https://docs.vmware.com/en/VMware-Tanzu-Application-Platform/1.9/tap/install-gitops-intro.html).

## Added Azure Key Vault as an ESO provider

- Only support service principal
- TODO: Update `tap-gitops-ri-unoffical/.catalog/tanzu-sync/0.5.0/azurekv/scripts/bootstrap.sh` to add Azure service principal `clientId` and `clientSecret` as a kuberentes secret

        kubectl -n tanzu-sync create secret generic azure-secret-sp --from-literal=ClientID="xxxx" --from-literal=ClientSecret="xxx"

        kubectl -n tap-install create secret generic azure-secret-sp --from-literal=ClientID="xxx" --from-literal=ClientSecret="xxx"

