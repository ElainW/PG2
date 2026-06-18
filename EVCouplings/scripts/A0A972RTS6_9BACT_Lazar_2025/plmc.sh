module load conda/miniforge3/24.11.3-0
# mamba activate /n/groups/marks/projects/marks_lab_and_oatml/ProteinGym2/EVCouplings/envs/pg2_evc

# # preprocess the weights file
# python preprocess_weights.py

# # preprocess the .a2m file (eliminate invalid sequences)
# python preprocess_a2m.py

# mamba deactivate
mamba activate /n/groups/marks/projects/marks_lab_and_oatml/ProteinGym2/EVCouplings/envs/pg2_evc
/n/groups/marks/software/plmc/plmc_dev/bin/plmc -f A0A972RTS6_9BACT -g -m 100 -t 0.2 -lh 0.01 -le 0.01 -n 1 -w /n/groups/marks/projects/marks_lab_and_oatml/ProteinGym2/EVCouplings/output/A0A972RTS6_9BACT_Lazar_2025/A0A972RTS6_9BACT_Lazar_2025.txt -o /n/groups/marks/projects/marks_lab_and_oatml/ProteinGym2/EVCouplings/output/A0A972RTS6_9BACT_Lazar_2025/A0A972RTS6_9BACT_Lazar_2025.model /n/groups/marks/projects/marks_lab_and_oatml/ProteinGym2/EVCouplings/output/A0A972RTS6_9BACT_Lazar_2025/A0A972RTS6_9BACT_Lazar_2025.a2m
