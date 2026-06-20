#!/bin/bash
#SBATCH --job-name=poet2_dms_subs
#SBATCH --partition=gpu,gpu_quad
#SBATCH --qos=gpuquad_qos
#SBATCH --gres=gpu:l40s:1
#SBATCH --mem=8G
#SBATCH -c 1
#SBATCH --time=0-1:00:00
#SBATCH --array=1-27,29-72,74-121,123-127,129-180,183-216
#SBATCH --output=logs/poet2_dms_subs_%A_%a.out
#SBATCH --error=logs/poet2_dms_subs_%A_%a.err
export PATH="/home/jar2158/.pixi/bin:$PATH"
cd ProteinGym/scripts/scoring_DMS_zero_shot/
DMS_index=$SLURM_ARRAY_TASK_ID bash scoring_PoET_2_substitutions.sh
