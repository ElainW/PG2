#!/bin/bash
#SBATCH --job-name=poet2_dms_subs
#SBATCH --partition=gpu,gpu_quad
#SBATCH --qos=gpuquad_qos
#SBATCH --gres=gpu:l40s:1
#SBATCH --mem=20G
#SBATCH -c 1
#SBATCH --time=24:00:00
#SBATCH --array=1-216%20
#SBATCH --output=logs/poet2_dms_subs_%A_%a.out
#SBATCH --error=logs/poet2_dms_subs_%A_%a.err

DMS_index=$SLURM_ARRAY_TASK_ID bash ProteinGym/scripts/scoring_DMS_zero_shot/scoring_PoET_2_substitutions.sh