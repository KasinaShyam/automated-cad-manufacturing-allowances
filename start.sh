#!/bin/bash
set -e
echo ""
echo "====================================================="
echo "  CastingApp  -  ME222 IITG"
echo "====================================================="
echo ""

# Activate conda
source "$(conda info --base)/etc/profile.d/conda.sh" 2>/dev/null || true
conda activate casting_app

cd "$(dirname "$0")/backend"
python app.py
