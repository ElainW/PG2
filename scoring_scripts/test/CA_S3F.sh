#!/bin/bash
#SBATCH -t 1-00:00
#SBATCH -p gpu,gpu_quad,gpu_requeue 
#SBATCH --qos=gpuquad_qos
#SBATCH --gres=gpu:1
#SBATCH --mem=10G
#SBATCH -o CA_s3f_%j.out
#SBATCH -e CA_s3f_%j.err
#SBATCH -J CA_s3f
#SBATCH --account=marks
module load conda/miniforge3/24.11.3-0
mamba activate /n/groups/marks/projects/marks_lab_and_oatml/conda_envs/s3f

root=/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym2
script_dir=/n/groups/marks/users/elain/PG2/ProteinGym/proteingym/baselines

# preprocess the surface
mkdir -p s3f_dataset/processed_proteingym
python ${script_dir}/S3F/script/preload_dataset.py -i /n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/structure_files/DMS_subs_PG2/ -o ./s3f_dataset/processed_proteingym/
python ${script_dir}/S3F/script/process_surface.py -i ./s3f_dataset/processed_proteingym/ -o ./s3f_dataset/processed_surface_gym/

export S3F_model_checkpoint=/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/baseline_models/S3F/checkpoint/s3f.pth
export S3F_output_scores_folder=${root}/model_scores/zero_shot_substitutions/S3F
export S3F_config=${script_dir}/S3F/config/evaluate/s3f.yaml
export S3F_surfdir=./s3f_dataset/processed_surface_gym/
export DMS_index=256

python ${script_dir}/S3F/compute_fitness.py \
        -c ${S3F_config} \
        --datadir /n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/DMS_assays/DMS_ProteinGym_substitutions_PG2/ \
        --ProteinGym_reference_file ${root}/reference_files/pg2_reference_current.csv \
        --structdir /n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/structure_files/ \
        --ckpt ${S3F_model_checkpoint} \
        --output_scores_folder ${S3F_output_scores_folder} \
        --surfdir ${S3F_surfdir} \
        --DMS_index ${DMS_index}