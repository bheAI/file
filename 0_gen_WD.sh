#! /bin/bash
# generate working directory for MonkeyCBP
#
# Directory structure:
#	  Working_dir
#     |-- sub1
#     |   |-- T1_sub1.nii
#     |   `-- b0_sub1.nii
#     |-- ...
#     |-- subN
#     |   |-- T1_subN.nii
#     |   `-- b0_subN.nii
#     |-- ROI
#     |   |-- ROI_L.nii
#     |   `-- ROI_R.nii
#     `-- log 
#
# !! Please modify the following codes to organzie these files according to the above structure

WD=$1
shift
DATA_DIR=$1
shift
ROI=$1
shift
SUB_LIST=$1
shift
ROI_DIR=$1

# generate ROI directory
# mkdir -p ${WD}/Warp
mkdir -p ${WD}/log



# copy ROIs from ROI_DIR to ROI directory in working directory
# cp -vrt ${WD}/ROI ${ROI_DIR}/${ROI}_L.nii ${ROI_DIR}/${ROI}_R.nii

# copy T1 and b0 files from DATA_DIR for each subject
for sub in `cat ${SUB_LIST}`
do
    echo $sub
	# mkdir -p ${WD}/${sub}
	# mv ${WD}/${sub}/b0.nii.gz ${WD}/${sub}/b0_"${sub}".nii.gz
	# cp -vrt ${WD}/${sub} ${DATA_DIR}/${sub}/b0_"${sub}".nii.gz ${DATA_DIR}/${sub}/template_fix_origin_001.nii
	# cp -vrt ${WD}/${sub} ${DATA_DIR}/${sub}/T1_brain.nii.gz ${DATA_DIR}/${sub}/DTI/nodif_brain.nii.gz
	# gunzip ${WD}/${sub}/nodif_brain.nii.gz
	# gunzip ${WD}/${sub}/T1_brain.nii.gz
	# mv -v ${WD}/${sub}/T1_brain.nii ${WD}/${sub}/T1_${sub}.nii	
	# mv -v ${WD}/${sub}/nodif_brain.nii ${WD}/${sub}/b0_${sub}.nii	
	# fslmaths ${DATA_DIR}/${sub}/DTI/b0.nii.gz -mul ${DATA_DIR}/${sub}/DTI/nodif_brain_mask.nii ${DATA_DIR}/${sub}/b0.nii.gz
done
