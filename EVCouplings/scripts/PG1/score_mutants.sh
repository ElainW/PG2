#!/bin/bash
#SBATCH -c 1
#SBATCH -p priority
#SBATCH --mem=60G
#SBATCH -J navami_evmutation_scoring
#SBATCH -t 0-00:15
#SBATCH -o navami_evmutation_scoring.log
#SBATCH -e navami_evmutation_scoring.err

module load conda/miniforge3/24.11.3-0
conda activate /n/groups/marks/projects/marks_lab_and_oatml/ProteinGym2/model_envs/evcouplings/

root=/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym2
mkdir -p $root/EVCouplings/output/PG1/all_EVmutation

for i in 86 91 149 182; do
    echo "DMS_INDEX" $i
    python ./score_mutants_PG1.py \
    --DMS_reference_file_path $root/EVCouplings/input/DMS_substitutions_PG1_trimmed.csv \
    --DMS_data_folder /n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/DMS_assays/DMS_ProteinGym_substitutions \
    --model_folder $root/EVCouplings/output/PG1/models \
    --output_scores_folder $root/EVCouplings/output/PG1/all_EVmutation \
    --DMS_index $i \
    --model_suffix "_seqcov50_colcov50_theta*_b*"
done

# DMS index 24 took over 40G, 31 took 40G
