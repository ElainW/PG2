#!/bin/bash
#SBATCH --job-name=poet2_dms_indels
#SBATCH --partition=gpu,gpu_quad
#SBATCH --qos=gpuquad_qos
#SBATCH --gres=gpu:l40s:1
#SBATCH --mem=8G
#SBATCH -c 1
#SBATCH --time=0-03:00
#SBATCH --output=logs/poet2_dms_indels_tier4_%A.out
#SBATCH --error=logs/poet2_dms_indels_tier4_%A.err

export PATH="/home/jar2158/.pixi/bin:$PATH"
cd ProteinGym/scripts/scoring_DMS_zero_shot/

for i in {0..5} {9..22} {39..65}; do
    DMS_index=$i bash scoring_PoET_2_indels.sh
done

