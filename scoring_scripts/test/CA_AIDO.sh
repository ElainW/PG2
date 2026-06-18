#!/bin/bash
#SBATCH -t 0-1:00
#SBATCH -p gpu,gpu_quad,gpu_requeue
#SBATCH --qos=gpuquad_qos
#SBATCH --gres=gpu:1,vram:80G
#SBATCH --mem=20G
#SBATCH -o CA_AIDO_%j.out
#SBATCH -e CA_AIDO_%j.err
#SBATCH -J CA_AIDO
#SBATCH --account=marks

module load gcc/14.2.0 cuda/12.8 conda/miniforge3/24.11.3-0
mamba activate /n/groups/marks/projects/marks_lab_and_oatml/ProteinGym2/model_envs/ragplm

root=/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym2
script_dir=/n/groups/marks/users/elain/PG2/ProteinGym/proteingym/baselines

export HF_HOME=/n/groups/marks/users/elain/PG2/huggingface_cache
export DMS_output_score_folder=${root}/model_scores/zero_shot_substitutions/AIDO/
mkdir -p ${DMS_output_score_folder}

# One example: PTEN_HUMAN_Mighell_2018
python ${script_dir}/AIDO/compute_fitness.py \
    --dms_ids "A0A972RTS6_9BACT_Lazar_2025" \
    --fasta_dir /n/groups/marks/projects/marks_lab_and_oatml/ProteinGym2/DMS_assays/processed_data/A0A972RTS6_9BACT_Lazar_2025/ \
    --msa_dir /n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/MSA_files/PG_repo/DMS_MSA_PG2/ \
    --dms_dir /n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/DMS_assays/DMS_ProteinGym_substitutions_PG2/ \
    --pdb_dir /n/groups/marks/projects/marks_lab_and_oatml/ProteinGym2/pdbs/ \
    --output_path $DMS_output_score_folder \
    --hf_cache_location $HF_HOME