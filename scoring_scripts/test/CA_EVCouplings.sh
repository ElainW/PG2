module load conda/miniforge3/24.11.3-0
mamba activate /n/groups/marks/projects/marks_lab_and_oatml/ProteinGym2/EVCouplings/envs/pg2_evc

root=/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym2
script_dir=/n/groups/marks/users/elain/PG2/ProteinGym/proteingym/baselines/

python /n/groups/marks/users/elain/PG2/ProteinGym/proteingym/baselines/EVmutation/score_mutants.py \
    --DMS_reference_file_path ${root}/reference_files/pg2_reference_current.csv \
    --DMS_data_folder /n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/DMS_assays/DMS_ProteinGym_substitutions_PG2/ \
    --model_folder ${root}/EVCouplings/output/A0A972RTS6_9BACT_Lazar_2025/ \
    --output_scores_folder ${root}/model_scores/zero_shot_substitutions/EVmutation/ \
    --DMS_index 256