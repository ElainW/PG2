#!/bin/bash 
# rerun the MSA based on recommended bitscore from /n/groups/marks/projects/marks_lab_and_oatml/ProteinGym2/EVCouplings/scripts/Beltran_Lehner_2025/check_msa.ipynb
module load conda/miniforge3/24.11.3-0
conda activate /n/groups/marks/users/samhuang/envs/condaenvs/evcouplings_20250324

# # lines in each file
  #  26 sequences_0.5.csv
  #  24 sequences_0.6.csv
  # 523 sequences_0.7.csv
  #  21 sequences_0.8.csv
  #  58 sequences_0.9.csv

# # bitscore 0.5
# sbatch --cpus-per-task=1 -p short -t 1:00:00 -o /n/groups/marks/projects/marks_lab_and_oatml/ProteinGym2/EVCouplings/slurm/Beltran_Lehner_2025/EVM-test-%j.out -e /n/groups/marks/projects/marks_lab_and_oatml/ProteinGym2/EVCouplings/slurm/Beltran_Lehner_2025/EVM-0.5-%j.err -J EVM0.5 --array=0-17 --account=marks --wrap='python retrieve_MSA.py "${SLURM_ARRAY_TASK_ID}" 0.5 uniref100 /n/groups/marks/projects/marks_lab_and_oatml/ProteinGym2/EVCouplings/input/Beltran_Lehner_2025/sequences_0.5_add.csv'

# # bitscore 0.6
# sbatch --cpus-per-task=1 -p short -t 1:00:00 -o /n/groups/marks/projects/marks_lab_and_oatml/ProteinGym2/EVCouplings/slurm/Beltran_Lehner_2025/EVM-0.6-%j.out -e /n/groups/marks/projects/marks_lab_and_oatml/ProteinGym2/EVCouplings/slurm/Beltran_Lehner_2025/EVM-0.6-%j.err -J EVM0.6 --array=0-19 --account=marks --wrap='python retrieve_MSA.py "${SLURM_ARRAY_TASK_ID}" 0.6 uniref100 /n/groups/marks/projects/marks_lab_and_oatml/ProteinGym2/EVCouplings/input/Beltran_Lehner_2025/sequences_0.6_new.csv'

# # bitscore 0.8
# sbatch --cpus-per-task=1 -p short -t 1:00:00 -o /n/groups/marks/projects/marks_lab_and_oatml/ProteinGym2/EVCouplings/slurm/Beltran_Lehner_2025/EVM-0.8-%j.out -e /n/groups/marks/projects/marks_lab_and_oatml/ProteinGym2/EVCouplings/slurm/Beltran_Lehner_2025/EVM-0.8-%j.err -J EVM0.8 --array=0-22 --account=marks --wrap='python retrieve_MSA.py "${SLURM_ARRAY_TASK_ID}" 0.8 uniref100 /n/groups/marks/projects/marks_lab_and_oatml/ProteinGym2/EVCouplings/input/Beltran_Lehner_2025/sequences_0.8_new.csv'

# # bitscore 0.9
# sbatch --cpus-per-task=1 -p short -t 1:00:00 -o /n/groups/marks/projects/marks_lab_and_oatml/ProteinGym2/EVCouplings/slurm/Beltran_Lehner_2025/EVM-0.9-%j.out -e /n/groups/marks/projects/marks_lab_and_oatml/ProteinGym2/EVCouplings/slurm/Beltran_Lehner_2025/EVM-0.9-%j.err -J EVM0.9 --array=0-22 --account=marks --wrap='python retrieve_MSA.py "${SLURM_ARRAY_TASK_ID}" 0.9 uniref100 /n/groups/marks/projects/marks_lab_and_oatml/ProteinGym2/EVCouplings/input/Beltran_Lehner_2025/sequences_0.9_add.csv'

# # bitscore 1
# sbatch --cpus-per-task=1 -p short -t 1:00:00 -o /n/groups/marks/projects/marks_lab_and_oatml/ProteinGym2/EVCouplings/slurm/Beltran_Lehner_2025/EVM-1-%j.out -e /n/groups/marks/projects/marks_lab_and_oatml/ProteinGym2/EVCouplings/slurm/Beltran_Lehner_2025/EVM-1-%j.err -J EVM1 --array=0-59 --account=marks --wrap='python retrieve_MSA.py "${SLURM_ARRAY_TASK_ID}" 1 uniref100 /n/groups/marks/projects/marks_lab_and_oatml/ProteinGym2/EVCouplings/input/Beltran_Lehner_2025/sequences_1_new.csv'

