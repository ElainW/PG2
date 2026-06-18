#!/bin/bash
#SBATCH -t 0-6:00
#SBATCH -p gpu,gpu_quad,gpu_requeue 
#SBATCH --qos=gpuquad_qos
#SBATCH --gres=gpu:1
#SBATCH --mem=20G
#SBATCH -o CA_eve_4000_%j.out
#SBATCH -e CA_eve_4000_%j.err
#SBATCH -J CA_eve_4000
#SBATCH --account=marks

module load conda/miniforge3/24.11.3-0
mamba activate /n/groups/marks/projects/marks_lab_and_oatml/ProteinGym2/model_envs/eve

export random_seeds="4000" # put in five different numbers each time and run

root=/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym2
script_dir=/n/groups/marks/users/elain/PG2/ProteinGym/proteingym/baselines/EVE
DMS_data_folder_subs=/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/DMS_assays/DMS_ProteinGym_substitutions_PG2/

python ${script_dir}/train_VAE.py \
    --MSA_data_folder /n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/MSA_files/PG_repo/DMS_MSA_PG2/ \
    --DMS_reference_file_path /n/groups/marks/projects/marks_lab_and_oatml/ProteinGym2/reference_files/pg2_reference_current.csv \
    --protein_index 256 \
    --MSA_weights_location /n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/MSA_weights/PG_repo/DMS_msa_weights_PG2/ \
    --VAE_checkpoint_location ${root}/DMS_EVE_models \
    --model_parameters_location ${script_dir}/EVE/default_model_params.json \
    --training_logs_location ${root}/DMS_EVE_models/logs/ \
    --threshold_focus_cols_frac_gaps 1 \
    --seed ${random_seeds} \
    --skip_existing \
    --experimental_stream_data \
    --force_load_weights


export computation_mode='DMS'
export num_samples_compute_evol_indices=20000
export batch_size=1024  # Pushing batch size to limit of GPU memory

python ${script_dir}/compute_evol_indices_DMS.py \
    --MSA_data_folder /n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/MSA_files/PG_repo/DMS_MSA_PG2/ \
    --DMS_reference_file_path /n/groups/marks/projects/marks_lab_and_oatml/ProteinGym2/reference_files/pg2_reference_current.csv \
    --protein_index 256 \
    --VAE_checkpoint_location ${root}/DMS_EVE_models \
    --model_parameters_location ${script_dir}/EVE/default_model_params.json \
    --DMS_data_folder ${DMS_data_folder_subs} \
    --output_scores_folder ${root}/model_scores/zero_shot_substitutions/EVE/ \
    --num_samples_compute_evol_indices ${num_samples_compute_evol_indices} \
    --batch_size ${batch_size} \
    --aggregation_method "full" \
    --threshold_focus_cols_frac_gaps 1 \
    --skip_existing \
    --MSA_weights_location /n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/MSA_weights/PG_repo/DMS_msa_weights_PG2/ \
    --random_seeds 42 1000 2000 3000 4000 # put in all five different numbers