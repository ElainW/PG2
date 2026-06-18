#!/bin/bash 
#SBATCH --cpus-per-task=4
#SBATCH --gres=gpu:1
#SBATCH --qos=gpuquad_qos
#SBATCH -p gpu,gpu_quad
#SBATCH -t 0-12:00
#SBATCH --mem=5G
#SBATCH --output=slurm/venus-%j.out
#SBATCH --error=slurm/venus-%j.err
#SBATCH --job-name="Venus"
#SBATCH --account=marks

# used to be 8 cores

module load conda/miniforge3/24.11.3-0
module load gcc/14.2.0
module load cuda/12.8

# export CONDA_ENVS_PATH=/n/groups/marks/projects/marks_lab_and_oatml/conda_envs
# export CONDA_PKGS_DIRS=/n/groups/marks/projects/marks_lab_and_oatml/conda_pkgs

source Beltran_Lehner_2025_zero_shot_config.sh

conda activate /n/groups/marks/projects/marks_lab_and_oatml/conda_envs/venusrem

export DMS_output_score_folder=${DMS_output_score_folder}/VenusREM
mkdir -p ${DMS_output_score_folder}
mkdir -p /n/groups/marks/projects/marks_lab_and_oatml/ProteinGym2/pdbs/struc_seq

#python ${SCRIPT_DIR}/venusrem/venusrem/data/get_struc_seq.py \
#    --pdb_dir /n/groups/marks/projects/marks_lab_and_oatml/ProteinGym2/pdbs \
#    --vocab_size 2048 \
#    --out_dir /n/groups/marks/projects/marks_lab_and_oatml/ProteinGym2/pdbs/struc_seq

for i in {1..518}; do
	python ${SCRIPT_DIR}/venusrem/compute_fitness_v2.py \
	    --model_name AI4Protein/ProSST-2048 \
	    --reference_file ${DMS_reference_file_path_subs} \
	    --DMS_index $i \
	    --aa_seq_dir ${fasta_dir} \
	    --mutant_dir ${DMS_data_folder_subs} \
	    --aa_seq_aln_dir ${DMS_MSA_data_folder} \
	    --struc_seq_dir /n/groups/marks/projects/marks_lab_and_oatml/ProteinGym2/pdbs/struc_seq \
	    --output_scores_folder ${DMS_output_score_folder}
done
