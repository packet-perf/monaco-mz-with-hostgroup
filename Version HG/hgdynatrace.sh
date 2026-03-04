#!/usr/bin/env bash

# [0/3] CHARGEMENT ET VÉRIFICATION
if [ -f .env ]; then
    set -a
    source .env
    set +a
else
    echo "❌ ERREUR : Fichier .env introuvable"
    exit 1
fi

if [ ! -f tmp/hg.json ]; then
    echo "❌ ERREUR : tmp/hg.json introuvable"
    exit 1
fi

# Extraction du Host Group
export HG_NAME=$(jq -r '.hostgroup' tmp/hg.json)
export NEW_CLI=1

# ==============================================================================
# [1/3] EXPORTS POUR TOUTES LES VARIABLES MONACO (Vérifiés)
# ==============================================================================
# On définit TOUT avec la valeur du HG pour éviter les erreurs de mapping
export monHostGroup="$HG_NAME"
export monNamespace="$HG_NAME"
export monEntityName="$HG_NAME"  # <--- Correction de ton erreur actuelle
export monDomaine="$HG_NAME"

# Compatibilité anciennes variables au cas où
export namespace="$HG_NAME"
export domaine="$HG_NAME"

echo "🚀 Préparation de la MZ pour le Host Group : $HG_NAME"

# ==============================================================================
# [2/3] DÉPLOIEMENT
# ==============================================================================
rm -rf .state

echo ">>> [HPROD] Création de la Management Zone..."
monaco deploy MHIS.yaml --environment MHIS.Horsprod --project step1

echo ">>> [PROD] Création de la Management Zone..."
monaco deploy MHIS.yaml --environment MHIS.Prod --project step1

echo "---"
echo "✅ Terminé : La Management Zone '$HG_NAME' est déployée."