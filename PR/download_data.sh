TARGET=/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym2/PR/.cache/ProteinGym
SRC=/n/www/marks.hms.harvard.edu/docroot/proteingym/ProteinGym_v1.3

mkdir -p $TARGET

# DMS benchmark data
unzip $SRC/DMS_ProteinGym_substitutions.zip -d $TARGET
unzip $SRC/DMS_ProteinGym_indels.zip -d $TARGET

# Clinical benchmark data
unzip $SRC/clinical_ProteinGym_substitutions.zip -d $TARGET/clinical_ProteinGym_substitutions
unzip $SRC/clinical_ProteinGym_indels.zip -d $TARGET/clinical_ProteinGym_indels

# AF2 structures (PoET-2 needs these)
unzip $SRC/ProteinGym_AF2_structures.zip -d $TARGET

# required for running the evaluation/performance scripts afterwards
unzip $SRC/zero_shot_substitutions_scores.zip -d $TARGET/zero_shot_substitutions_scores
unzip $SRC/zero_shot_indels_scores.zip -d $TARGET/zero_shot_indels_scores
unzip $SRC/zero_shot_clinical_substitutions_scores.zip -d $TARGET/zero_shot_clinical_substitutions_scores
unzip $SRC/zero_shot_clinical_indels_scores.zip -d $TARGET/zero_shot_clinical_indels_scores