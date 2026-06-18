import sys
from Bio.SeqIO.FastaIO import SimpleFastaParser
    
def convert_a2m_to_a3m(input_a2m, output_a3m):

    with open(input_a2m) as handle, open(output_a3m, 'w') as f_out:
        for values in SimpleFastaParser(handle):
            f_out.write(f">{values[0]}\n")
            f_out.write(values[1].replace(".", "") + "\n")

if __name__ == "__main__":
    convert_a2m_to_a3m(sys.argv[1], sys.argv[2])