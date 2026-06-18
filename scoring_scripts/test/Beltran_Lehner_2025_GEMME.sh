#!/bin/bash
#SBATCH -t 0-12:00
#SBATCH -p priority 
#SBATCH --mem=4G
#SBATCH -o slurm/BL_GEMME_%j.out
#SBATCH -e slurm/BL_GEMME_%j.err
#SBATCH -J BL_GEMME
#SBATCH --account=marks

module load conda/miniforge3/24.11.3-0
source Beltran_Lehner_2025_zero_shot_config.sh
conda activate /n/groups/marks/software/anaconda_o2/envs/protein_env # python3 with pandas

export GEMME_LOCATION="/opt/GEMME"
export JET2_LOCATION="/opt/JET2"
export TEMP_FOLDER="./gemme_tmp"
export DMS_output_score_folder="${DMS_output_score_folder_subs}/GEMME/"
export DOCKER_IMAGE="/n/app/containers/shared/marks/gemme_gemme.sif"
mkdir -p ./GEMME_scripts/

# to circumvent the incompatible python versions (GEMME uses python2.7), first generate the commands
# for i in {1..518}; do
#     python ${SCRIPT_DIR}/gemme/compute_fitness_step1.py \
#         --DMS_index=$i \
#         --DMS_reference_file_path=$DMS_reference_file_path_subs \
#         --DMS_data_folder=$DMS_data_folder_subs \
#         --MSA_folder=$DMS_MSA_data_folder \
#         --output_scores_folder=$DMS_output_score_folder \
#         --GEMME_path=$GEMME_LOCATION \
#         --JET_path=$JET2_LOCATION \
#         --temp_folder=$TEMP_FOLDER \
#         --output_script=GEMME_scripts/$i.sh
# done

# then use the container to run all the commands, disable looking for Rcpp and seqinr in the home folder, because these are installed in the container
for i in {6..518}; do
    singularity exec \
    --no-home \
    -B ${SCRIPT_DIR},$(dirname $(dirname $(dirname $(realpath $0)))):/root/ProteinGym \
    -W /root/ProteinGym/scripts/scoring_DMS_zero_shot \
    $DOCKER_IMAGE \
    bash /n/groups/marks/projects/marks_lab_and_oatml/ProteinGym2/scoring_scripts/test/GEMME_scripts/$i.sh
done

# get the scores from GEMME output
for i in {2..518}; do
    python ${SCRIPT_DIR}/gemme/compute_fitness_step2.py \
        --DMS_index=$i \
        --DMS_reference_file_path=$DMS_reference_file_path_subs \
        --DMS_data_folder=$DMS_data_folder_subs \
        --output_scores_folder=$DMS_output_score_folder \
        --temp_folder=$TEMP_FOLDER
done
