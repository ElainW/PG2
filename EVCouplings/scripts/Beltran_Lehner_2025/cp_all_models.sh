SRC=/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym2/EVCouplings/output/Beltran_Lehner_2025/uniref100
DST=/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym2/EVCouplings/output/Beltran_Lehner_2025/all_models

find "$SRC" -type f -path "*/couplings/*.model" -print0 \
  | xargs -0 -I{} cp -n {} "$DST"/

echo "Copied: $(ls "$DST" | wc -l) files"