#!/bin/bash
#SBATCH -c 1
#SBATCH -p priority
#SBATCH --mem=40G
#SBATCH -J calc_spearman_pg1
#SBATCH -t 0-00:20
#SBATCH -o calc_spearman_pg1_%j.log
#SBATCH -e calc_spearman_pg1_%j.err

/n/groups/marks/users/aaron/pmhc_cp/envs/dl_binder_design/bin/python calc_spearman_pg1.py \
    --model_score_dir /n/groups/marks/projects/marks_lab_and_oatml/ProteinGym2/EVCouplings/output/PG1/all_EVmutation/ \
    --output_csv /n/groups/marks/projects/marks_lab_and_oatml/ProteinGym2/EVCouplings/output/PG1/navami_all_evcouplings_spearman.csv
    
/n/groups/marks/users/aaron/pmhc_cp/envs/dl_binder_design/bin/python calc_spearman_pg1.py \
    --model_score_dir /n/groups/marks/projects/marks_lab_and_oatml/ProteinGym2/EVCouplings/output/PG1/Tranception_PG1_models_all_EVmutation/ \
    --output_csv /n/groups/marks/projects/marks_lab_and_oatml/ProteinGym2/EVCouplings/output/PG1/tranception_all_evcouplings_spearman.csv