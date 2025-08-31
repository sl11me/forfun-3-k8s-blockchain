#!/bin/bash

# Script de nettoyage pour le lab blockchain
# Usage: ./scripts/cleanup.sh [namespace]

set -e

NAMESPACE="${1:-blockchain-lab}"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}🧹 Nettoyage du namespace: $NAMESPACE${NC}"

# Vérifier si le namespace existe
if ! kubectl get namespace "$NAMESPACE" >/dev/null 2>&1; then
    echo -e "${RED}❌ Namespace $NAMESPACE n'existe pas${NC}"
    exit 1
fi

# Confirmation
read -p "Êtes-vous sûr de vouloir supprimer toutes les ressources dans $NAMESPACE ? (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo -e "${YELLOW}❌ Nettoyage annulé${NC}"
    exit 0
fi

echo -e "${GREEN}🗑️  Suppression des ressources...${NC}"

# Supprimer les StatefulSets
kubectl delete statefulset --all -n "$NAMESPACE" --ignore-not-found=true

# Supprimer les Deployments
kubectl delete deployment --all -n "$NAMESPACE" --ignore-not-found=true

# Supprimer les Services
kubectl delete service --all -n "$NAMESPACE" --ignore-not-found=true

# Supprimer les PVC
kubectl delete pvc --all -n "$NAMESPACE" --ignore-not-found=true

# Supprimer les ServiceMonitors
kubectl delete servicemonitor --all -n "$NAMESPACE" --ignore-not-found=true

# Supprimer les NetworkPolicies
kubectl delete networkpolicy --all -n "$NAMESPACE" --ignore-not-found=true

# Supprimer le namespace
kubectl delete namespace "$NAMESPACE" --ignore-not-found=true

echo -e "${GREEN}✅ Nettoyage terminé !${NC}"

# Nettoyer aussi le monitoring si demandé
read -p "Voulez-vous aussi nettoyer le monitoring ? (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo -e "${GREEN}🗑️  Suppression du monitoring...${NC}"
    helm uninstall monitoring -n monitoring --ignore-not-found=true
    kubectl delete namespace monitoring --ignore-not-found=true
    echo -e "${GREEN}✅ Monitoring supprimé !${NC}"
fi
