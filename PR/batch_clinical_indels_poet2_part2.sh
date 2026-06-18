#!/bin/bash
#SBATCH --job-name=poet2_clinical_indels_2
#SBATCH --partition=gpu,gpu_quad
#SBATCH --qos=gpuquad_qos
#SBATCH --gres=gpu:l40s:1
#SBATCH --mem=10G
#SBATCH -c 1
#SBATCH --time=0-06:00
#SBATCH --output=logs/poet2_clinical_indels_part2_%j.out
#SBATCH --error=logs/poet2_clinical_indels_part2_%j.err

export PATH="/home/jar2158/.pixi/bin:$PATH"
cd ProteinGym/scripts/scoring_clinical_zero_shot/
for i in {778..1554}; do
    DMS_index=$i bash scoring_PoET_2_indels.sh
done