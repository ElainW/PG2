import sys
import textwrap
sys.path.append("/n/groups/marks/users/elain/PG2/ProteinGym")
from proteingym.utils.msa_utils import MSA_processing

def write_msa(seq_name_to_sequence_dict, output_file_location):
    with open(output_file_location, 'w') as f_out:
        for key, value in seq_name_to_sequence_dict.items():
            f_out.write(key + '\n')
            f_out.write(textwrap.fill("".join(value), width=162))
            f_out.write('\n')

msa = MSA_processing(
        MSA_location="/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/MSA_files/PG_repo/DMS_MSA_PG2/A0A972RTS6_9BACT_Lazar_2025.a2m", weights_location="/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/MSA_weights/PG_repo/DMS_msa_weights_PG2/A0A972RTS6_9BACT_Lazar_2025.npy",
        threshold_focus_cols_frac_gaps=1.0)

write_msa(msa.seq_name_to_sequence, "/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym2/EVCouplings/output/A0A972RTS6_9BACT_Lazar_2025/A0A972RTS6_9BACT_Lazar_2025.a2m")