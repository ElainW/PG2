module load conda/miniforge3/24.11.3-0
mamba activate /n/groups/marks/projects/marks_lab_and_oatml/ProteinGym2/model_envs/rsalor

root=/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym2
script_dir=/n/groups/marks/users/elain/PG2/ProteinGym/proteingym/baselines
export output_scores_folder=${root}/model_scores/zero_shot_substitutions/RSALOR/
mkdir -p ${output_scores_folder}

python ${script_dir}/RSALOR/run_rsalor.py \
    --DMS_reference_file_path ${root}/reference_files/pg2_reference_current.csv \
    --DMS_index 256 \
    --DMS_data_folder /n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/DMS_assays/DMS_ProteinGym_substitutions_PG2/ \
    --MSA_folder /n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/MSA_files/PG_repo/DMS_MSA_PG2/ \
    --DMS_structure_folder /n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/structure_files/DMS_subs_PG2/ \
    --output_scores_folder ${output_scores_folder}