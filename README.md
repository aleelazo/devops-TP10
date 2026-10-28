# TP 10 — Kubernetes avanzado: Helm + Ingress

## Estructura del Chart

```text
devops-portfolio/
├── Chart.yaml
├── values.yaml
├── values-dev.yaml
├── values-prod.yaml
└── templates/
    ├── _helpers.tpl
    ├── namespace.yaml
    ├── secret.yaml
    ├── configmap.yaml
    ├── postgres.yaml
    ├── backend.yaml
    ├── frontend.yaml
    ├── ingress.yaml
    └── NOTES.txt
```

## Comandos principales

Validar el chart:

```bash
helm lint devops-portfolio/
```

Ver los manifests generados:

```bash
helm template mi-app devops-portfolio/ \
  --values devops-portfolio/values-dev.yaml
```

Instalar:

```bash
helm install mi-app devops-portfolio/ \
  --values devops-portfolio/values-dev.yaml \
  --namespace devops-portfolio
```

Actualizar:

```bash
helm upgrade mi-app devops-portfolio/ \
  --values devops-portfolio/values-dev.yaml \
  --namespace devops-portfolio
```

Rollback:

```bash
helm rollback mi-app 2 -n devops-portfolio
```

Desinstalar:

```bash
helm uninstall mi-app -n devops-portfolio
```

## Ingress: routing por paths

| Path | Servicio destino |
|---|---|
| `/` | frontend-service:80 |
| `/api` | backend-service:5000 |
| `/health` | backend-service:5000 |

## Multi-entorno

Desarrollo:

```bash
helm upgrade --install mi-app devops-portfolio/ \
  --values devops-portfolio/values-dev.yaml \
  --namespace devops-portfolio
```

Producción:

```bash
helm upgrade --install mi-app-prod devops-portfolio/ \
  --values devops-portfolio/values-prod.yaml \
  --namespace devops-portfolio-prod \
  --create-namespace
```

## Verificación

```bash
bash scripts/verificar.sh
```
