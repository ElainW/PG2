#!/bin/bash
#SBATCH -t 0-5:00
#SBATCH -p gpu,gpu_quad,gpu_requeue 
#SBATCH --qos=gpuquad_qos
#SBATCH --gres=gpu:1
#SBATCH --mem=10G
#SBATCH -o BL_rsalor_%j.out
#SBATCH -e BL_rsalor_%j.err
#SBATCH -J BL_rsalor
#SBATCH --account=marks

module load conda/miniforge3/24.11.3-0
mamba activate /n/groups/marks/projects/marks_lab_and_oatml/ProteinGym2/model_envs/rsalor

root=/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym2
script_dir=/n/groups/marks/users/elain/PG2/ProteinGym/proteingym/baselines
export output_scores_folder=${root}/model_scores/zero_shot_substitutions/RSALOR/
mkdir -p ${output_scores_folder}

python ${script_dir}/RSALOR/run_rsalor.py \
    --DMS_reference_file_path ${root}/EVCouplings/output/Beltran_Lehner_2025/temp_ref_file.csv \
    --DMS_data_folder ${root}/DMS_assays/processed_data/Beltran_Lehner_2025/cleaned \
    --MSA_folder ${root}/EVCouplings/output/Beltran_Lehner_2025/selected_alignments \
    --DMS_structure_folder ${root}/pdbs \
    --output_scores_folder ${output_scores_folder}