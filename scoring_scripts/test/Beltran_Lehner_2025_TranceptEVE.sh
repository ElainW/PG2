#!/bin/bash
#SBATCH -t 0-03:00
#SBATCH -p gpu,gpu_quad 
#SBATCH --qos=gpuquad_qos
#SBATCH --gres=gpu:1
#SBATCH --mem=50G
#SBATCH -o slurm/bl_trancepteve_%A_%a.out
#SBATCH -e slurm/bl_trancepteve_%A_%a.err
#SBATCH -J bl_te
#SBATCH --array=341,343,380,381
#SBATCH --account=marks

# most jobs finish within 30 min 30G

module load conda/miniforge3/24.11.3-0
mamba activate /n/groups/marks/projects/marks_lab_and_oatml/ProteinGym2/model_envs/tranception

source Beltran_Lehner_2025_zero_shot_config.sh
export checkpoint=/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/baseline_models/Tranception/Tranception_Large/
export output_scores_folder=${DMS_output_score_folder_subs}/TranceptEVE_L/

# Replace the following paths based on where you store models and data
export inference_time_retrieval_type="TranceptEVE"
export EVE_num_samples_log_proba=200000 
export EVE_seeds="1000 2000 3000 4000 5000"
export scoring_window="optimal" 
python ${SCRIPT_DIR}/trancepteve/score_trancepteve.py \
    --checkpoint ${checkpoint} \
    --DMS_reference_file_path ${DMS_reference_file_path_subs} \
    --DMS_data_folder ${DMS_data_folder_subs} \
    --DMS_index $SLURM_ARRAY_TASK_ID \
    --output_scores_folder ${output_scores_folder} \
    --inference_time_retrieval_type ${inference_time_retrieval_type} \
    --MSA_folder ${DMS_MSA_data_folder} \
    --MSA_weights_folder ${DMS_MSA_weights_folder} \
    --EVE_num_samples_log_proba ${EVE_num_samples_log_proba} \
    --EVE_model_parameters_location ${EVE_model_parameters_location} \
    --EVE_model_folder ${EVE_model_folder} \
    --scoring_window ${scoring_window} \
    --EVE_seeds ${EVE_seeds} \
    --EVE_recalibrate_probas
