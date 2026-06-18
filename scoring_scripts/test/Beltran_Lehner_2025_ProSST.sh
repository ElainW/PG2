#!/bin/bash 
#SBATCH --cpus-per-task=8
#SBATCH --gres=gpu:1
#SBATCH --qos=gpuquad_qos
#SBATCH -p gpu,gpu_quad
#SBATCH -t 0-00:10
#SBATCH --mem=3G
#SBATCH --output=slurm/prosst-%j.out
#SBATCH --error=slurm/prosst-%j.err
#SBATCH --job-name="PROSST"
#SBATCH --account=marks
#SBATCH --exclude compute-gc-17-213

module load conda/miniforge3/24.11.3-0
module load gcc/14.2.0
module load cuda/12.8

#export CONDA_ENVS_PATH=/n/groups/marks/projects/marks_lab_and_oatml/conda_envs
#export CONDA_PKGS_DIRS=/n/groups/marks/projects/marks_lab_and_oatml/conda_pkgs

#conda env create -f /home/pan223/open_source/ProteinGym/proteingym/baselines/venusrem/venusrem_environment.yml

source Beltran_Lehner_2025_zero_shot_config.sh
conda activate /n/groups/marks/projects/marks_lab_and_oatml/conda_envs/venusrem

# All models can be found at https://huggingface.co/AI4Protein
# ProSST models: ProSST-20 ProSST-128 ProSST-512 ProSST-1024 ProSST-2048 ProSST-4096 ProSST-3di
# export model_name=AI4Protein/ProSST-20 AI4Protein/ProSST-128 AI4Protein/ProSST-512 AI4Protein/ProSST-1024 AI4Protein/ProSST-2048 AI4Protein/ProSST-4096 AI4Protein/ProSST-3di
export model_hyp=2048
export model_name="AI4Protein/ProSST-$model_hyp"

# the structure pdb files can be found in ProtSSN: https://github.com/tyang816/ProtSSN
# please download and unzip the following files to a folder: https://drive.google.com/file/d/1lSckfPlx7FhzK1FX7EtmmXUOrdiMRerY/view?usp=sharing
export DMS_structure_folder=${DMS_structure_folder}"/struc_seq"
export DMS_output_score_folder=${DMS_output_score_folder}"/ProSST-${model_hyp}"

# for i in {0..518}; do
# 	python ${SCRIPT_DIR}/prosst/compute_fitness_v2.py \
# 	    --model_name ${model_name} \
# 	    --reference_file ${DMS_reference_file_path_subs} \
# 	    --DMS_index $i \
# 	    --residue_dir ${fasta_dir}\
# 	    --mutant_dir ${DMS_data_folder_subs} \
# 	    --structure_dir ${DMS_structure_folder} \
# 	    --output_scores_folder ${DMS_output_score_folder}
# done


python ${SCRIPT_DIR}/prosst/compute_fitness_v2.py \
    --model_name ${model_name} \
    --reference_file ${DMS_reference_file_path_subs} \
    --DMS_index 0 \
    --residue_dir ${fasta_dir}\
    --mutant_dir ${DMS_data_folder_subs} \
    --structure_dir ${DMS_structure_folder} \
    --output_scores_folder ${DMS_output_score_folder}
