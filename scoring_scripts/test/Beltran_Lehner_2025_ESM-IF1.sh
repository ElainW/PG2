#!/bin/bash
#SBATCH -t 1-00:00
#SBATCH -p gpu,gpu_quad,gpu_requeue 
#SBATCH --qos=gpuquad_qos
#SBATCH --gres=gpu:1
#SBATCH --mem=8G
#SBATCH -o beltran_esmif_%j.out
#SBATCH -e beltran_esmif_%j.err
#SBATCH -J beltran_esmif
#SBATCH --account=marks

module load conda/miniforge3/24.11.3-0
mamba activate /n/groups/marks/projects/marks_lab_and_oatml/ProteinGym2/model_envs/esm

source Beltran_Lehner_2025_zero_shot_config.sh

export model_checkpoint=/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/baseline_models/ESM-IF1/esm_if1_gvp4_t16_142M_UR50.pt
export DMS_output_score_folder=${DMS_output_score_folder_subs}/ESM-IF1-142M/

for i in {0..518}; do
    python ${SCRIPT_DIR}/baselines/esm/compute_fitness_esm_if1.py \
        --model_location ${model_checkpoint} \
        --structure_folder ${DMS_structure_folder} \
        --DMS_index $i \
        --DMS_reference_file_path ${DMS_reference_file_path_subs} \
        --DMS_data_folder ${DMS_data_folder_subs} \
        --output_scores_folder ${DMS_output_score_folder}
done
