#!/bin/bash
#SBATCH -t 0-04:00
#SBATCH -p gpu,gpu_quad 
#SBATCH --qos=gpuquad_qos
#SBATCH --gres=gpu:l40s:1
#SBATCH --mem=4G
#SBATCH -o slurm/bl_ProGen3_%j.out
#SBATCH -e slurm/bl_ProGen3_%j.err
#SBATCH -J bl_ProGen3
#SBATCH --account=marks
# run on a100 or l40s
module load conda/miniforge3/24.11.3-0
mamba activate /n/groups/marks/projects/marks_lab_and_oatml/ProteinGym2/model_envs/progen3

source Beltran_Lehner_2025_zero_shot_config.sh

export dms_output_folder=${DMS_output_score_folder}/ProGen3/
mkdir -p $dms_output_folder

python ${SCRIPT_DIR}/progen3/compute_fitness_v2.py \
    --dms_dir ${DMS_data_folder_subs} \
    --model_name "progen3-3b" \
    --sh_dir ${SCRIPT_DIR}/progen3/progen3/zero_shot/ \
    --ref_file ${DMS_reference_file_path_subs} \
    --output_dir $dms_output_folder
