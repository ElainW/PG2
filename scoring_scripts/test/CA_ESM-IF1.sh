module load conda/miniforge3/24.11.3-0
mamba activate /n/groups/marks/projects/marks_lab_and_oatml/ProteinGym2/model_envs/esm

root=/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym2
export model_checkpoint=/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/baseline_models/ESM-IF1/esm_if1_gvp4_t16_142M_UR50.pt
script_dir=/n/groups/marks/users/elain/PG2/ProteinGym/proteingym/baselines/esm

export DMS_output_score_folder=${root}/model_scores/zero_shot_substitutions/ESM-IF1-142M/
export DMS_index="256"

python ${script_dir}/compute_fitness_esm_if1.py \
    --model_location ${model_checkpoint} \
    --structure_folder /n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/structure_files/DMS_subs_PG2/ \
    --DMS_index $DMS_index \
    --DMS_reference_file_path /n/groups/marks/projects/marks_lab_and_oatml/ProteinGym2/reference_files/pg2_reference_current.csv \
    --DMS_data_folder /n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/DMS_assays/DMS_ProteinGym_substitutions_PG2/ \
    --output_scores_folder ${DMS_output_score_folder} \
    --chain 'P'