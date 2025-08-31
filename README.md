# 🚀 Blockchain Lab - Kubernetes Deployment

Exercice de deploiement sur cluster k3d avec Helm de nœud blockchain Polkadot avec Prometheus et Grafana pour monitoring.
(deployment, services, statefulset, servicemonitor et networkpolicies)e

## 🔧 Configuration

### 1. Copier et personnaliser les variables

```bash
# Copier le fichier de configuration par défaut
cp values.yaml values-local.yaml

# Éditer avec vos paramètres
nano values-local.yaml
```

### 2. Variables importantes à modifier

```yaml
# Dans values-local.yaml
namespace:
  name: "your-namespace-name"  # Changez le nom du namespace

polkadot:
  nodeName: "your-node-name"   # Nom de votre nœud

monitoring:
  grafana:
    adminPassword: "your-secure-password"  # Mot de passe sécurisé
```

## 🚀 Déploiement

### 1. Générer les manifests

```bash
# Générer les manifests à partir des variables
./scripts/generate-manifests.sh values-local.yaml
```

### 2. Déployer le monitoring

```bash
# Ajouter le repo Helm
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

# Déployer Prometheus + Grafana
helm install monitoring prometheus-community/kube-prometheus-stack \
  --namespace monitoring \
  --create-namespace \
  --values monitoring/grafana/monitoring-values.yaml
```

### 3. Déployer le nœud blockchain

```bash
# Appliquer les manifests générés
kubectl apply -f k8s/
```

## 📊 Monitoring

### Accès à Grafana

```bash
# Port-forward vers Grafana
kubectl port-forward svc/monitoring-grafana 3000:80 -n monitoring
```

- **URL :** http://localhost:3000
- **Utilisateur :** admin
- **Mot de passe :** Celui configuré dans values-local.yaml

### Métriques disponibles

- Métriques du nœud Polkadot sur le port 9615
- Métriques Kubernetes standard
- Dashboards Grafana préconfigurés

## 🔒 Sécurité

### Fichiers sensibles

- `values-local.yaml` - Contient vos configurations personnelles
- `*.key`, `*.pem`, `*.crt` - Certificats et clés
- `.kube/` - Configuration kubectl

Ces fichiers sont automatiquement exclus par `.gitignore`.

### Ajouter de nouveaux services

1. Créer un template dans `k8s-templates/`
2. Ajouter les variables dans `values.yaml`
3. Générer avec `./scripts/generate-manifests.sh`