# rerun 6/3/2025
# bitscore 0.9
# sbatch --cpus-per-task=1 -p short -t 1:00:00 -o /n/groups/marks/projects/marks_lab_and_oatml/ProteinGym2/EVCouplings/slurm/Beltran_Lehner_2025/EVM-1-%j.out -e /n/groups/marks/projects/marks_lab_and_oatml/ProteinGym2/EVCouplings/slurm/Beltran_Lehner_2025/EVM-1-%j.err -J EVM1 --array=0-101 --account=marks --wrap='python retrieve_MSA.py "${SLURM_ARRAY_TASK_ID}" 0.9 uniref100 /n/groups/marks/projects/marks_lab_and_oatml/ProteinGym2/EVCouplings/input/Beltran_Lehner_2025/sequences_0.9_round3.csv'

# # bitscore 1.1
# sbatch --cpus-per-task=1 -p short -t 1:00:00 -o /n/groups/marks/projects/marks_lab_and_oatml/ProteinGym2/EVCouplings/slurm/Beltran_Lehner_2025/EVM-1-%j.out -e /n/groups/marks/projects/marks_lab_and_oatml/ProteinGym2/EVCouplings/slurm/Beltran_Lehner_2025/EVM-1-%j.err -J EVM1 --array=0-101 --account=marks --wrap='python retrieve_MSA.py "${SLURM_ARRAY_TASK_ID}" 1.1 uniref100 /n/groups/marks/projects/marks_lab_and_oatml/ProteinGym2/EVCouplings/input/Beltran_Lehner_2025/sequences_1.1_round3.csv'

# # bitscore 1.2
# sbatch --cpus-per-task=1 -p short -t 1:00:00 -o /n/groups/marks/projects/marks_lab_and_oatml/ProteinGym2/EVCouplings/slurm/Beltran_Lehner_2025/EVM-1-%j.out -e /n/groups/marks/projects/marks_lab_and_oatml/ProteinGym2/EVCouplings/slurm/Beltran_Lehner_2025/EVM-1-%j.err -J EVM1 --array=0-34 --account=marks --wrap='python retrieve_MSA.py "${SLURM_ARRAY_TASK_ID}" 1.2 uniref100 /n/groups/marks/projects/marks_lab_and_oatml/ProteinGym2/EVCouplings/input/Beltran_Lehner_2025/sequences_1.2_round3.csv'

# # aws rerun bitscore 0.8
# sbatch --cpus-per-task=1 -p short -t 1:00:00 -o /n/groups/marks/projects/marks_lab_and_oatml/ProteinGym2/EVCouplings/slurm/Beltran_Lehner_2025/EVM-0.8-%j.out -e /n/groups/marks/projects/marks_lab_and_oatml/ProteinGym2/EVCouplings/slurm/Beltran_Lehner_2025/EVM-0.8-%j.err -J EVM0.8 --array=0-16 --account=marks --wrap='python retrieve_MSA.py "${SLURM_ARRAY_TASK_ID}" 0.8 uniref100 /n/groups/marks/projects/marks_lab_and_oatml/ProteinGym2/EVCouplings/input/Beltran_Lehner_2025/sequences_0.8_aws_rerun.csv'

# # aws rerun bitscore 0.9
# sbatch --cpus-per-task=1 -p short -t 1:00:00 -o /n/groups/marks/projects/marks_lab_and_oatml/ProteinGym2/EVCouplings/slurm/Beltran_Lehner_2025/EVM-0.9-%j.out -e /n/groups/marks/projects/marks_lab_and_oatml/ProteinGym2/EVCouplings/slurm/Beltran_Lehner_2025/EVM-0.9-%j.err -J EVM0.9 --array=0-16 --account=marks --wrap='python retrieve_MSA.py "${SLURM_ARRAY_TASK_ID}" 0.9 uniref100 /n/groups/marks/projects/marks_lab_and_oatml/ProteinGym2/EVCouplings/input/Beltran_Lehner_2025/sequences_0.9_aws_rerun.csv'

