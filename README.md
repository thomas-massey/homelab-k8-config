# homelab-k8-config

Argo CD manifests for a 3-node Kubernetes homelab with:

- NGINX website
- ingress-nginx controller
- cert-manager TLS management
- Bitnami Sealed Secrets for secret management

## What this repo deploys

- `argocd/root-application.yaml`: app-of-apps entrypoint
- `argocd/bootstrap/apps/ingress-nginx.yaml`: ingress controller
- `argocd/bootstrap/apps/cert-manager.yaml`: certificate manager
- `argocd/bootstrap/apps/sealed-secrets.yaml`: Bitnami Sealed Secrets controller
- `argocd/bootstrap/apps/nginx-hello.yaml`: NGINX workload app
- `apps/nginx-hello/base/*`: website deployment, service, ingress, issuer, cert, sealed secret

## Bootstrap in Argo CD

Apply the root app once:

```bash
kubectl apply -f argocd/root-application.yaml
```

After that, Argo CD syncs everything automatically.

## Required edits before production use

1. Update your hostname:
   - Replace `nginx.example.com` in `apps/nginx-hello/base/ingress.yaml`
   - Replace `nginx.example.com` in `apps/nginx-hello/base/certificate.yaml`
2. Update cert-manager email in `apps/nginx-hello/base/cluster-issuer.yaml`
3. Generate and commit a real SealedSecret:

```bash
chmod +x scripts/seal-hello-secret.sh
./scripts/seal-hello-secret.sh "Hello from my homelab"
```

This overwrites `apps/nginx-hello/base/sealed-secret.yaml` with a valid encrypted value for your cluster key.

## DNS and access

Point your DNS record for the host to your ingress controller external IP.

Then browse:

```text
https://nginx.example.com
```

You should see the NGINX page showing the hello-world value pulled from the Bitnami-managed secret.