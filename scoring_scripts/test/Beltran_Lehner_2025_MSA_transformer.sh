#!/bin/bash 
#SBATCH --cpus-per-task=8
#SBATCH --gres=gpu:a100:1
#SBATCH --gres=gpu:l40s:1
#SBATCH -p gpu_quad,gpu
#SBATCH --qos=gpuquad_qos
#SBATCH -t 48:00:00
#SBATCH --mem=20G
#SBATCH --output=slurm/MSAT-%j.out
#SBATCH --error=slurm/MSAT-%j.err
#SBATCH --job-name="MSAT"

set -eo pipefail # fail fully on first line failure (from Joost slurm_for_ml)
# Make prints more stable (Milad)
export PYTHONUNBUFFERED=1

echo "hostname: $(hostname)"
echo "Running from: $(pwd)"
echo "Submitted from SLURM_SUBMIT_DIR: ${SLURM_SUBMIT_DIR}"

module load conda/miniforge3/24.11.3-0
module load gcc/14.2.0
module load cuda/12.8

export CONDA_ENVS_PATH=/n/groups/marks/projects/marks_lab_and_oatml/conda_envs
export CONDA_PKGS_DIRS=/n/groups/marks/projects/marks_lab_and_oatml/conda_pkgs

conda activate /n/groups/marks/projects/marks_lab_and_oatml/conda_envs/protein_npt_env
#pip install -e ../..

root=/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym2
script_dir=/n/groups/marks/users/elain/PG2/ProteinGym/proteingym/baselines

# MSA transformer checkpoint 
export model_checkpoint=/n/groups/marks/projects/marks_lab_and_oatml/protein_transformer/baseline_models/MSA_transformer/esm_msa1b_t12_100M_UR50S.pt
export dms_output_folder=/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym2/model_scores/zero_shot_substitutions/MSA_Transformer

export scoring_strategy=masked-marginals # MSA transformer only supports "masked-marginals" #"wt-marginals"
export model_type=MSA_transformer
export scoring_window="optimal"
export random_seeds="1 2 3 4 5"
export DMS_MSA_weights_for_MSA_Transformer_folder=/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym2/EVCouplings/output/Beltran_Lehner_2025/weights/MSA_transformer #/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/MSA_weights/PG_repo/DMS_MSA_weights_for_MSA_Transformer_folder
export DMS_data_folder_subs=${root}/DMS_assays/processed_data/Beltran_Lehner_2025/cleaned

for i in {1..518}; do
    python ${script_dir}/esm/compute_fitness.py \
        --model-location ${model_checkpoint} \
        --model_type ${model_type} \
        --dms_index $i \
        --dms_mapping ${root}/EVCouplings/output/Beltran_Lehner_2025/temp_ref_file.csv \
        --dms-input ${DMS_data_folder_subs} \
        --dms-output ${dms_output_folder} \
        --scoring-strategy ${scoring_strategy} \
        --scoring-window ${scoring_window} \
        --msa-path ${root}/EVCouplings/output/Beltran_Lehner_2025/selected_alignments \
        --msa-weights-folder ${DMS_MSA_weights_for_MSA_Transformer_folder} \
        --seeds ${random_seeds}
done
