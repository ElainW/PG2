SRC=/n/groups/marks/projects/viral_families/notebooks/navami/followupNeffAnalysis/PG_analysis/evh/output/uniref100/
DST=/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym2/EVCouplings/output/PG1/models

mkdir -p $DST

find "$SRC" -type f -path "*/couplings/*.model" -print0 \
  | while IFS= read -r -d '' f; do
      ln -sf "$f" "$DST/$(basename "$f")"
    done

echo "Linked: $(ls "$DST" | wc -l) files"