module load conda/miniforge3/24.11.3-0
conda activate /n/groups/marks/projects/marks_lab_and_oatml/ProteinGym2/model_envs/evcouplings/

root=/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym2
mkdir -p $root/EVCouplings/output/PG1/all_EVmutation

# for i in {0..216}; do
#     python ./score_mutants_PG1.py \
#     --DMS_reference_file_path $root/EVCouplings/input/DMS_substitutions_PG1_trimmed.csv \
#     --DMS_data_folder /n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/DMS_assays/DMS_ProteinGym_substitutions \
#     --model_folder $root/EVCouplings/output/PG1/models \
#     --output_scores_folder $root/EVCouplings/output/PG1/all_EVmutation \
#     --DMS_index $i
# done

for i in {0..1}; do
    python ./score_mutants_PG1.py \
    --DMS_reference_file_path $root/EVCouplings/input/DMS_substitutions_PG1_trimmed.csv \
    --DMS_data_folder /n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/DMS_assays/DMS_ProteinGym_substitutions \
    --model_folder $root/EVCouplings/output/PG1/models \
    --output_scores_folder $root/EVCouplings/output/PG1/all_EVmutation \
    --DMS_index $i
done