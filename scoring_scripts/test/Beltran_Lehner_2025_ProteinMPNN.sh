#!/bin/bash
#SBATCH -t 0-09:00
#SBATCH -p gpu,gpu_quad,gpu_requeue 
#SBATCH --qos=gpuquad_qos
#SBATCH --gres=gpu:1
#SBATCH --mem=8G
#SBATCH -o BL_ProteinMPNN_%j.out
#SBATCH -e BL_ProteinMPNN_%j.err
#SBATCH -J BL_ProteinMPNN
#SBATCH --account=marks

module load conda/miniforge3/24.11.3-0
mamba activate /n/groups/marks/projects/marks_lab_and_oatml/ProteinGym2/model_envs/proteinmpnn

source Beltran_Lehner_2025_zero_shot_config.sh

export output_scores_folder=${DMS_output_score_folder_subs}/ProteinMPNN
mkdir -p ${output_scores_folder}

export model_checkpoint=/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/baseline_models/ProteinMPNN/v_48_020.pt

for i in {0..518}; do
    python ${SCRIPT_DIR}/protein_mpnn/compute_fitness.py \
        --checkpoint ${model_checkpoint} \
        --structure_folder ${DMS_structure_folder} \
        --DMS_index $i \
        --DMS_reference_file_path ${DMS_reference_file_path_subs} \
        --DMS_data_folder ${DMS_data_folder_subs} \
        --output_scores_folder ${output_scores_folder}
done