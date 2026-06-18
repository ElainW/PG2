#!/bin/bash
#SBATCH -t 0-00:30
#SBATCH -p gpu,gpu_quad,gpu_requeue 
#SBATCH --qos=gpuquad_qos
#SBATCH --gres=gpu:a100:1
#SBATCH --mem=10G
#SBATCH -o CA_poet_%j.out
#SBATCH -e CA_poet_%j.err
#SBATCH -J CA_poet
#SBATCH --account=marks

module load conda/miniforge3/24.11.3-0
mamba activate /n/groups/marks/projects/marks_lab_and_oatml/ProteinGym2/model_envs/poet

root=/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym2
script_dir=/n/groups/marks/users/elain/PG2/ProteinGym/proteingym/baselines
export checkpoint=/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/baseline_models/PoET/poet.ckpt
export output_scores_folder=${root}/model_scores/zero_shot_substitutions/PoET

# make the .a3m.zst file
# python /n/groups/marks/projects/marks_lab_and_oatml/ProteinGym2/EVCouplings/scripts/convert_a2m_to_a3m.py /n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/MSA_files/PG_repo/DMS_MSA_PG2/A0A972RTS6_9BACT_Lazar_2025.a2m /n/groups/marks/projects/marks_lab_and_oatml/ProteinGym2/EVCouplings/output/A0A972RTS6_9BACT_Lazar_2025/A0A972RTS6_9BACT_Lazar_2025.a3m

# zstd /n/groups/marks/projects/marks_lab_and_oatml/ProteinGym2/EVCouplings/output/A0A972RTS6_9BACT_Lazar_2025/A0A972RTS6_9BACT_Lazar_2025.a3m /n/groups/marks/projects/marks_lab_and_oatml/ProteinGym2/EVCouplings/output/A0A972RTS6_9BACT_Lazar_2025/A0A972RTS6_9BACT_Lazar_2025.a3m.zst

export DMS_index="Experiment index to run (e.g. 0,1,...216)"

python ${script_dir}/PoET/scripts/score.py \
    --checkpoint ${checkpoint} \
    --DMS_reference_file_path ${root}/reference_files/pg2_reference_current.csv \
    --DMS_data_folder /n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/DMS_assays/DMS_ProteinGym_substitutions_PG2/ \
    --DMS_index 256 \
    --output_scores_folder ${output_scores_folder} \
    --MSA_folder ${root}/EVCouplings/output/A0A972RTS6_9BACT_Lazar_2025/ \
    --context_lengths 6144 12288 24576 \
    --batch_size 8
