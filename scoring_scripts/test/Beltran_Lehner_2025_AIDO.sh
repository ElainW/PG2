#!/bin/bash
#SBATCH -t 1-0:00
#SBATCH -p gpu,gpu_quad
#SBATCH --qos=gpuquad_qos
#SBATCH --gres=gpu:1,vram:80G
#SBATCH --mem=10G
#SBATCH -o BL_AIDO_%j.out
#SBATCH -e BL_AIDO_%j.err
#SBATCH -J BL_AIDO
#SBATCH --account=marks

# probably 9h is enough for all samples

module load gcc/14.2.0 cuda/12.8 conda/miniforge3/24.11.3-0
mamba activate /n/groups/marks/projects/marks_lab_and_oatml/ProteinGym2/model_envs/ragplm

# Source the configuration file
source Beltran_Lehner_2025_zero_shot_config.sh

export HF_HOME=/n/groups/marks/users/elain/PG2/huggingface_cache
export DMS_output_score_folder=${DMS_output_score_folder_subs}/AIDO/
mkdir -p ${DMS_output_score_folder}

# need to put in all the dms_ids, or ask it to parse the reference file
python ${SCRIPT_DIR}/AIDO/compute_fitness.py \
    --reference_file ${DMS_reference_file_path_subs} \
    --fasta_dir ${fasta_dir} \
    --msa_dir ${DMS_MSA_data_folder} \
    --dms_dir ${DMS_data_folder_subs} \
    --pdb_dir ${DMS_structure_folder} \
    --output_path $DMS_output_score_folder \
    --hf_cache_location $HF_HOME
