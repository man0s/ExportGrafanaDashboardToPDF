# Grafana PDF Exporter — Helm Chart

## Quick Start

```bash
# Install the chart
helm install grafana-pdf-exporter ./chart/grafana-pdf-exporter \
  --set grafana.user=myuser \
  --set grafana.password=mypassword

# Or using an existing Kubernetes secret
helm install grafana-pdf-exporter ./chart/grafana-pdf-exporter \
  --set existingSecret=my-grafana-secret

# Override with a different image tag
helm install grafana-pdf-exporter ./chart/grafana-pdf-exporter \
  --set image.tag=0.0.1
```

## Configuration

See `values.yaml` for the full list of configurable parameters.

### Grafana Authentication

Set credentials directly:
```bash
--set grafana.user=myuser --set grafana.password=mypassword
```

Or use an existing Kubernetes secret:
```bash
--set existingSecret=my-secret
# Expects keys: username, password, serviceAccount (optional)
```

### Accessing the service

```bash
# Port-forward to localhost
kubectl port-forward svc/grafana-pdf-exporter 3001:3001

# Then send a request
curl -X POST http://localhost:3001/generate-pdf \
  -H "Content-Type: application/json" \
  -d '{ "url": "http://grafana.your-cluster/d/your-dashboard" }'
```
