module load conda/miniforge3/24.11.3-0
mamba activate /n/groups/marks/projects/marks_lab_and_oatml/ProteinGym2/model_envs/vespag

root=/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym2

# https://marks.hms.harvard.edu/proteingym/baseline_dependencies/VespaG/proteingym_esm2_embeddings.h5
# export precomputed_embedding_file=${root}/model_scores/zero_shot_substitutions/ESM2_embeddings/singles/A0A972RTS6_9BACT_Lazar_2025.h5

# https://marks.hms.harvard.edu/proteingym/baseline_dependencies/VespaG/state_dict_v2.pt
export model_checkpoint_file=/n/www/marks.hms.harvard.edu/docroot/proteingym/baseline_dependencies/VespaG/state_dict_v2.pt

# set base for relative paths in place so we can cd safely
DMS_output_score_folder_subs=${root}/model_scores/zero_shot_substitutions/VespaG/
DMS_data_folder_subs=/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/DMS_assays/DMS_ProteinGym_substitutions_PG2/
DMS_reference_file_path_subs=/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym2/reference_files/pg2_reference_current.csv

cd /n/groups/marks/users/elain/PG2/ProteinGym/proteingym/baselines/vespag # this is necessary to be able to run VespaG as a module

# should probably specify a tmp dir to avoid overwriting
python -m vespag eval proteingym \
    -o "$DMS_output_score_folder_subs" \
    --dms-directory "$DMS_data_folder_subs" \
    --reference-file "$DMS_reference_file_path_subs" \
    --checkpoint-file "$model_checkpoint_file" \
    --dms-index 256
    # -e "$precomputed_embedding_file" \