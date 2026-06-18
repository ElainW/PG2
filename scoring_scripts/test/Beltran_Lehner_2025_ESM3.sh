module load conda/miniforge3/24.11.3-0
mamba activate /n/groups/marks/projects/marks_lab_and_oatml/ProteinGym2/model_envs/esm3

source Beltran_Lehner_2025_zero_shot_config.sh

export dms_output_folder=${${DMS_output_score_folder}}/ESM3/
mkdir -p $dms_output_folder

python ${SCRIPT_DIR}/evoscale/compute_fitness.py \
    --model_type "esm3_open" \
    --reference_csv ${DMS_reference_file_path_subs} \
    --dms_dir ${DMS_data_folder_subs} \
    --pdb_dir ${DMS_structure_folder} \
    --output_dir ${dms_output_folder} \
    --use_structure