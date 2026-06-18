import argparse
import os
import pandas as pd
import sys
import inspect

sys.path.insert(0, "/n/groups/marks/users/elain/PG2/ProteinGym/proteingym")
from utils.msa_utils import MSA_processing

print(f"Path to the module containing '{MSA_processing.__name__}': {inspect.getfile(MSA_processing)}")

def get_aln_stats(protein, MSA_location, weights_location, align_stats_filename, threshold_focus_cols_frac_gaps=0.3, skip_one_hot_encodings=False):
    '''
    modified from get_aln_stats on https://github.com/aaronkollasch/EVE/blob/master/scripts/get_alignment_stats.py
    remove all AWS commands
    '''

    msa = MSA_processing(
        MSA_location=MSA_location,
        weights_location=weights_location,
        threshold_focus_cols_frac_gaps=threshold_focus_cols_frac_gaps,
        use_weights=True,
        weights_calc_method="eve",
        skip_one_hot_encodings=skip_one_hot_encodings,
        num_cpus=-1,
    )

    num_seqs = 0
    with open(MSA_location) as f:
        for line in f:
            if line.startswith(">"):
                num_seqs += 1

    result = {
        "protein": [protein],
        "num_seqs": [msa.num_sequences],
        "num_seqs_unfiltered": [num_seqs],
        "perc_filtered": [msa.num_sequences / num_seqs],
        "n_eff": [msa.Neff],
        "n_eff_l": [msa.Neff / len(msa.focus_seq)],
        "seq_len": [len(msa.focus_seq)],
        "num_cov": [msa.one_hot_encoding.shape[1]],
        "perc_cov": [msa.one_hot_encoding.shape[1] / len(msa.focus_seq)],
    }

    pd.DataFrame(result).to_csv(align_stats_filename, index=False)

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Recalculate the weights of a subsample of sequences')
    parser.add_argument('--DMS_reference_file_path', type=str, help='List of proteins and corresponding MSA file name')
    parser.add_argument('--protein_index', type=int, help='Row index of protein in input mapping file')
    parser.add_argument('--MSA_data_folder', type=str, help='Folder where MSAs are stored')
    parser.add_argument('--threshold_focus_cols_frac_gaps', type=float, help='maximum fraction of gaps allowed in the focus columns; this number needs to match between weights calculation and EVE model training and inference')
    parser.add_argument('--MSA_weights_folder', type=str, help='Location where weights for each sequence in the MSA will be stored')
    parser.add_argument('--align_stats_folder', type=str, help='Location where alignment statistics for each sequence in the MSA will be stored')

    args = parser.parse_args()

    assert os.path.isfile(args.DMS_reference_file_path), 'MSA list file does not exist: {}'.format(args.DMS_reference_file_path)
    mapping_file = pd.read_csv(args.DMS_reference_file_path)
    DMS_id = mapping_file['DMS_id'][args.protein_index]
    protein_name = mapping_file['MSA_filename'][args.protein_index].split(".a2m")[0]
    weights_location = args.MSA_weights_folder + os.sep + mapping_file['weight_file_name'][args.protein_index]
    MSA_location = args.MSA_data_folder + os.sep + mapping_file['MSA_filename'][args.protein_index]
    if not mapping_file['weight_file_name'][args.protein_index].startswith(DMS_id):
        print(f"Warning: DMS id does not match MSA weights filename: {DMS_id} vs {mapping_file['weight_file_name'][args.protein_index]}. Continuing for now.")

    align_stats_filename = args.align_stats_folder + os.sep + protein_name + ".csv"

    get_aln_stats(DMS_id, MSA_location, weights_location, align_stats_filename)