#!/bin/bash
#SBATCH -t 0-1:00
#SBATCH -p gpu,gpu_quad,gpu_requeue 
#SBATCH --qos=gpuquad_qos
#SBATCH --gres=gpu:1
#SBATCH --mem=20G
#SBATCH -o CA_trancepteve_%j.out
#SBATCH -e CA_trancepteve_%j.err
#SBATCH -J CA_te
#SBATCH --account=marks

module load conda/miniforge3/24.11.3-0
mamba activate /n/groups/marks/projects/marks_lab_and_oatml/ProteinGym2/model_envs/tranception

root=/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym2
script_dir=/n/groups/marks/users/elain/PG2/ProteinGym/proteingym/baselines/trancepteve
export checkpoint=/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/baseline_models/Tranception/Tranception_Large/
output_scores_folder=${root}/model_scores/zero_shot_substitutions/
export output_scores_folder=${output_scores_folder}/TranceptEVE_L/

# Replace the following paths based on where you store models and data
export DMS_index=256
export inference_time_retrieval_type="TranceptEVE"
export EVE_num_samples_log_proba=200000 
export EVE_model_parameters_location="/n/groups/marks/users/elain/PG2/ProteinGym/proteingym/baselines/trancepteve/trancepteve/utils/eve_model_default_params.json"
export EVE_seeds="42 1000 2000 3000 4000"
export scoring_window="optimal" 
python ${script_dir}/score_trancepteve.py \
    --checkpoint ${checkpoint} \
    --DMS_reference_file_path ${root}/reference_files/pg2_reference_current.csv \
    --DMS_data_folder /n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/DMS_assays/DMS_ProteinGym_substitutions_PG2/ \
    --DMS_index ${DMS_index} \
    --output_scores_folder ${output_scores_folder} \
    --inference_time_retrieval_type ${inference_time_retrieval_type} \
    --MSA_folder /n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/MSA_files/PG_repo/DMS_MSA_PG2/ \
    --MSA_weights_folder /n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/MSA_weights/PG_repo/DMS_msa_weights_PG2/ \
    --EVE_num_samples_log_proba ${EVE_num_samples_log_proba} \
    --EVE_model_parameters_location ${EVE_model_parameters_location} \
    --EVE_model_folder ${root}/DMS_EVE_models \
    --scoring_window ${scoring_window} \
    --EVE_seeds ${EVE_seeds} \
    --EVE_recalibrate_probas