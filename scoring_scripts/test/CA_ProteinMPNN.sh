module load conda/miniforge3/24.11.3-0
mamba activate /n/groups/marks/projects/marks_lab_and_oatml/ProteinGym2/model_envs/proteinmpnn

root=/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym2
script_dir=/n/groups/marks/users/elain/PG2/ProteinGym/proteingym/baselines
export output_scores_folder=${root}/model_scores/zero_shot_substitutions/ProteinMPNN
mkdir -p ${output_scores_folder}

export model_checkpoint=/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/baseline_models/ProteinMPNN/v_48_020.pt

python ${script_dir}/protein_mpnn/compute_fitness.py \
    --checkpoint ${model_checkpoint} \
    --structure_folder /n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/structure_files/DMS_subs_PG2/ \
    --DMS_index 256 \
    --DMS_reference_file_path ${root}/reference_files/pg2_reference_current.csv \
    --DMS_data_folder /n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/DMS_assays/DMS_ProteinGym_substitutions_PG2/ \
    --output_scores_folder ${output_scores_folder}