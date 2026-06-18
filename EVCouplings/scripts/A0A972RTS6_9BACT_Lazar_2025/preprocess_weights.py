import numpy as np
weights_file = np.load('/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/MSA_weights/PG_repo/DMS_msa_weights_PG2/A0A972RTS6_9BACT_Lazar_2025.npy')
np.savetxt('/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym2/EVCouplings/output/A0A972RTS6_9BACT_Lazar_2025/A0A972RTS6_9BACT_Lazar_2025.txt', weights_file, delimiter='\n', fmt="%.2f")
