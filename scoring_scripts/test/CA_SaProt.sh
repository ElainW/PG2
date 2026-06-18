module load conda/miniforge3/24.11.3-0
mamba activate /n/groups/marks/projects/marks_lab_and_oatml/ProteinGym2/model_envs/saprot

root=/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym2
script_dir=/n/groups/marks/users/elain/PG2/ProteinGym/proteingym/baselines

export SaProt_model_path=/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/baseline_models/SaProt/SaProt_650M_AF2/ #Path where you have downloaded all SaProt model/tokenizer files from the HF hub (https://huggingface.co/westlake-repl/SaProt_650M_AF2)
export output_scores_folder=${root}/model_scores/zero_shot_substitutions/SaProt_650M_AF2/
mkdir -p ${output_scores_folder}
export foldseek_bin=/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/foldseek/foldseek/bin/foldseek #(Download from here: https://github.com/steineggerlab/foldseek?tab=readme-ov-file)

export DMS_index=256

python ${script_dir}/saprot/compute_fitness.py \
    --foldseek_bin ${foldseek_bin} \
    --SaProt_model_name_or_path ${SaProt_model_path} \
    --DMS_reference_file_path ${root}/reference_files/pg2_reference_current.csv \
    --DMS_data_folder /n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/DMS_assays/DMS_ProteinGym_substitutions_PG2/ \
    --structure_data_folder /n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/structure_files/DMS_subs_PG2/ \
    --DMS_index $DMS_index \
    --output_scores_folder ${output_scores_folder}