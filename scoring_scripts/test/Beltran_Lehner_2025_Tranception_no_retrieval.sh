#!/bin/bash
#SBATCH -t 0-12:00
#SBATCH -p gpu,gpu_quad 
#SBATCH --qos=gpuquad_qos
#SBATCH --gres=gpu:1
#SBATCH --mem=20G
#SBATCH -o BL_trancept_no_r_%j.out
#SBATCH -e BL_trancept_no_r_%j.err
#SBATCH -J BL_trancept
#SBATCH --account=marks
module load conda/miniforge3/24.11.3-0
mamba activate /n/groups/marks/projects/marks_lab_and_oatml/ProteinGym2/model_envs/tranception

root=/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym2
script_dir=/n/groups/marks/users/elain/PG2/ProteinGym/proteingym/baselines/tranception

export checkpoint=/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/baseline_models/Tranception/Tranception_Large/

# took 10G
for i in {0..518}; do
    export output_scores_folder=${root}/model_scores/zero_shot_substitutions/Tranception_L_no_retrieval/
    python ${script_dir}/score_tranception_proteingym.py \
        --checkpoint ${checkpoint} \
        --DMS_reference_file_path ${root}/EVCouplings/output/Beltran_Lehner_2025/temp_ref_file.csv \
        --DMS_data_folder ${root}/DMS_assays/processed_data/Beltran_Lehner_2025/cleaned \
        --DMS_index $i \
        --output_scores_folder ${output_scores_folder} 
done
