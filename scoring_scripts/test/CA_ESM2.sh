#!/bin/bash
#SBATCH -t 0-1:00
#SBATCH -p gpu,gpu_quad,gpu_requeue 
#SBATCH --qos=gpuquad_qos
#SBATCH --gres=gpu:1
#SBATCH --mem=5G
#SBATCH -o CA_esm2_%j.out
#SBATCH -e CA_esm2_%j.err
#SBATCH -J CA_esm2
#SBATCH --account=marks

module load conda/miniforge3/24.11.3-0
mamba activate /n/groups/marks/projects/marks_lab_and_oatml/ProteinGym2/model_envs/esm

root=/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym2
export model_checkpoint=/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/baseline_models/ESM2/esm2_t33_650M_UR50D.pt
export dms_output_folder=${root}/model_scores/zero_shot_substitutions/ESM2_650M/
script_dir=/n/groups/marks/users/elain/PG2/ProteinGym/proteingym/baselines/esm

export model_type="ESM2"
export scoring_strategy="masked-marginals"
export DMS_index=256

python ${script_dir}/compute_fitness.py \
    --model-location ${model_checkpoint} \
    --dms_index ${DMS_index} \
    --dms_mapping /n/groups/marks/projects/marks_lab_and_oatml/ProteinGym2/reference_files/pg2_reference_current.csv \
    --dms-input /n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/DMS_assays/DMS_ProteinGym_substitutions_PG2/ \
    --dms-output ${dms_output_folder} \
    --scoring-strategy ${scoring_strategy} \
    --model_type ${model_type} 