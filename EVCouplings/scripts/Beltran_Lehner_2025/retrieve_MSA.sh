#!/bin/bash 
#SBATCH --cpus-per-task=1
#SBATCH -p short
#SBATCH -t 1:00:00
#SBATCH --output=/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym2/EVCouplings/slurm/Beltran_Lehner_2025/EVM-test-%j.out
#SBATCH --error=/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym2/EVCouplings/slurm/Beltran_Lehner_2025/EVM-test-%j.err
#SBATCH --job-name="EVM"
#SBATCH --array=0-521
#SBATCH --account=marks

module load gcc/6.2.0

source /home/yw222/miniforge3/bin/activate evcouplings_20250324

# add 0.1-0.9
# python retrieve_MSA.py $SLURM_ARRAY_TASK_ID 0.1 uniref100
# python retrieve_MSA.py $SLURM_ARRAY_TASK_ID 0.2 uniref100
# python retrieve_MSA.py $SLURM_ARRAY_TASK_ID 0.3 uniref100
# python retrieve_MSA.py $SLURM_ARRAY_TASK_ID 0.4 uniref100
# python retrieve_MSA.py $SLURM_ARRAY_TASK_ID 0.5 uniref100
# python retrieve_MSA.py $SLURM_ARRAY_TASK_ID 0.6 uniref100
# python retrieve_MSA.py $SLURM_ARRAY_TASK_ID 0.7 uniref100
# python retrieve_MSA.py $SLURM_ARRAY_TASK_ID 0.8 uniref100
# python retrieve_MSA.py $SLURM_ARRAY_TASK_ID 0.9 uniref100

python retrieve_MSA.py $SLURM_ARRAY_TASK_ID 0.7 uniref100
