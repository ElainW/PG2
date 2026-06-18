#!/bin/bash

# Batch script to run EVCouplings analysis across multiple bitscore thresholds
# Usage: ./run_evcouplings_batch.sh <protein_index> [options]

# Default values
DEFAULT_MIN_BITSCORE=0.1
DEFAULT_MAX_BITSCORE=1.0
DEFAULT_BITSCORE_INTERVAL=0.1
DEFAULT_DATABASE="uniref100"
DEFAULT_REFERENCE_FILE="/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym2/reference_files/pg2_reference_current.csv"
DEFAULT_INPUT_DIR="../input/fasta/"
DEFAULT_OUTPUT_DIR="../output/"
DEFAULT_PYTHON_SCRIPT="retrieve_MSA_v2.py"

# Function to display usage
show_usage() {
    cat << EOF
Usage: $0 <protein_index> [OPTIONS]

Run EVCouplings analysis for a protein across multiple bitscore thresholds.

REQUIRED:
    protein_index           Index of the protein in the reference file (0-based)

OPTIONS:
    -h, --help             Show this help message
    -m, --min-bitscore     Minimum bitscore threshold (default: $DEFAULT_MIN_BITSCORE)
    -M, --max-bitscore     Maximum bitscore threshold (default: $DEFAULT_MAX_BITSCORE)
    -i, --interval         Bitscore interval/step size (default: $DEFAULT_BITSCORE_INTERVAL)
    -d, --database         Database to use (default: $DEFAULT_DATABASE)
    -r, --reference-file   Path to reference CSV file (default: $DEFAULT_REFERENCE_FILE)
    -I, --input-dir        Input directory for FASTA files (default: $DEFAULT_INPUT_DIR)
    -o, --output-dir       Output directory (default: $DEFAULT_OUTPUT_DIR)
    -s, --script           Python script path (default: $DEFAULT_PYTHON_SCRIPT)
    -n, --dry-run          Show commands that would be executed without running them
    -v, --verbose          Enable verbose output
    -p, --parallel         Run jobs in parallel (background processes)
    -j, --max-jobs         Maximum number of parallel jobs (default: 4, only used with -p)

EXAMPLES:
    # Run protein index 217 with default settings
    $0 217

    # Run with custom bitscore range
    $0 217 --min-bitscore 0.2 --max-bitscore 0.8 --interval 0.2

    # Run in parallel with verbose output
    $0 217 --parallel --verbose --max-jobs 2

    # Dry run to see what would be executed
    $0 217 --dry-run --verbose
EOF
}

# Function to validate numeric input
validate_number() {
    local value="$1"
    local name="$2"
    
    if ! [[ "$value" =~ ^[0-9]*\.?[0-9]+$ ]]; then
        echo "Error: $name must be a valid number, got: $value" >&2
        exit 1
    fi
}

# Function to validate integer input
validate_integer() {
    local value="$1"
    local name="$2"
    
    if ! [[ "$value" =~ ^[0-9]+$ ]]; then
        echo "Error: $name must be a valid integer, got: $value" >&2
        exit 1
    fi
}

# Function to check if file exists
check_file_exists() {
    local file="$1"
    local name="$2"
    
    if [[ ! -f "$file" ]]; then
        echo "Error: $name not found: $file" >&2
        exit 1
    fi
}

# Function to check if directory exists or can be created
check_directory() {
    local dir="$1"
    local name="$2"
    
    if [[ ! -d "$dir" ]]; then
        echo "Warning: $name does not exist: $dir" >&2
        echo "Attempting to create directory..." >&2
        mkdir -p "$dir" 2>/dev/null || {
            echo "Error: Could not create $name: $dir" >&2
            exit 1
        }
        echo "Successfully created $name: $dir" >&2
    fi
}

# Function to generate bitscore values
generate_bitscores() {
    local min_val="$1"
    local max_val="$2"
    local interval="$3"
    
    python3 -c "
import numpy as np
bitscores = np.arange($min_val, $max_val + $interval/2, $interval)
for bs in bitscores:
    print(f'{bs:.10f}'.rstrip('0').rstrip('.'))
"
}

