# DevOps Portfolio — TP10C: Entrega Continua con Helm Multi-Entorno

![Helm CD Pipeline](https://github.com/aleelazo/devops-TP10/actions/workflows/helm-cd.yml/badge.svg)

Pipeline de Entrega Continua gobernado por **Helm**, aplicando el patrón **Render First, Validate Second** (TP10B), compuertas de aprobación manual y reversión automática ante fallos de despliegue.

## Releases y Entornos

| Release | Namespace | Archivo Values | Réplicas BE | Ingress Host | Aprobación |
|---|---|---|---|---|---|
| `notes-staging` | `staging` | `values-staging.yaml` | 1 | `staging.devops-portfolio.local` | Automática |
| `notes-prod` | `production` | `values-prod.yaml` | 3 (HPA) | `devops-portfolio.com` | Manual Gate |

## Operaciones de Despliegue y Rollback

### Validar renderizado previo localmente (Técnica TP10B)

```bash
bash scripts/render-validate.sh
```

### Actualizar release manualmente

```bash
helm upgrade --install notes-prod ./devops-portfolio -f devops-portfolio/values-prod.yaml -n production
```

### Historial de versiones del release

```bash
helm history notes-prod -n production
```

### Rollback a la versión anterior inmediata

```bash
helm rollback notes-prod 0 -n production
```

### Auditoría automatizada

```bash
bash scripts/verificar-helm-entornos.sh
```
