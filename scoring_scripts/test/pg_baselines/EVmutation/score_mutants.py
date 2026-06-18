import os
import pandas as pd
import argparse
from glob import glob

from evcouplings.couplings import CouplingsModel
from evcouplings.mutate import predict_mutation_table, single_mutant_matrix
import calculations

def score_multi_aa(DMS_filename,DMS_id, DMS_folder, output_score_folder, couplings_model, offset=0):
    """
    Makes EVcouplings predictions (epistatic and independent) for multi-AA mutants. Calculates Spearman between 
    predictions and DMS dataset.
    """
    c = CouplingsModel(couplings_model)
    c0 = c.to_independent_model()
    data = pd.read_csv(DMS_folder + os.sep + DMS_filename)
    # print(data["aa_seq"])
    # data["mutant"] = data["wt_aa"] + data["position"].astype(str) + data["mut_aa"]
    data = calculations.predict_mutation_table(c, data, "prediction_epistatic", sep=":", offset=offset)
    data = calculations.predict_mutation_table(c0, data, "prediction_independent", sep=":", offset=offset)
    data.to_csv(output_score_folder + os.sep + DMS_id + ".csv", index=False)


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Score EVcouplings models on DMS data')
    parser.add_argument('--DMS_reference_file_path', type=str, help="Path to DMS reference file")
    parser.add_argument('--DMS_data_folder',type=str, help="Path to DMS data folder")
    parser.add_argument('--model_folder',type=str, help="Path to EVcouplings model folder")
    parser.add_argument('--output_scores_folder',type=str, help="Path to output score folder")
    parser.add_argument('--DMS_index',type=int,help="Index of DMS assay to score")
    args = parser.parse_args()
    mapping = pd.read_csv(args.DMS_reference_file_path)

    list_DMS = mapping["DMS_id"]
    DMS_id = list_DMS[args.DMS_index]

    # Hardcoding RASK_HUMAN_Ursu case (has a special alignment id since it differs from the other RASK_HUMAN assays)
    # if DMS_id == "RASK_HUMAN_Ursu_2020":
    #     UniProt_id = "RASK_HUMAN_Ursu_2020"
    # else:
    #     list_UniProt = mapping["UniProt_ID"]

    #     UniProt_id = list_UniProt[args.DMS_index]
    # if UniProt_id == "F7YBW7_MESOW":
    #     UniProt_id = "F7YBW8_MESOW"

    DMS_filename = mapping["DMS_filename"][mapping["DMS_id"]==DMS_id].values[0]

    sequence = mapping["target_aa_seq"][mapping["DMS_id"]==DMS_id].values[0]

    job_name_prefix = DMS_id


    # offset = mapping["MSA_start"][mapping["DMS_id"]==DMS_id].values[0] - 1
    # offset = mapping['offset'][mapping["DMS_id"]==DMS_id].vsalues[0] - 1
    # print("Offset: {}".format(offset))
    # print(f"{args.model_folder}/{job_name_prefix}.model")
    if len(glob(f"{args.model_folder}/{job_name_prefix}.model")) > 0:
    # if os.path.exists(f"{args.model_folder}/{job_name_prefix}.model"):
        for f in glob(f"{args.model_folder}/{job_name_prefix}.model"):
            score_multi_aa(DMS_filename=DMS_filename, 
                            DMS_id=DMS_id,
                            DMS_folder=args.DMS_data_folder, 
                            output_score_folder=args.output_scores_folder, 
                            couplings_model=f)
    else:
        print(f"No model file for: {job_name_prefix}")