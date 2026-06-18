import os
import sys
import pandas as pd

os.environ.pop("SLURM_CPU_BIND", None) # to enable sbatch from an interactive node
os.environ.pop("SLURM_MEM_PER_NODE", None) # to enable sbatch from an interactive node

protein_index = int(sys.argv[1])
bitscore = str(sys.argv[2])
database = sys.argv[3]
print(sys.argv[4])
reference_file = pd.read_csv(sys.argv[4])

root = "/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym2/EVCouplings"
# change all the directories below
ref_seq_folder = f"{root}/input/Beltran_Lehner_2025/fasta"
output_folder = f"{root}/output/Beltran_Lehner_2025/{database}"
# reference_file = pd.read_csv(f"{root}/input/Beltran_Lehner_2025/sequences.csv")

protein = reference_file["UniProt_ID"][protein_index]
fasta_sequence_file = ref_seq_folder + os.sep + protein + ".fa"
colcov = str(0) # No constraint on column coverage
theta = str(1 - reference_file["MSA_theta"][protein_index]) # 1 - 0.2
region = reference_file["MSA_region"][protein_index]

# copied from Pascal, only using uniref100 now
config = f"{root}/input/evmutation_proteingym_config_{database}.txt"

if pd.isna(region) or region == '':
    job_name_prefix = output_folder + os.sep + protein + os.sep + protein +"_bit_"+bitscore+ "_theta_" + theta + "_colcov_" + colcov
    os.system("evcouplings --protein "+protein+" -b "+bitscore+" -s "+fasta_sequence_file+" --theta "+theta+" --colcov "+colcov+" --prefix "+job_name_prefix+" "+config+" --yolo") #" --stages mutate --yolo")
else:
    job_name_prefix = output_folder + os.sep + protein + os.sep + protein +"_bit_"+bitscore+"_region_"+ region + "_theta_" + theta + "_colcov_" + colcov
    os.system("evcouplings --protein "+protein+" --region "+region+" -b "+bitscore+" -s "+fasta_sequence_file+" --theta "+theta+" --colcov "+colcov+" --prefix "+job_name_prefix+" "+config+" --yolo")


