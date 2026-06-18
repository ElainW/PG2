UNIPROT=$1

env -u SLURM_MEM_PER_NODE -u SLURM_CPU_BIND evcouplings -p $UNIPROT -P $UNIPROT/$UNIPROT config_template_plmc-highbitscores.txt --yolo
env -u SLURM_MEM_PER_NODE -u SLURM_CPU_BIND evcouplings -p $UNIPROT -P $UNIPROT/$UNIPROT config_template_plmc.txt --yolo

for bitscore in $(seq 0.1 0.1 1.0); do
  config_file="${UNIPROT}/${UNIPROT}_b${bitscore}_config.txt"
  sbatch evc.sh "$config_file"
done

echo "All jobs submitted successfully!"