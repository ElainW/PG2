#!/bin/bash
#SBATCH -t 2-00:00
#SBATCH -p gpu,gpu_quad 
#SBATCH --qos=gpuquad_qos
#SBATCH --gres=gpu:l40s:1
#SBATCH --mem=3G
#SBATCH -o BL_poet_%A_%a.out
#SBATCH -e BL_poet_%A_%a.err
#SBATCH -J BL_poet
#SBATCH --array=343,462,507
#SBATCH --account=marks

# most finish within 12 hours

module load conda/miniforge3/24.11.3-0
mamba activate /n/groups/marks/projects/marks_lab_and_oatml/ProteinGym2/model_envs/poet

source Beltran_Lehner_2025_zero_shot_config.sh
export checkpoint=/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/baseline_models/PoET/poet.ckpt
export output_scores_folder=${DMS_output_score_folder_subs}/PoET

# make the .a3m.zst file
python Poet_prep.py \
    --DMS_reference_file_path ${DMS_reference_file_path_subs} \
    --MSA_data_folder ${DMS_MSA_data_folder} \
    --range 0-518

python ${SCRIPT_DIR}/PoET/scripts/score.py \
	--checkpoint ${checkpoint} \
	--DMS_reference_file_path ${DMS_reference_file_path_subs} \
	--DMS_data_folder ${DMS_data_folder_subs} \
	--DMS_index ${SLURM_ARRAY_TASK_ID} \
	--output_scores_folder ${output_scores_folder} \
	--MSA_folder ${DMS_MSA_data_folder}/a3m/ \
	--context_lengths 6144 12288 24576 \
	--batch_size 8
