#!/bin/bash
#SBATCH -t 0-1:00
#SBATCH -p gpu,gpu_quad,gpu_requeue 
#SBATCH --qos=gpuquad_qos
#SBATCH --gres=gpu:1
#SBATCH --mem=20G
#SBATCH -o CA_trancept_%j.out
#SBATCH -e CA_trancept_%j.err
#SBATCH -J CA_trancept
#SBATCH --account=marks
module load conda/miniforge3/24.11.3-0
mamba activate /n/groups/marks/projects/marks_lab_and_oatml/ProteinGym2/model_envs/tranception

root=/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym2
script_dir=/n/groups/marks/users/elain/PG2/ProteinGym/proteingym/baselines/tranception

export checkpoint=/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/baseline_models/Tranception/Tranception_Large/
export output_scores_folder=${root}/model_scores/zero_shot_substitutions/Tranception_L_no_retrieval/

# took 10G
# python ${script_dir}/score_tranception_proteingym.py \
#     --checkpoint ${checkpoint} \
#     --DMS_reference_file_path /n/groups/marks/projects/marks_lab_and_oatml/ProteinGym2/reference_files/pg2_reference_current.csv \
#     --DMS_data_folder /n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/DMS_assays/DMS_ProteinGym_substitutions_PG2/ \
#     --DMS_index 256 \
#     --output_scores_folder ${output_scores_folder} 

export output_scores_folder=${root}/model_scores/zero_shot_substitutions/Tranception_L_retrieval/
python ${script_dir}/score_tranception_proteingym.py \
    --checkpoint ${checkpoint} \
    --DMS_reference_file_path /n/groups/marks/projects/marks_lab_and_oatml/ProteinGym2/reference_files/pg2_reference_current.csv \
    --DMS_data_folder /n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/DMS_assays/DMS_ProteinGym_substitutions_PG2/ \
    --DMS_index 256 \
    --output_scores_folder ${output_scores_folder} \
    --inference_time_retrieval \
    --MSA_folder /n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/MSA_files/PG_repo/DMS_MSA_PG2/ \
    --MSA_weights_folder /n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/MSA_weights/PG_repo/DMS_msa_weights_PG2/