# dpop-demo-gitops

Estado desejado do [dpop-demo](https://github.com/carlos-carmo-ds/dpop-demo) no cluster k3d local,
aplicado pelo **Argo CD**. As tags das imagens são atualizadas pelo **Argo CD Image Updater**.

```
dpop-demo (código) ──push──► GitHub Actions ──► ghcr.io/.../dpop-demo-{api,web}:1.0.<run>
                                                        │
                       Image Updater (no cluster) observa o GHCR
                                                        │ commit da tag nova
                                                        ▼
                         este repo: envs/dev/values.yaml
                                                        │ Argo CD (polling ~3 min)
                                                        ▼
                         k3d-lab, namespace dpop-demo → http://dpop.localhost:9080
```

## Estrutura

| Caminho | Conteúdo |
|---|---|
| `charts/dpop-demo/` | Helm chart: Deployments e Services de `api` e `web` + Ingress (Traefik) |
| `envs/dev/values.yaml` | Valores do ambiente local (URLs, tags das imagens) |
| `argocd/application.yaml` | Application do Argo CD (Helm, sync automático, prune, self-heal) |
| `argocd/image-updater.yaml` | `ImageUpdater` (semver, tags `1.0.N`, write-back em `envs/dev/values.yaml`) |

## Testar o chart localmente

```bash
helm lint charts/dpop-demo -f envs/dev/values.yaml
helm template dpop-demo charts/dpop-demo -f envs/dev/values.yaml
```

## Notas

- **Não edite as tags à mão** em `envs/dev/values.yaml`: o Image Updater sobrescreve com a mais nova.
- A API fica com **1 réplica**: o cache anti-replay do DPoP (`jti`) é em memória.
- O Keycloak roda fora do cluster (docker compose no Mac). A API busca o JWKS em
  `host.k3d.internal:8080`, e o issuer continua `http://localhost:8080/realms/dpop-demo`.
