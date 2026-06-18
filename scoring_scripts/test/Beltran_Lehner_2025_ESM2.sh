#!/bin/bash
#SBATCH -t 0-5:00
#SBATCH -p gpu,gpu_quad,gpu_requeue 
#SBATCH --qos=gpuquad_qos
#SBATCH --gres=gpu:1
#SBATCH --mem=20G
#SBATCH -o BL_esm2_%j.out
#SBATCH -e BL_esm2_%j.err
#SBATCH -J BL_esm2
#SBATCH --account=marks

module load conda/miniforge3/24.11.3-0
mamba activate /n/groups/marks/projects/marks_lab_and_oatml/ProteinGym2/model_envs/esm

source Beltran_Lehner_2025_zero_shot_config.sh

export model_checkpoint=/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/baseline_models/ESM2/esm2_t33_650M_UR50D.pt
export dms_output_folder=${DMS_output_score_folder_subs}/ESM2_650M/

export model_type="ESM2"
export scoring_strategy="masked-marginals"

for i in {0..518}; do
    python ${SCRIPT_DIR}/esm/compute_fitness.py \
        --model-location ${model_checkpoint} \
        --dms_index $i \
        --dms_mapping ${DMS_reference_file_path_subs} \
        --dms-input ${DMS_data_folder_subs} \
        --dms-output ${dms_output_folder} \
        --scoring-strategy ${scoring_strategy} \
        --model_type ${model_type}
done