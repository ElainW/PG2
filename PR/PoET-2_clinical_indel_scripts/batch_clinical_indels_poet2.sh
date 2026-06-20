#!/bin/bash
#SBATCH --job-name=poet2_clinical_indels
#SBATCH --partition=gpu,gpu_quad
#SBATCH --qos=gpuquad_qos
#SBATCH --gres=gpu:l40s:1
#SBATCH --mem=10G
#SBATCH -c 1
#SBATCH --time=0-00:05:00
#SBATCH --array=116
#SBATCH --output=logs/poet2_clinical_indels_%A_%a.out
#SBATCH --error=logs/poet2_clinical_indels_%A_%a.err

export PATH="/home/jar2158/.pixi/bin:$PATH"
cd ProteinGym/scripts/scoring_clinical_zero_shot/
DMS_index=$SLURM_ARRAY_TASK_ID bash scoring_PoET_2_indels.sh