# # aws rerun bitscore 1
# sbatch --cpus-per-task=1 -p short -t 1:00:00 -o /n/groups/marks/projects/marks_lab_and_oatml/ProteinGym2/EVCouplings/slurm/Beltran_Lehner_2025/EVM-1-%j.out -e /n/groups/marks/projects/marks_lab_and_oatml/ProteinGym2/EVCouplings/slurm/Beltran_Lehner_2025/EVM-1-%j.err -J EVM1 --array=0-5 --account=marks --wrap='python retrieve_MSA.py "${SLURM_ARRAY_TASK_ID}" 1 uniref100 /n/groups/marks/projects/marks_lab_and_oatml/ProteinGym2/EVCouplings/input/Beltran_Lehner_2025/sequences_1_aws_rerun.csv'

# # aws rerun bitscore 1.1
# sbatch --cpus-per-task=1 -p short -t 1:00:00 -o /n/groups/marks/projects/marks_lab_and_oatml/ProteinGym2/EVCouplings/slurm/Beltran_Lehner_2025/EVM-1.1-%j.out -e /n/groups/marks/projects/marks_lab_and_oatml/ProteinGym2/EVCouplings/slurm/Beltran_Lehner_2025/EVM-1.1-%j.err -J EVM1.1 --array=0-5 --account=marks --wrap='python retrieve_MSA.py "${SLURM_ARRAY_TASK_ID}" 1.1 uniref100 /n/groups/marks/projects/marks_lab_and_oatml/ProteinGym2/EVCouplings/input/Beltran_Lehner_2025/sequences_1.1_aws_rerun.csv'

# aws rerun bitscore 1.1 - round 3
# sbatch --cpus-per-task=1 -p short -t 1:00:00 -o /n/groups/marks/projects/marks_lab_and_oatml/ProteinGym2/EVCouplings/slurm/Beltran_Lehner_2025/EVM-1.1-%j.out -e /n/groups/marks/projects/marks_lab_and_oatml/ProteinGym2/EVCouplings/slurm/Beltran_Lehner_2025/EVM-1.1-%j.err -J EVM1.1 --array=0-16 --account=marks --wrap='python retrieve_MSA.py "${SLURM_ARRAY_TASK_ID}" 1.1 uniref100 /n/groups/marks/projects/marks_lab_and_oatml/ProteinGym2/EVCouplings/input/Beltran_Lehner_2025/sequences_1.1_aws_rerun2.csv'

# round 4
# bitscore_list=(1.5 0.8 0.9 1.0 1.2 1.3 1.4 0.6)
# #bitscore_list=(0.95)
# for bitscore in ${bitscore_list[@]}; do
#     filename="/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym2/EVCouplings/input/Beltran_Lehner_2025/sequences_${bitscore}_round4.csv"
#     echo $filename
#     line_count=$(wc -l < "$filename" | awk '{print $1}')
#     echo ${line_count}
#     sbatch --cpus-per-task=1 -p short -t 1:00:00 -o /n/groups/marks/projects/marks_lab_and_oatml/ProteinGym2/EVCouplings/slurm/Beltran_Lehner_2025/EVM-${bitscore}-%j.out -e /n/groups/marks/projects/marks_lab_and_oatml/ProteinGym2/EVCouplings/slurm/Beltran_Lehner_2025/EVM-${bitscore}-%j.err -J EVM${bitscore} --array=0-"$((line_count - 2))" --account=marks --wrap='python retrieve_MSA.py ${SLURM_ARRAY_TASK_ID} '"${bitscore} uniref100 ${filename}"
# done

# round 5
bitscore_list=(1.0 1.05 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8)
for bitscore in ${bitscore_list[@]}; do
    filename="/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym2/EVCouplings/input/Beltran_Lehner_2025/sequences_${bitscore}_round5.csv"
    echo $filename
    line_count=$(wc -l < "$filename" | awk '{print $1}')
    echo ${line_count}
    sbatch --cpus-per-task=1 -p short -t 1:00:00 -o /n/groups/marks/projects/marks_lab_and_oatml/ProteinGym2/EVCouplings/slurm/Beltran_Lehner_2025/EVM-${bitscore}-%j.out -e /n/groups/marks/projects/marks_lab_and_oatml/ProteinGym2/EVCouplings/slurm/Beltran_Lehner_2025/EVM-${bitscore}-%j.err -J EVM${bitscore} --array=0-"$((line_count - 2))" --account=marks --wrap='python retrieve_MSA.py ${SLURM_ARRAY_TASK_ID} '"${bitscore} uniref100 ${filename}"
done