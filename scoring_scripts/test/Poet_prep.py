import argparse
import os
import pandas as pd
import sys
from Bio.SeqIO.FastaIO import SimpleFastaParser
import subprocess

def convert_a2m_to_a3m(input_a2m, a3m_directory):
    
    output_a3m = a3m_directory + os.path.basename(input_a2m).removesuffix("a2m") + 'a3m'
    
    with open(input_a2m) as handle, open(output_a3m, 'w') as f_out:
        for values in SimpleFastaParser(handle):
            f_out.write(f">{values[0]}\n")
            f_out.write(values[1].replace(".", "") + "\n")

    subprocess.run(["zstd", output_a3m])
    subprocess.run(["rm", output_a3m])

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Generate the .a3m.zst files for POET')
    parser.add_argument('--DMS_reference_file_path', type=str, help='List of proteins and corresponding MSA file name')
    parser.add_argument('--range', type=str, help='Specify a range of protein indices, e.g., "0-500"')
    parser.add_argument('--protein_index', type=int, nargs='+', help='Row index of protein in input mapping file')
    parser.add_argument('--MSA_data_folder', type=str, help='Folder where MSAs are stored')

    args = parser.parse_args()

    assert os.path.isfile(args.DMS_reference_file_path), 'MSA list file does not exist: {}'.format(args.DMS_reference_file_path)
    mapping_file = pd.read_csv(args.DMS_reference_file_path)

    a3m_directory = args.MSA_data_folder + '/a3m/'
    os.makedirs(a3m_directory, exist_ok=True)

    if args.protein_index:
        for protein_index in args.protein_index:
            MSA_location = args.MSA_data_folder + os.sep + mapping_file['MSA_filename'][protein_index]
            convert_a2m_to_a3m(MSA_location, a3m_directory)

    if args.range:
        try:
            start_str, end_str = args.range.split('-')
            start = int(start_str)
            end = int(end_str)
    
            # Generate the list of numbers
            protein_index_list = list(range(start, end + 1))
            print(f"Working on protein indices: {protein_index_list}")

            for protein_index in protein_index_list:
                MSA_location = args.MSA_data_folder + os.sep + mapping_file['MSA_filename'][protein_index]
                convert_a2m_to_a3m(MSA_location, a3m_directory)
        except ValueError:
            print("Error: Invalid range format. Please use 'start-end' (e.g., '0-500').")
