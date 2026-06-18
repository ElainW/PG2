module load conda/miniforge3/24.11.3-0
mamba activate /n/groups/marks/projects/marks_lab_and_oatml/ProteinGym2/EVCouplings/envs/pg2_evc

# try with the same script as before, now with updated configs, test pg2_evc
# will we get the alignment stats calc? if so, does it match the existing AWS calc?
ROOT=/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym2/EVCouplings
# sbatch --cpus-per-task=1 -p short -t 1:00:00 -o /n/groups/marks/projects/marks_lab_and_oatml/ProteinGym2/EVCouplings/slurm/Beltran_Lehner_2025/9Y5K6_PF14604_1.out -e /n/groups/marks/projects/marks_lab_and_oatml/ProteinGym2/EVCouplings/slurm/Beltran_Lehner_2025/9Y5K6_PF14604_1.err -J 9Y5K6_PF14604_1 --array=518 --account=marks --wrap='python retrieve_MSA_test.py ${SLURM_ARRAY_TASK_ID} '"0.7 uniref100 ${ROOT}/input/Beltran_Lehner_2025/sequences_0.7.csv"

# try with Sam's python script
# python 0 30 uniref100 reference.csv /path/to/fasta /path/to/output
  # %(prog)s --protein-index 5 --bitscore 25 --database uniref90 --reference-file data.csv --ref-seq-folder ./sequences --output-folder ./results


sbatch --cpus-per-task=1 -p short -t 1:00:00 -o /n/groups/marks/projects/marks_lab_and_oatml/ProteinGym2/EVCouplings/slurm/Beltran_Lehner_2025/couplings_9Y5K6_PF14604_109.out -e /n/groups/marks/projects/marks_lab_and_oatml/ProteinGym2/EVCouplings/slurm/Beltran_Lehner_2025/couplings_9Y5K6_PF14604_109.err -J 9Y5K6_PF14604_109 --array=518 --account=marks --wrap='python retrieve_MSA_test.py ${SLURM_ARRAY_TASK_ID} '"0.7 uniref100 ${ROOT}/input/Beltran_Lehner_2025/sequences_0.7.csv"