#!/usr/bin/env python3
"""
Script to run EVCouplings analysis with proper argument parsing.
This script processes protein sequences using EVCouplings with configurable parameters.
"""

import os
import sys
import argparse
import pandas as pd
from pathlib import Path


def parse_arguments():
    """Parse command line arguments."""
    parser = argparse.ArgumentParser(
        description="Run EVCouplings analysis on protein sequences",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  %(prog)s 0 30 uniref100 reference.csv /path/to/fasta /path/to/output
  %(prog)s --protein-index 5 --bitscore 25 --database uniref90 --reference-file data.csv --ref-seq-folder ./sequences --output-folder ./results
        """
    )
    
    # Required arguments
    parser.add_argument(
        'protein_index',
        type=int,
        help='Index of the protein to process in the reference file (0-based)'
    )
    
    parser.add_argument(
        'bitscore',
        type=str,
        help='Bitscore threshold for sequence search'
    )
    
    parser.add_argument(
        'database',
        type=str,
        help='Database name (e.g., uniref100, uniref90)'
    )
    
    parser.add_argument(
        'reference_file',
        type=str,
        help=        'Path to CSV file with columns: UniProt_ID, target_aa_seq, MSA_theta (MSA_region is optional)'
    )
    
    parser.add_argument(
        'ref_seq_folder',
        type=str,
        help='Folder containing FASTA files (one sequence per file)'
    )
    
    parser.add_argument(
        'output_folder',
        type=str,
        help='Output folder for results'
    )
    
    # Optional arguments
    parser.add_argument(
        '--config-path',
        type=str,
        default=None,
        help='Custom path to EVCouplings config file (default: auto-generated based on database)'
    )
    
    parser.add_argument(
        '--column-coverage',
        type=str,
        default='0',
        help='Column coverage constraint (default: 0 - no constraint)'
    )
    
    parser.add_argument(
        '--stages',
        type=str,
        default=None,
        help='Specific stages to run (e.g., "mutate")'
    )
    
    parser.add_argument(
        '--dry-run',
        action='store_true',
        help='Print the command that would be executed without running it'
    )
    
    parser.add_argument(
        '--verbose',
        action='store_true',
        help='Enable verbose output'
    )
    
    return parser.parse_args()


def validate_inputs(args):
    """Validate input arguments and files."""
    errors = []
    
    # Check if reference file exists
    if not os.path.exists(args.reference_file):
        errors.append(f"Reference file not found: {args.reference_file}")
    
    # Check if reference sequence folder exists
    if not os.path.exists(args.ref_seq_folder):
        errors.append(f"Reference sequence folder not found: {args.ref_seq_folder}")
    
    # Try to read the reference file
    try:
        reference_df = pd.read_csv(args.reference_file)
        required_columns = ['UniProt_ID', 'target_aa_seq', 'MSA_theta']
        missing_columns = [col for col in required_columns if col not in reference_df.columns]
        if missing_columns:
            errors.append(f"Missing required columns in reference file: {missing_columns}")
        
        # Check if protein index is valid
        if args.protein_index < 0 or args.protein_index >= len(reference_df):
            errors.append(f"Protein index {args.protein_index} is out of range (0-{len(reference_df)-1})")
        
    except Exception as e:
        errors.append(f"Error reading reference file: {e}")
    
    if errors:
        print("Validation errors:")
        for error in errors:
            print(f"  - {error}")
        sys.exit(1)
    
    return reference_df


def main():
    """Main function to run EVCouplings analysis."""
    # Clear SLURM environment variables to enable sbatch from interactive node
    os.environ.pop("SLURM_CPU_BIND", None)
    os.environ.pop("SLURM_MEM_PER_NODE", None)
    
    # Parse arguments
    args = parse_arguments()
    
    if args.verbose:
        print("Arguments:")
        for arg, value in vars(args).items():
            print(f"  {arg}: {value}")
        print()
    
    # Validate inputs
    reference_df = validate_inputs(args)
    
    # Set up configuration file path
    if args.config_path:
        config = args.config_path
    else:
        config = f"/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym2/EVCouplings/input/evmutation_proteingym_config_{args.database}.txt"
    
    # Check if config file exists
    if not os.path.exists(config):
        print(f"Warning: Config file not found: {config}")
    
    # Extract protein information
    protein = reference_df["UniProt_ID"][args.protein_index]
    target_sequence = reference_df["target_aa_seq"][args.protein_index]
    fasta_sequence_file = os.path.join(args.ref_seq_folder, f"{protein}.fa")
    
    # Check if FASTA file exists, create it if it doesn't
    if not os.path.exists(fasta_sequence_file):
        if args.verbose:
            print(f"FASTA file not found: {fasta_sequence_file}")
            print(f"Creating FASTA file with sequence from reference file...")
        
        # Create the directory if it doesn't exist
        os.makedirs(args.ref_seq_folder, exist_ok=True)
        
        # Write the FASTA file
        try:
            with open(fasta_sequence_file, 'w') as f:
                f.write(f">{protein}\n")
                # Write sequence with proper line wrapping (80 characters per line)
                sequence = str(target_sequence).strip()
                for i in range(0, len(sequence), 80):
                    f.write(sequence[i:i+80] + "\n")
            
            if args.verbose:
                print(f"Successfully created FASTA file: {fasta_sequence_file}")
        
        except Exception as e:
            print(f"Error: Could not create FASTA file {fasta_sequence_file}: {e}")
            sys.exit(1)
    else:
        if args.verbose:
            print(f"Using existing FASTA file: {fasta_sequence_file}")
    
    # Calculate theta (1 - MSA_theta)
    theta = str(1 - reference_df["MSA_theta"][args.protein_index])
    
    # Get region information (optional column)
    region = reference_df.get("MSA_region", pd.Series([None] * len(reference_df)))[args.protein_index]
    
    # Create output directory
    protein_output_dir = os.path.join(args.output_folder, protein)
    os.makedirs(protein_output_dir, exist_ok=True)
    
    # Build command
    base_cmd = [
        "evcouplings",
        "--protein", protein,
        "-b", args.bitscore,
        "-s", fasta_sequence_file,
        "--theta", theta,
        "--colcov", args.column_coverage,
    ]
    
    # Determine job name prefix and add region if specified
    if pd.isna(region) or region == '':
        job_name_prefix = os.path.join(
            protein_output_dir,
            f"{protein}_bit_{args.bitscore}_theta_{theta}_colcov_{args.column_coverage}"
        )
    else:
        job_name_prefix = os.path.join(
            protein_output_dir,
            f"{protein}_bit_{args.bitscore}_region_{region}_theta_{theta}_colcov_{args.column_coverage}"
        )
        base_cmd.extend(["--region", region])
    
    # Add remaining arguments
    base_cmd.extend([
        "--prefix", job_name_prefix,
        config,
        "--yolo"
    ])
    
    # Add stages if specified
    if args.stages:
        base_cmd.extend(["--stages", args.stages])
    
    # Convert to string command
    cmd = " ".join(base_cmd)
    
    if args.verbose or args.dry_run:
        print(f"Executing command:")
        print(f"  {cmd}")
        print()
    
    if args.dry_run:
        print("Dry run - command not executed")
        return
    
    # Execute the command
    if args.verbose:
        print("Running EVCouplings...")
    
    exit_code = os.system(cmd)
    
    if exit_code != 0:
        print(f"Error: Command failed with exit code {exit_code}")
        sys.exit(1)
    
    if args.verbose:
        print("EVCouplings completed successfully!")


if __name__ == "__main__":
    main()