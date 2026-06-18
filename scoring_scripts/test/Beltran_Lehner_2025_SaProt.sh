#!/bin/bash
#SBATCH -t 1-06:00
#SBATCH -p gpu,gpu_quad,gpu_requeue 
#SBATCH --qos=gpuquad_qos
#SBATCH --gres=gpu:1
#SBATCH --mem=10G
#SBATCH -o BL_saprot_%j.out
#SBATCH -e BL_saprot_%j.err
#SBATCH -J BL_saprot
#SBATCH --account=marks

module load conda/miniforge3/24.11.3-0
mamba activate /n/groups/marks/projects/marks_lab_and_oatml/ProteinGym2/model_envs/saprot

root=/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym2
script_dir=/n/groups/marks/users/elain/PG2/ProteinGym/proteingym/baselines

export SaProt_model_path=/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/baseline_models/SaProt/SaProt_650M_AF2/ #Path where you have downloaded all SaProt model/tokenizer files from the HF hub (https://huggingface.co/westlake-repl/SaProt_650M_AF2)
export output_scores_folder=${root}/model_scores/zero_shot_substitutions/SaProt_650M_AF2/
mkdir -p ${output_scores_folder}
export foldseek_bin=/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/foldseek/foldseek/bin/foldseek #(Download from here: https://github.com/steineggerlab/foldseek?tab=readme-ov-file)


for i in {1..518}; do
    python ${script_dir}/saprot/compute_fitness.py \
        --foldseek_bin ${foldseek_bin} \
        --SaProt_model_name_or_path ${SaProt_model_path} \
        --DMS_reference_file_path ${root}/EVCouplings/output/Beltran_Lehner_2025/temp_ref_file.csv \
        --DMS_data_folder ${root}/DMS_assays/processed_data/Beltran_Lehner_2025/cleaned \
        --structure_data_folder ${root}/pdbs \
        --DMS_index $i \
        --output_scores_folder ${output_scores_folder}
done