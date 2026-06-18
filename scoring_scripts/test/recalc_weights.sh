#!/bin/bash
#SBATCH -t 0-06:00
#SBATCH -p short
#SBATCH --mem=20G
#SBATCH -c 1
#SBATCH -o bl_weights_%A_%a.out
#SBATCH -e bl_weights_%A_%a.err
#SBATCH -J bl_weights
#SBATCH --array=10,318
#SBATCH --account=marks

module load conda/miniforge3/24.11.3-0
conda activate /n/groups/marks/software/anaconda_o2/envs/proteingym_env

root=/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym2

python recalc_weights.py \
    --DMS_reference_file_path ${root}/EVCouplings/output/Beltran_Lehner_2025/temp_ref_file.csv \
    --protein_index $SLURM_ARRAY_TASK_ID \
    --MSA_data_folder ${root}/EVCouplings/output/Beltran_Lehner_2025/selected_alignments \
    --threshold_focus_cols_frac_gaps 1.0 \
    --MSA_weights_folder ${root}/EVCouplings/output/Beltran_Lehner_2025/weights/no_threshold_focus_cols_frac_gaps/ \
    --align_stats_folder ${root}/EVCouplings/output/Beltran_Lehner_2025/aln_stats/recalc




# 6,7,10,12,21,24,25,41,44,45,46,54,55,61,62,65,66,67,72,77,81,84,87,88,90,96,99,101,102,103,107,110,111,119,122,125,126,129,135,138,139,140,141,149,150,153,161,174,177,179,180,181,182,187,192,194,198,203,217,221,222,224,228,231,238,247,251,255,256,257,264,266,267,268,271,273,276,277,278,279,285,286,291,293,299,305,306,314,317,318,323,325,337,343,348,356,358,375,376,377,378,380,381,384,387,393,397,399,400,402,403,404,411,412,415,416,417,419,427,429,431,433,435,437,442,446,448,455,458,465,473,474,479,482,484,491,497,500,501,508,509,513,515,516,517
