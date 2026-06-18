#!/bin/bash 
#SBATCH --cpus-per-task=8
#SBATCH --gres=gpu:1
#SBATCH -p gpu_quad,gpu
#SBATCH --qos=gpuquad_qos
#SBATCH -t 0-12:00
#SBATCH --mem=40G
#SBATCH --output=slurm/msat-weight-%j.out
#SBATCH --error=slurm/msat-weight-%j.err
#SBATCH --job-name="MSAT_weight"

module load conda/miniforge3/24.11.3-0
module load gcc/14.2.0
module load cuda/12.8

export CONDA_ENVS_PATH=/n/groups/marks/projects/marks_lab_and_oatml/conda_envs
export CONDA_PKGS_DIRS=/n/groups/marks/projects/marks_lab_and_oatml/conda_pkgs

conda activate /n/groups/marks/projects/marks_lab_and_oatml/conda_envs/protein_npt_env

root=/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym2
DMS_MSA_data_folder=${root}/EVCouplings/output/Beltran_Lehner_2025/selected_alignments
DMS_reference_file_path_subs=${root}/EVCouplings/output/Beltran_Lehner_2025/temp_ref_file.csv
DMS_MSA_weights_folder=${root}/EVCouplings/output/Beltran_Lehner_2025/weights/MSA_transformer

for index in {1..518}; do
    python /n/groups/marks/users/elain/PG2/ProteinGym/proteingym/baselines/EVE/calc_weights.py \
        --MSA_data_folder ${DMS_MSA_data_folder} \
        --DMS_reference_file_path ${DMS_reference_file_path_subs} \
        --DMS_index $index \
        --MSA_weights_location ${DMS_MSA_weights_folder} \
        --num_cpus -1 \
        --calc_method evcouplings \
        --threshold_focus_cols_frac_gaps 1 \
        --skip_existing
        #--overwrite
done
