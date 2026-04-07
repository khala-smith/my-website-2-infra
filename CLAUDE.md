# my-website-2-infra

## Overview

Infrastructure-as-code repository for **my-website-2**. Uses ArgoCD with Helm charts for GitOps-based continuous delivery to Kubernetes.

## Structure

```
chart/           # Helm chart (templates + default values)
environments/    # Per-environment overrides + ArgoCD Application CRs
  dev/
  staging/
  production/
```

## Commands

| Command | Description |
|---------|-------------|
| `make lint` | Lint Helm chart |
| `make template` | Render templates locally |
| `make template-dev` | Render for a specific env |
| `make diff` | Diff against live cluster |

## Conventions

- One ArgoCD `Application` CR per environment in `environments/<env>/application.yaml`.
- Environment-specific overrides go in `environments/<env>/values.yaml`.
- Shared defaults stay in `chart/values.yaml`.
- All changes are deployed via Git merge — no manual `helm install`.

## Deployment Pipeline

The app repo (`my-website-2`) CI automatically deploys to **dev** on merge to `main`:

1. CI runs lint/test/build
2. Docker image is built and pushed to `ghcr.io/khala-smith/my-website-2`
3. The `deploy-dev` job updates `environments/dev/values.yaml` image tag in this repo
4. ArgoCD detects the commit and syncs the new image to the dev cluster

### Required Setup

A `DEPLOY_TOKEN` secret must be configured in the **app repo** (`my-website-2`):
- Create a GitHub PAT with `repo` scope
- Add it as a repository secret named `DEPLOY_TOKEN` in `khala-smith/my-website-2` → Settings → Secrets

### Promoting to Staging/Production

Staging and production deployments are manual:
1. Copy the image tag (SHA) from `environments/dev/values.yaml`
2. Update `environments/<env>/values.yaml` with the new tag
3. Commit and push — ArgoCD will sync automatically
