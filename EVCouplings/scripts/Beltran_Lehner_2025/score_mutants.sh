conda activate /n/groups/marks/projects/marks_lab_and_oatml/ProteinGym2/model_envs/evcouplings/

root=/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym2
mkdir -p $root/EVCouplings/output/Beltran_Lehner_2025/all_EVmutation

for i in {0..518}; do
    python ./score_mutants.py \
    --DMS_reference_file_path $root/EVCouplings/output/Beltran_Lehner_2025/temp_ref_file.csv \
    --DMS_data_folder $root/DMS_assays/processed_data/Beltran_Lehner_2025/cleaned \
    --model_folder $root/EVCouplings/output/Beltran_Lehner_2025/all_models \
    --output_scores_folder $root/EVCouplings/output/Beltran_Lehner_2025/all_EVmutation \
    --uniprot_mapping_file_path $root/DMS_assays/processed_data/Beltran_Lehner_2025/idmapping_2025_06_10.csv \
    --DMS_index $i
done