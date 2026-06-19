#!/bin/bash
#SBATCH --job-name=poet2_indel_rerun
#SBATCH --partition=gpu
#SBATCH --gres=gpu:l40s:1
#SBATCH --mem=12G
#SBATCH --cpus-per-task=1
#SBATCH --time=03:30:00
#SBATCH --output=logs/poet2_clinical_indels_rerun_%j.out
#SBATCH --error=logs/poet2_clinical_indels_rerun_%j.err

export PATH="$HOME/.pixi/bin:$PATH"
mkdir -p logs
cd ../ProteinGym/scripts/scoring_clinical_zero_shot/

INDICES=(1251 1267 1410 1423 1436 1449 1460 1464 1478 1484 1493 1501 1504 1505 1516 1517 1518 1527 1528 1529 1539 1540 1541 1547 1553 1554)
for DMS_index in "${INDICES[@]}"; do
    DMS_index=$DMS_index bash scoring_PoET_2_indels.sh
done
