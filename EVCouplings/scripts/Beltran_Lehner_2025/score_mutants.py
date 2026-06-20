import os
import pandas as pd
import argparse
from glob import glob

from evcouplings.couplings import CouplingsModel
from evcouplings.mutate import predict_mutation_table, single_mutant_matrix
import calculations


def load_entry_name_to_accession(uniprot_mapping_file_path):
    """
    Loads a two-column, no-header CSV of (accession, entry_name) pairs
    (e.g. idmapping_2025_06_10.csv) and returns a dict mapping
    entry_name -> accession.
    """
    mapping_df = pd.read_csv(uniprot_mapping_file_path, header=None, names=["accession", "entry_name"])
    return dict(zip(mapping_df["entry_name"], mapping_df["accession"]))


def get_model_sample_name(DMS_id, entry_name_to_accession):
    """
    Derives the EVcouplings model sample name from a DMS_id of the form
    <entry_name>_Beltran_2025_<PFxxxx>_<starting_idx>, where entry_name is
    the UniProt mnemonic ID (e.g. R113A_HUMAN). The model directory is
    named with the bare UniProt accession instead (e.g. O15541), which has
    no textual relationship to the entry name, so it requires a lookup.
    """
    entry_name, domain_part = DMS_id.split("_Beltran_2025_")
    accession = entry_name_to_accession[entry_name]
    return f"{accession}_{domain_part}"


def score_multi_aa(DMS_filename, DMS_id, DMS_folder, output_score_folder, couplings_model, offset=0):
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
    data.to_csv(os.path.join(output_score_folder, model_basename + ".csv"), index=False)


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Score EVcouplings models on DMS data')
    parser.add_argument('--DMS_reference_file_path', type=str, help="Path to DMS reference file")
    parser.add_argument('--DMS_data_folder', type=str, help="Path to DMS data folder")
    parser.add_argument('--model_folder', type=str, help="Path to EVcouplings model folder")
    parser.add_argument('--output_scores_folder', type=str, help="Path to output score folder")
    parser.add_argument('--uniprot_mapping_file_path', type=str, help="Path to UniProt accession/entry_name mapping CSV (no header)")
    parser.add_argument('--DMS_index', type=int, help="Index of DMS assay to score")
    args = parser.parse_args()
    mapping = pd.read_csv(args.DMS_reference_file_path)
    entry_name_to_accession = load_entry_name_to_accession(args.uniprot_mapping_file_path)

    list_DMS = mapping["DMS_id"]
    DMS_id = list_DMS[args.DMS_index]

    DMS_filename = mapping["DMS_filename"][mapping["DMS_id"] == DMS_id].values[0]

    model_sample_name = get_model_sample_name(DMS_id, entry_name_to_accession)
    model_pattern = f"{args.model_folder}/{model_sample_name}_bit_*.model"
    matched_models = glob(model_pattern)

    if len(matched_models) > 0:
        for f in matched_models:
            score_multi_aa(DMS_filename=DMS_filename,
                            DMS_id=DMS_id,
                            DMS_folder=args.DMS_data_folder,
                            output_score_folder=args.output_scores_folder,
                            couplings_model=f)
    else:
        print(f"No model file for: {DMS_id} (expected pattern: {model_pattern})")
