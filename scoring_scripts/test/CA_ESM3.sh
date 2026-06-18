module load conda/miniforge3/24.11.3-0
mamba activate /n/groups/marks/projects/marks_lab_and_oatml/ProteinGym2/model_envs/esm3

root=/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym2
script_dir=/n/groups/marks/users/elain/PG2/ProteinGym/proteingym/baselines/

DMS_output_score_folder_subs=${root}/model_scores/zero_shot_substitutions
export dms_output_folder=${DMS_output_score_folder_subs}/ESM3/

DMS_data_folder_subs=/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/DMS_assays/DMS_ProteinGym_substitutions_PG2/

python ${script_dir}/evoscale/compute_fitness.py \
    --model_type "esm3_open" \
    --reference_csv ${root}/reference_files/pg2_reference_current.csv \
    --dms_dir ${DMS_data_folder_subs} \
    --pdb_dir /n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/structure_files/DMS_subs_PG2/ \
    --output_dir ${dms_output_folder} \
    --use_structure \
    --DMS_index 256