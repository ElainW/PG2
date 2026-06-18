#!/bin/bash
#SBATCH -t 1-00:00
#SBATCH -p gpu,gpu_quad 
#SBATCH --qos=gpuquad_qos
#SBATCH --gres=gpu:1
#SBATCH --mem=20G
#SBATCH -o bl_EVE_%A_%a.out
#SBATCH -e bl_EVE_%A_%a.err
#SBATCH -J bl_EVE
#SBATCH --array=6
#SBATCH --account=marks

module load conda/miniforge3/24.11.3-0
mamba activate /n/groups/marks/projects/marks_lab_and_oatml/ProteinGym2/model_envs/eve

root=/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym2
script_dir=/n/groups/marks/users/elain/PG2/ProteinGym/proteingym/baselines/EVE
DMS_data_folder_subs=${root}/DMS_assays/processed_data/Beltran_Lehner_2025/cleaned

for seed in 1000 2000 3000 4000 5000; do
    python ${script_dir}/train_VAE.py \
        --MSA_data_folder ${root}/EVCouplings/output/Beltran_Lehner_2025/selected_alignments \
        --DMS_reference_file_path ${root}/EVCouplings/output/Beltran_Lehner_2025/temp_ref_file.csv \
        --protein_index $SLURM_ARRAY_TASK_ID \
        --MSA_weights_location ${root}/EVCouplings/output/Beltran_Lehner_2025/weights/no_threshold_focus_cols_frac_gaps \
        --VAE_checkpoint_location ${root}/DMS_EVE_models/no_threshold_focus_cols_frac_gaps/ \
        --model_parameters_location ${script_dir}/EVE/default_model_params.json \
        --training_logs_location ${root}/DMS_EVE_models/no_threshold_focus_cols_frac_gaps/logs/ \
        --threshold_focus_cols_frac_gaps 1.0 \
        --seed $seed \
        --skip_existing \
        --experimental_stream_data \
        --force_load_weights
done


export computation_mode='DMS'
export num_samples_compute_evol_indices=20000
export batch_size=1024  # Pushing batch size to limit of GPU memory

python ${script_dir}/compute_evol_indices_DMS.py \
    --MSA_data_folder ${root}/EVCouplings/output/Beltran_Lehner_2025/selected_alignments \
    --DMS_reference_file_path ${root}/EVCouplings/output/Beltran_Lehner_2025/temp_ref_file.csv \
    --protein_index $SLURM_ARRAY_TASK_ID \
    --VAE_checkpoint_location ${root}/DMS_EVE_models/no_threshold_focus_cols_frac_gaps/ \
    --model_parameters_location ${script_dir}/EVE/default_model_params.json \
    --DMS_data_folder ${DMS_data_folder_subs} \
    --output_scores_folder ${root}/model_scores/zero_shot_substitutions/EVE_no_threshold_focus_cols_frac_gaps/ \
    --num_samples_compute_evol_indices ${num_samples_compute_evol_indices} \
    --batch_size ${batch_size} \
    --aggregation_method "full" \
    --threshold_focus_cols_frac_gaps 1.0 \
    --skip_existing \
    --MSA_weights_location ${root}/EVCouplings/output/Beltran_Lehner_2025/weights/no_threshold_focus_cols_frac_gaps \
    --random_seeds 1000 2000 3000 4000 5000
