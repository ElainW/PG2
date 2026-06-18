#!/bin/bash
#SBATCH -t 0-12:00
#SBATCH -p gpu,gpu_quad,gpu_requeue 
#SBATCH --qos=gpuquad_qos
#SBATCH --gres=gpu:1
#SBATCH --mem=8G
#SBATCH -o BL_vespag_%j.out
#SBATCH -e BL_vespag_%j.err
#SBATCH -J BL_vespag
#SBATCH --account=marks

module load conda/miniforge3/24.11.3-0
mamba activate /n/groups/marks/projects/marks_lab_and_oatml/ProteinGym2/model_envs/vespag

source Beltran_Lehner_2025_zero_shot_config.sh

# https://marks.hms.harvard.edu/proteingym/baseline_dependencies/VespaG/proteingym_esm2_embeddings.h5

# https://marks.hms.harvard.edu/proteingym/baseline_dependencies/VespaG/state_dict_v2.pt
export model_checkpoint_file=/n/www/marks.hms.harvard.edu/docroot/proteingym/baseline_dependencies/VespaG/state_dict_v2.pt

# set base for relative paths in place so we can cd safely
DMS_output_score_folder_subs=${DMS_output_score_folder_subs}/VespaG/

cd ${SCRIPT_DIR}/vespag # this is necessary to be able to run VespaG as a module

# should probably specify a tmp dir to avoid overwriting
for i in {0..518}; do
    python -m vespag eval proteingym \
        -o "$DMS_output_score_folder_subs" \
        --dms-directory "$DMS_data_folder_subs" \
        --reference-file "$DMS_reference_file_path_subs" \
        --checkpoint-file "$model_checkpoint_file" \
        --dms-index $i
done