# Function to wait for background jobs to complete
wait_for_jobs() {
    local max_jobs="$1"
    
    while (( $(jobs -r | wc -l) >= max_jobs )); do
        sleep 1
    done
}

# Initialize variables
PROTEIN_INDEX=""
MIN_BITSCORE=$DEFAULT_MIN_BITSCORE
MAX_BITSCORE=$DEFAULT_MAX_BITSCORE
BITSCORE_INTERVAL=$DEFAULT_BITSCORE_INTERVAL
DATABASE=$DEFAULT_DATABASE
REFERENCE_FILE=$DEFAULT_REFERENCE_FILE
INPUT_DIR=$DEFAULT_INPUT_DIR
OUTPUT_DIR=$DEFAULT_OUTPUT_DIR
PYTHON_SCRIPT=$DEFAULT_PYTHON_SCRIPT
DRY_RUN=false
VERBOSE=false
PARALLEL=false
MAX_JOBS=4

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            show_usage
            exit 0
            ;;
        -m|--min-bitscore)
            MIN_BITSCORE="$2"
            shift 2
            ;;
        -M|--max-bitscore)
            MAX_BITSCORE="$2"
            shift 2
            ;;
        -i|--interval)
            BITSCORE_INTERVAL="$2"
            shift 2
            ;;
        -d|--database)
            DATABASE="$2"
            shift 2
            ;;
        -r|--reference-file)
            REFERENCE_FILE="$2"
            shift 2
            ;;
        -I|--input-dir)
            INPUT_DIR="$2"
            shift 2
            ;;
        -o|--output-dir)
            OUTPUT_DIR="$2"
            shift 2
            ;;
        -s|--script)
            PYTHON_SCRIPT="$2"
            shift 2
            ;;
        -n|--dry-run)
            DRY_RUN=true
            shift
            ;;
        -v|--verbose)
            VERBOSE=true
            shift
            ;;
        -p|--parallel)
            PARALLEL=true
            shift
            ;;
        -j|--max-jobs)
            MAX_JOBS="$2"
            shift 2
            ;;
        -*)
            echo "Error: Unknown option $1" >&2
            echo "Use -h or --help for usage information" >&2
            exit 1
            ;;
        *)
            if [[ -z "$PROTEIN_INDEX" ]]; then
                PROTEIN_INDEX="$1"
            else
                echo "Error: Unexpected argument: $1" >&2
                echo "Use -h or --help for usage information" >&2
                exit 1
            fi
            shift
            ;;
    esac
done

# Check required arguments
if [[ -z "$PROTEIN_INDEX" ]]; then
    echo "Error: protein_index is required" >&2
    echo "Use -h or --help for usage information" >&2
    exit 1
fi

# Validate inputs
validate_integer "$PROTEIN_INDEX" "protein_index"
validate_number "$MIN_BITSCORE" "min_bitscore"
validate_number "$MAX_BITSCORE" "max_bitscore"
validate_number "$BITSCORE_INTERVAL" "bitscore_interval"
validate_integer "$MAX_JOBS" "max_jobs"

# Check if min <= max
if (( $(echo "$MIN_BITSCORE > $MAX_BITSCORE" | bc -l) )); then
    echo "Error: min_bitscore ($MIN_BITSCORE) must be <= max_bitscore ($MAX_BITSCORE)" >&2
    exit 1
fi

# Check if interval is positive
if (( $(echo "$BITSCORE_INTERVAL <= 0" | bc -l) )); then
    echo "Error: bitscore_interval must be positive, got: $BITSCORE_INTERVAL" >&2
    exit 1
fi

# Validate files and directories
check_file_exists "$PYTHON_SCRIPT" "Python script"
check_file_exists "$REFERENCE_FILE" "Reference file"
check_directory "$INPUT_DIR" "Input directory"
check_directory "$OUTPUT_DIR" "Output directory"

