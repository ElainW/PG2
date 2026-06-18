#!/bin/bash 
# rerun the MSA based on recommended bitscore from /n/groups/marks/projects/marks_lab_and_oatml/ProteinGym2/EVCouplings/scripts/Beltran_Lehner_2025/check_msa.ipynb
module load gcc/6.2.0

source /home/yw222/miniforge3/bin/activate evcouplings_20250324 # will update soon on RHEL

ROOT=/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym2/EVCouplings/

# initial run on all the sequences at e.g., bitscore = 0.7
# array range: if n=100, then range: 0-99
# may need to remove --account=marks
sbatch --cpus-per-task=1 -p short -t 1:00:00 -o /n/groups/marks/projects/marks_lab_and_oatml/ProteinGym2/EVCouplings/slurm/Beltran_Lehner_2025/EVM-test-%j.out -e /n/groups/marks/projects/marks_lab_and_oatml/ProteinGym2/EVCouplings/slurm/Beltran_Lehner_2025/EVM-0.7-%j.err -J EVM0.7 --array=0-99 --account=marks --wrap='python retrieve_MSA.py "${SLURM_ARRAY_TASK_ID}" 0.7 uniref100 "${ROOT}"/input/Beltran_Lehner_2025/sequences.csv "${ROOT}"/input/Beltran_Lehner_2025/fasta
"${ROOT}"/output/Beltran_Lehner_2025/uniref100'

# rerun at e.g. bitscore 0.5
# array range: if n=20, then range: 0-19
sbatch --cpus-per-task=1 -p short -t 1:00:00 -o /n/groups/marks/projects/marks_lab_and_oatml/ProteinGym2/EVCouplings/slurm/Beltran_Lehner_2025/EVM-test-%j.out -e /n/groups/marks/projects/marks_lab_and_oatml/ProteinGym2/EVCouplings/slurm/Beltran_Lehner_2025/EVM-0.5-%j.err -J EVM0.5 --array=0-19 --account=marks --wrap='python retrieve_MSA.py "${SLURM_ARRAY_TASK_ID}" 0.5 uniref100 /n/groups/marks/projects/marks_lab_and_oatml/ProteinGym2/EVCouplings/input/Beltran_Lehner_2025/sequences_0.5_add.csv
"${ROOT}"/input/Beltran_Lehner_2025/fasta
"${ROOT}"/output/Beltran_Lehner_2025/uniref100'
