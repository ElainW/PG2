import os
import sys
import pandas as pd
import numpy as np
from evcouplings.align.alignment import Alignment
from evcouplings.utils import read_config_file, write_config_file

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
output_folder = f"{root}/output/Beltran_Lehner_2025/evc_test"
# reference_file = pd.read_csv(f"{root}/input/Beltran_Lehner_2025/sequences.csv")

protein = reference_file["UniProt_ID"][protein_index]
fasta_sequence_file = ref_seq_folder + os.sep + protein + ".fa"
# colcov = str(0) # No constraint on column coverage
theta = str(1 - reference_file["MSA_theta"][protein_index]) # 1 - 0.2
region = reference_file["MSA_region"][protein_index]

# copied from Pascal, only using uniref100 now
config = f"{root}/input/evmutation_proteingym_config_{database}_couplings_only.txt"

# test for align only
# if pd.isna(region) or region == '':
#     job_name_prefix = output_folder + os.sep + protein + os.sep + protein +"_bit_"+bitscore+ "_theta_" + theta + "_colcov_70"
#     os.system("evcouplings --protein "+protein+" -b "+bitscore+" -s "+fasta_sequence_file+" --theta "+theta+" --colcov 70"+" --prefix "+job_name_prefix+" "+config+" --yolo --account marks") #" --stages mutate --yolo")
# else:
#     job_name_prefix = output_folder + os.sep + protein + os.sep + protein +"_bit_"+bitscore+"_region_"+ region + "_theta_" + theta + "_colcov_70"
#     os.system("evcouplings --protein "+protein+" --region "+region+" -b "+bitscore+" -s "+fasta_sequence_file+" --theta "+theta+" --colcov 70"+" --prefix "+job_name_prefix+" "+config+" --yolo --account marks")


def uppercase_columns(aln):
    """
    (Reverse the lowercase_column function)
    Change a subset of columns to lowercase character
    and replace "." gaps with "-" gaps
    Change all lower case characters to upper case characters

    Parameters
    ----------
    aln : Alignment object

    Returns
    -------
    Alignment
        Alignment with all uppercase columns
        and only "-" gaps
    """
    columns = np.array([s.islower() for s in aln.matrix[0, :]])
    return aln.apply(
        columns=columns, func=np.char.upper
    ).replace(
        ".", "-", columns=columns
    )


def update_align_cfg(colcov_70_cfg, colcov_0_cfg, colcov_0_alignment_file, seq_len):
    """
    Update the alignment output config file 
    from minimum column coverage = 70
    to look more like that from minimum column coverage = 0
    as this is needed for couplings input at minimum column coverage = 0

    Note: This new alignment output config file has to be in the ${prefix}_colcov_0/align directory

    Parameters
    ----------
    colcov_70_cfg (str): align stage output config file name from minimum column coverage = 70
    colcov_0_cfg (str): align stage output config file name from minimum column coverage = 0
    colcov_0_alignment_file (str): file name of hand-made align stage output alignment
        (converted from colcov_70 to colcov_0)
    seq_len (int): full length of the query sequence from the alignment file

    Returns
    -------
    None
    """
    config = read_config_file(colcov_70_cfg, preserve_order=True)
    config["alignment_file"] = colcov_0_alignment_file
    config["num_sites"] = seq_len
    config["segments"][0][5] = list(range(1, seq_len+1)) 
    
    write_config_file(colcov_0_cfg, config)


# test for couplings only
if pd.isna(region) or region == '':
    job_name_prefix = output_folder + os.sep + protein + os.sep + protein +"_bit_"+bitscore+ "_theta_" + theta + "_colcov_70"
    job_name_prefix_colcov0 = output_folder + os.sep + protein + os.sep + protein +"_bit_"+bitscore+ "_theta_" + theta + "_colcov_0"
    aln_prefix = job_name_prefix + "/align/" + protein +"_bit_"+bitscore+ "_theta_" + theta 
    aln_prefix_colcov0 = job_name_prefix_colcov0 + "/align/" + protein + "_bit_" + bitscore + "_theta_" + theta
    colcov70_alignment = aln_prefix + "_colcov_70" + ".a2m"
    colcov0_alignment = aln_prefix + "_colcov_0" + ".a2m"
    colcov70_alignment_cfg = aln_prefix + "_colcov_70" + "_align.outcfg"
    colcov0_alignment_cfg = aln_prefix_colcov0 + "_colcov_0" + "_align.outcfg"
    with open(colcov70_alignment, "r") as infile, open(colcov0_alignment, 'w') as outfile:
        aln = Alignment.from_file(infile, format="fasta")
        seq_len = aln.L
        out_aln = uppercase_columns(aln)
        out_aln.write(outfile, format="fasta", width=80)
    update_align_cfg(colcov70_alignment_cfg, colcov0_alignment_cfg, colcov0_alignment, seq_len)
    os.system("evcouplings --protein "+protein+" --stages couplings" + " -a "+colcov0_alignment+" -s "+fasta_sequence_file+" --theta "+theta+" --colcov 0"+" --prefix "+job_name_prefix_colcov0+" "+config+" --account marks --yolo")

else:
    job_name_prefix = output_folder + os.sep + protein + os.sep + protein +"_bit_"+bitscore+"_region_"+ region + "_theta_" + theta + "_colcov_70"
    job_name_prefix_colcov0 = output_folder + os.sep + protein + os.sep + protein +"_bit_"+bitscore+"_region_"+ region + "_theta_" + theta + "_colcov_0"
    aln_prefix = job_name_prefix + "/align/" + protein +"_bit_"+bitscore+ "_theta_" + theta
    aln_prefix_colcov0 = job_name_prefix_colcov0 + "/align/" + protein +"_bit_"+bitscore+ "_theta_" + theta
    colcov70_alignment = aln_prefix + "_colcov_70" + ".a2m"
    colcov0_alignment = aln_prefix + "_colcov_0" + ".a2m"
    colcov70_alignment_cfg = aln_prefix + "_colcov_70" + "_align.outcfg"
    colcov70_alignment_cfg = aln_prefix_colcov0 + "_colcov_0" + "_align.outcfg"
    with open(colcov70_alignment, "r") as infile, open(colcov0_alignment, 'w') as outfile:
        aln = Alignment.from_file(infile, format="fasta")
        seq_len = aln.L
        out_aln = uppercase_columns(aln)
        out_aln.write(outfile, format="fasta", width=80)
    update_align_cfg(colcov70_alignment_cfg, colcov0_alignment_cfg, colcov0_alignment, seq_len)
    os.system("evcouplings --protein "+protein+" --stages couplings" + " -a "+colcov0_alignment+" --region "+region+" -s "+fasta_sequence_file+" --theta "+theta+" --colcov 70"+" --prefix "+job_name_prefix_colcov+" "+config+" --account marks --yolo")
