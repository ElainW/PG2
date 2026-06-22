import os
import pandas as pd
import argparse
from glob import glob

from evcouplings.couplings import CouplingsModel
from evcouplings.mutate import predict_mutation_table, single_mutant_matrix
import calculations


def score_multi_aa(DMS_filename, DMS_id, DMS_folder, output_score_folder, couplings_model, bitscore, offset=0):
    """
    Makes EVcouplings predictions (epistatic and independent) for multi-AA mutants. Calculates Spearman between
    predictions and DMS dataset.
    """
    c = CouplingsModel(couplings_model)
    c0 = c.to_independent_model()
    data = pd.read_csv(DMS_folder + os.sep + DMS_filename)
    data = calculations.predict_mutation_table(c, data, "prediction_epistatic", sep=":", offset=offset)
    data = calculations.predict_mutation_table(c0, data, "prediction_independent", sep=":", offset=offset)
    model_basename = os.path.splitext(os.path.basename(couplings_model))[0]
    data.to_csv(os.path.join(output_score_folder, DMS_id + "_" + bitscore + ".csv"), index=False)


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Score EVcouplings models (PG1, multi-bitscore) on DMS data')
    parser.add_argument('--DMS_reference_file_path', type=str, help="Path to trimmed DMS reference file (DMS_index, DMS_id, DMS_filename, UniProt_ID, MSA_start)")
    parser.add_argument('--DMS_data_folder', type=str, help="Path to DMS data folder")
    parser.add_argument('--model_folder', type=str, help="Path to EVcouplings model folder")
    parser.add_argument('--output_scores_folder', type=str, help="Path to output score folder")
    parser.add_argument('--DMS_index', type=int, help="Index of DMS assay to score")
    parser.add_argument('--model_suffix', type=str, help="String after UniProt_ID")
    args = parser.parse_args()
    mapping = pd.read_csv(args.DMS_reference_file_path)

    list_DMS = mapping["DMS_id"]
    DMS_id = list_DMS[args.DMS_index]

    DMS_filename = mapping["DMS_filename"][mapping["DMS_id"] == DMS_id].values[0]
    UniProt_ID = mapping["UniProt_ID"][mapping["DMS_id"] == DMS_id].values[0]
    offset = int(mapping["MSA_start"][mapping["DMS_id"] == DMS_id].values[0]) - 1

    # Models are named {UniProt_ID}_seqcov50_colcov50_theta{theta}_b{bitscore}.model.
    # theta is one of {0.8, 0.99} (unrelated to the MSA_theta reference column) and
    # bitscore is one of {0.03, 0.04, 0.05, 0.1, 0.3, 0.5} - not every combination
    # necessarily has a model (some EVcouplings runs fail), so both are wildcarded.
    # Each matched theta/bitscore combination is a distinct model, scored separately.
    model_pattern = f"{args.model_folder}/{UniProt_ID}{args.model_suffix}.model"
    matched_models = glob(model_pattern)

    if len(matched_models) > 0:
        for f in matched_models:
            bitscore = os.path.basename(f).split('_')[-1].removesuffix('.model')
            score_multi_aa(DMS_filename=DMS_filename,
                           DMS_id=DMS_id,
                           DMS_folder=args.DMS_data_folder,
                           output_score_folder=args.output_scores_folder,
                           couplings_model=f,
                           bitscore=bitscore,
                           offset=offset)
    else:
        print(f"No model file for: {DMS_id} (UniProt_ID: {UniProt_ID}, expected pattern: {model_pattern})")
