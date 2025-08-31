# 🚀 Blockchain Lab - Kubernetes Deployment

Un laboratoire Kubernetes pour déployer et monitorer un nœud blockchain Polkadot avec Prometheus et Grafana.

## 📋 Prérequis

- Kubernetes cluster (k3d, minikube, ou cloud)
- kubectl configuré
- Helm (pour le monitoring)

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

### Bonnes pratiques

1. **Ne jamais commiter** `values-local.yaml` ou fichiers contenant des secrets
2. **Utiliser des mots de passe forts** pour Grafana
3. **Limiter l'accès réseau** avec les NetworkPolicies
4. **Surveiller les logs** régulièrement

## 🛠️ Développement

### Structure du projet

```
forfun-3-k8s-blockchain/
├── k8s/                    # Manifests générés
├── k8s-templates/          # Templates (optionnel)
├── monitoring/             # Configuration monitoring
├── scripts/                # Scripts utilitaires
├── values.yaml             # Configuration par défaut
├── values-local.yaml       # Configuration locale (ignoré par git)
└── README.md              # Ce fichier
```

### Ajouter de nouveaux services

1. Créer un template dans `k8s-templates/`
2. Ajouter les variables dans `values.yaml`
3. Générer avec `./scripts/generate-manifests.sh`

## 🐛 Dépannage

### Problèmes courants

**Pod en ImagePullBackOff :**
```bash
# Vérifier la connectivité réseau
kubectl describe pod <pod-name>
```

**Problèmes de stockage :**
```bash
# Vérifier les PVC
kubectl get pvc
kubectl describe pvc <pvc-name>
```

**Problèmes de monitoring :**
```bash
# Vérifier les ServiceMonitors
kubectl get servicemonitors
kubectl describe servicemonitor <name>
```

## 📝 Licence

Ce projet est fourni à des fins éducatives. Utilisez à vos propres risques en production.

## 🤝 Contribution

Les contributions sont les bienvenues ! Assurez-vous de :

1. Ne pas inclure d'informations sensibles
2. Tester vos modifications
3. Documenter les changements