# Generate bitscore values
echo "Generating bitscore values..."
BITSCORES=($(generate_bitscores "$MIN_BITSCORE" "$MAX_BITSCORE" "$BITSCORE_INTERVAL"))

if [[ ${#BITSCORES[@]} -eq 0 ]]; then
    echo "Error: No bitscore values generated. Check your range and interval." >&2
    exit 1
fi

# Display configuration
echo "Configuration:"
echo "  Protein index: $PROTEIN_INDEX"
echo "  Database: $DATABASE"
echo "  Reference file: $REFERENCE_FILE"
echo "  Input directory: $INPUT_DIR"
echo "  Output directory: $OUTPUT_DIR"
echo "  Python script: $PYTHON_SCRIPT"
echo "  Bitscore range: $MIN_BITSCORE to $MAX_BITSCORE (interval: $BITSCORE_INTERVAL)"
echo "  Bitscore values: ${BITSCORES[*]}"
echo "  Total jobs: ${#BITSCORES[@]}"
echo "  Parallel mode: $PARALLEL"
if [[ "$PARALLEL" == "true" ]]; then
    echo "  Max parallel jobs: $MAX_JOBS"
fi
echo "  Dry run: $DRY_RUN"
echo

# Confirm before proceeding (unless dry run)
if [[ "$DRY_RUN" == "false" ]]; then
    read -p "Proceed with execution? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Aborted."
        exit 0
    fi
fi

# Execute jobs
echo "Starting EVCouplings analysis..."
JOB_COUNT=0
START_TIME=$(date +%s)

for bitscore in "${BITSCORES[@]}"; do
    ((JOB_COUNT++))
    
    # Build command
    cmd="python $PYTHON_SCRIPT $PROTEIN_INDEX $bitscore $DATABASE $REFERENCE_FILE $INPUT_DIR $OUTPUT_DIR"
    
    if [[ "$VERBOSE" == "true" ]]; then
        cmd="$cmd --verbose"
    fi
    
    echo "[$JOB_COUNT/${#BITSCORES[@]}] Running bitscore: $bitscore"
    
    if [[ "$VERBOSE" == "true" ]] || [[ "$DRY_RUN" == "true" ]]; then
        echo "  Command: $cmd"
    fi
    
    if [[ "$DRY_RUN" == "false" ]]; then
        if [[ "$PARALLEL" == "true" ]]; then
            # Wait if we've reached the maximum number of parallel jobs
            wait_for_jobs "$MAX_JOBS"
            
            # Run in background
            (
                echo "  [$(date '+%Y-%m-%d %H:%M:%S')] Starting bitscore $bitscore..."
                if eval "$cmd"; then
                    echo "  [$(date '+%Y-%m-%d %H:%M:%S')] Completed bitscore $bitscore"
                else
                    echo "  [$(date '+%Y-%m-%d %H:%M:%S')] FAILED bitscore $bitscore" >&2
                fi
            ) &
        else
            # Run sequentially
            echo "  [$(date '+%Y-%m-%d %H:%M:%S')] Starting..."
            if eval "$cmd"; then
                echo "  [$(date '+%Y-%m-%d %H:%M:%S')] Completed"
            else
                echo "  [$(date '+%Y-%m-%d %H:%M:%S')] FAILED" >&2
                echo "Error: Job failed for bitscore $bitscore. Stopping execution." >&2
                exit 1
            fi
        fi
    fi
    
    echo
done

# Wait for all background jobs to complete
if [[ "$PARALLEL" == "true" ]] && [[ "$DRY_RUN" == "false" ]]; then
    echo "Waiting for all parallel jobs to complete..."
    wait
fi

# Summary
END_TIME=$(date +%s)
DURATION=$((END_TIME - START_TIME))

echo "========================================"
if [[ "$DRY_RUN" == "true" ]]; then
    echo "Dry run completed successfully!"
    echo "Total jobs that would be executed: ${#BITSCORES[@]}"
else
    echo "All jobs completed!"
    echo "Total jobs executed: ${#BITSCORES[@]}"
    echo "Total execution time: ${DURATION} seconds"
fi
echo "========================================"
