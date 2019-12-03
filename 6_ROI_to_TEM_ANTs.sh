#! /bin/bash
# transform parcellated ROI from DTI space to MNI space

PIPELINE=$1
shift
WD=$1
shift
ROI=$1
shift
SUB_LIST=$1
shift
MAX_CL_NUM=$1
shift
WTFD=$1
shift
TEMPLATE=$1
shift
VOX_SIZE=$1
shift
METHOD=$1
shift
LEFT=$1
shift
RIGHT=$1
SUBJECT_NUM=`cat ${SUB_LIST} |wc -l`
# echo $SUBJECT_NUM
# NUM=2
# ref_list='/DATA/249/bhe/data_process/f20170309_KM_8/cing_parcellation/warp'
# for sub in `cat ${SUB_LIST}`
# WD1=/DATA/249/bhe/data_process/f20170309_KM_8/KM_8_atlas
#*****************************************************************************************************************************
# VOX_SIZE=0.3


for i in $(seq 1 ${SUBJECT_NUM})
# for i in {1..1}
do
	# AFFINETXT=`awk NR==${i}{print} ${WTFD}/affine.txt`	
	# INVERSEWARP=`awk NR==${i}{print} ${WTFD}/inversewarp.txt`
	
	sub=`awk NR==${i}{print} ${SUB_LIST}`
	AFFINETXT=${WTFD}/${sub}/AtlasToTargetAffine.txt
	INVERSEWARP=${WTFD}/${sub}/AtlasToTargetInverseWarp.nii.gz
	VERSEWARP=${WTFD}/${sub}/AtlasToTargetWarp.nii.gz
	
	# ref=`awk NR==${i}{print} ${ref_list}`
	for num in $(seq 2 ${MAX_CL_NUM})
	# for num in $(seq 2 ${NUM})
	do
		if [ "${LEFT}" = "1" ]; then
		# echo ${WD}/${sub}/${sub}_${ROI}_L_${METHOD}/${VOX_SIZE}mm
			mkdir -p ${WD}/${sub}/${sub}_${ROI}_L_${METHOD}/${VOX_SIZE}mm
			# WarpImageMultiTransform 3 ${WD}/${sub}/${sub}_${ROI}_L_${METHOD}/${ROI}_L_${num}.nii ${WD}/${sub}/${sub}_${ROI}_L_${METHOD}/${VOX_SIZE}mm/${VOX_SIZE}mm_${ROI}_L_${num}_MNI.nii.gz -R ${TEMPLATE} -i ${AFFINETXT} ${INVERSEWARP} --use-NN
			
			WarpImageMultiTransform 3 ${WD}/${sub}/${sub}_${ROI}_L_${METHOD}/${ROI}_L_${num}.nii.gz ${WD}/${sub}/${sub}_${ROI}_L_${METHOD}/${VOX_SIZE}mm/${VOX_SIZE}mm_${ROI}_L_${num}_MNI.nii.gz -R ${TEMPLATE} ${VERSEWARP} ${AFFINETXT} --use-NN

			
			# gzip ${WD}/${sub}/${sub}_${ROI}_L_${METHOD}/${VOX_SIZE}mm/${VOX_SIZE}mm_${ROI}_L_${num}_MNI.nii
			# fslmaths $WD1/${sub}"_atlas108_mask.nii.gz" -mul ${WD}/${sub}/${sub}_${ROI}_L_${METHOD}/${VOX_SIZE}mm/${VOX_SIZE}mm_${ROI}_L_${num}_MNI.nii.gz ${WD}/${sub}/${sub}_${ROI}_L_${METHOD}/${VOX_SIZE}mm/${VOX_SIZE}mm_${ROI}_L_${num}_MNI.nii.gz
		fi
		if [ "${RIGHT}" = "1" ]; then
	        mkdir -p ${WD}/${sub}/${sub}_${ROI}_R_${METHOD}/${VOX_SIZE}mm
			# WarpImageMultiTransform 3 ${WD}/${sub}/${sub}_${ROI}_R_${METHOD}/${ROI}_R_${num}.nii ${WD}/${sub}/${sub}_${ROI}_R_${METHOD}/${VOX_SIZE}mm/${VOX_SIZE}mm_${ROI}_R_${num}_MNI.nii.gz -R ${TEMPLATE} -i ${AFFINETXT} ${INVERSEWARP} --use-NN	 
			
			WarpImageMultiTransform 3 ${WD}/${sub}/${sub}_${ROI}_R_${METHOD}/${ROI}_R_${num}.nii.gz ${WD}/${sub}/${sub}_${ROI}_R_${METHOD}/${VOX_SIZE}mm/${VOX_SIZE}mm_${ROI}_R_${num}_MNI.nii.gz -R ${TEMPLATE} ${VERSEWARP} ${AFFINETXT} --use-NN
			
			
			# gzip ${WD}/${sub}/${sub}_${ROI}_R_${METHOD}/${VOX_SIZE}mm/${VOX_SIZE}mm_${ROI}_R_${num}_MNI.nii
			# fslmaths $WD1/${sub}"_atlas108_mask.nii.gz" -mul ${WD}/${sub}/${sub}_${ROI}_R_${METHOD}/${VOX_SIZE}mm/${VOX_SIZE}mm_${ROI}_R_${num}_MNI.nii.gz ${WD}/${sub}/${sub}_${ROI}_R_${METHOD}/${VOX_SIZE}mm/${VOX_SIZE}mm_${ROI}_R_${num}_MNI.nii.gz
		fi
	done
done
