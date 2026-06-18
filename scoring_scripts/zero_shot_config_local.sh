# This file has all general filepaths and directories used in the scoring pipeline. The individual scripts may have 
# additional parameters specific to each method 

# DMS zero-shot parameters

# Folders containing the csvs with the variants for each DMS assay
export DMS_data_folder_subs=/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/DMS_assays/DMS_ProteinGym_substitutions_PG2 #/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/DMS_assays/DMS_ProteinGym_substitutions
export DMS_data_folder_indels=/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/DMS_assays/DMS_ProteinGym_indels

# Folders containing multiple sequence alignments and MSA weights for all DMS assays
export DMS_MSA_data_folder=/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/MSA_files/PG_repo/DMS_MSA_PG2 #/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/MSA_files/PG_repo/DMS_msa_files
export DMS_MSA_weights_folder=/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/MSA_weights/PG_repo/DMS_msa_weights_PG2

#_MSAT_PR#/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/MSA_files/PG_repo/DMS_msa_weights

# Reference files for substitution and indel assays
export DMS_reference_file_path_subs=/home/pan223/open_source/ProteinGym/reference_files/DMS_substitutions_2.0.csv #/home/pan223/open_source/ProteinGym/reference_files/DMS_substitutions.csv
export DMS_reference_file_path_indels=/home/pan223/open_source/ProteinGym/reference_files/DMS_indels.csv

# Folders where fitness predictions for baseline models are saved 
export DMS_output_score_folder_subs=/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/model_scores/zero_shot_substitutions #PR_review #/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/archive/PN_tests #"folder for DMS substitution scores"
#export DMS_output_score_folder_subs=/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/model_scores #/merged_scores/zero_shot_substitutions
export DMS_output_score_folder_indels=/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/model_scores/zero_shot_indels

# Folder containing EVE models for each DMS assay
export DMS_EVE_model_folder="folder for DMS assay specific EVE models"

# Folders containing merged score files for each DMS assay
export DMS_merged_score_folder_subs=/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/model_scores/merged_scores/zero_shot_substitutions/20241108_Tranception_rerun #20241015_PoET #PR_review/20241001 #zero_shot_substitutions/20240923
export DMS_merged_score_folder_indels=/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/model_scores/merged_scores/zero_shot_indels/20241015_PoET

# Folders containing predicted structures for the DMSs 
export DMS_structure_folder=/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/structure_files/DMS_subs_PG2 #/n/groups/marks/projects/marks_lab_and_oatml/ProteinGym/structure_files/DMS_subs


# Clinical parameters 

# Folder containing variant csvs 
export clinical_data_folder_subs="folder containing clinical substitution csvs"
export clinical_data_folder_indels="folder containing clinical indel csvs"

# Folders containing multiple sequence alignments and MSA weights for all clinical datasets
export clinical_MSA_data_folder_subs="folder containing clinical MSA files for substitutions"
export clinical_MSA_data_folder_indels="folder containing clinical MSA files for indels"

# Folder containing MSA weights for all clinical datasets
export clinical_MSA_weights_folder_subs="folder containing clinical MSA weights for substitutions"
export clinical_MSA_weights_folder_indels="folder containing clinical MSA weights for indels"

# reference files for substitution and indel clinical variants 
export clinical_reference_file_path_subs=../../reference_files/clinical_substitutions.csv
export clinical_reference_file_path_indels=../../reference_files/clinical_indels.csv

# Folder where clinical benchmark fitness predictions for baseline models are saved
export clinical_output_score_folder_subs="folder for clinical substitution scores"
export clinical_output_score_folder_indels="folder for clinical indel scores"

# Folder containing EVE models for each clinical variant
export clinical_EVE_model_folder="folder for clinical EVE models"

# Folder containing merged score files for each clinical variant
export clinical_merged_score_folder_subs="folder for merged scores for clinical substitutions"
export clinical_merged_score_folder_indels="folder for merged score for clinical indels"
