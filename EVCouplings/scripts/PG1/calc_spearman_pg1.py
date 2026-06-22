from glob import glob
import pandas as pd
import os
from scipy.stats import spearmanr
import argparse

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Compute Spearman of EVCouplings models on DMS data')
    parser.add_argument('--model_score_dir', type=str, help="Path to output score folder")
    parser.add_argument('--output_csv', type=str, help="Path to output Spearman csv")
    args = parser.parse_args()

    site_independent_spearman = []
    evmutation_spearman = []
    id_list = []
    for f in glob(f"{args.model_score_dir}/*.csv"):
        df = pd.read_csv(f)
        id_list.append(os.path.basename(f))
        site_independent_spearman.append(spearmanr(df['DMS_score'], df['prediction_independent']).statistic)
        evmutation_spearman.append(spearmanr(df['DMS_score'], df['prediction_epistatic']).statistic)

    performance_df = pd.DataFrame({'id': id_list,
                                   'EVmutation_spearman': evmutation_spearman,
                                   'Site_independent_spearman': site_independent_spearman})

    performance_df.to_csv(args.output_csv, index=False)