# rename EVE models trained on AWS to be in the format as those trained on O2
import sys
import os
import pandas as pd

df = pd.read_csv('/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym2/EVCouplings/output/Beltran_Lehner_2025/temp_ref_file.csv')
seeds = ['1000', '2000', '3000', '4000', '5000']
EVE_model_dir = '/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym2/DMS_EVE_models/threshold_focus_cols_frac_gaps'
for _, row in df.iterrows():
    DMS_id = row['DMS_id']
    prefix = row['MSA_filename'].removesuffix(".a2m")
    
    if not os.path.exists(os.path.join(EVE_model_dir, prefix+"_seed_1000")):
        for seed in seeds:
            os.rename(os.path.join(EVE_model_dir, DMS_id+"_rseed_"+seed+"_proteingym_v2_20251106_final"), os.path.join(EVE_model_dir, prefix+"_seed_"+seed))
