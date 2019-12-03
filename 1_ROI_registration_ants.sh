#! /bin/bash
#Two steps

YoN=$1
shift
PIPELINE=$1
shift
WD=$1
shift
DATA_DIR=$1
shift
TemD=$1
shift
ROI=$1
shift
SUB_LIST=$1
shift
N_rf=$1
shift
M_ants=$1
shift
R_ants=$1
shift
syn_ants=$1
shift
i_ants=$1
shift
TEMPLATE=$1
shift
LEFT=$1
shift
RIGHT=$1

#Please decide whether to edit the step one as needed for the document layout
#step one: generate working directory for MonkeyCBP
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

# generate directory
mkdir -p ${WD}/log

############################Edit parts############################
if [ "${YoN}" = "1" ]; then
	for sub in `cat ${SUB_LIST}`
	do 	
		mkdir -p ${WD}/${sub}
		# cp -vrt ${WD}/${sub} ${DATA_DIR}/${sub}/b0.nii.gz ${DATA_DIR}/${sub}/DTI/nodif_brain.nii.gz
		cp -vrt ${WD}/${sub} ${DATA_DIR}/${sub}/b0.nii.gz
		mv -v ${WD}/${sub}/b0.nii.gz ${WD}/${sub}/b0_${sub}.nii.gz
		# gunzip
		# gzip
	done
fi
###################################################################


###################################################################
#Do not modify the code unless you know what you're going to do
#step two: ROI registration, from DTI space to template space, using ANTs
for sub in `cat ${SUB_LIST}`
do	
	sub_rf=${WD}/${sub}/${N_rf}_"${sub}".nii.gz	
    # registration directory
	mkdir -p ${WD}/"ants_""${R_ants}""_0""$(echo "${syn_ants} 10" |awk '{printf("%0.0f\n",$1*$2)}')""_""${i_ants}"/${sub}
	RegD=${WD}/"ants_""${R_ants}""_0""$(echo "${syn_ants} 10" |awk '{printf("%0.0f\n",$1*$2)}')""_""${i_ants}"/${sub}
	cd ${RegD}
	# ANTS 3 -m ${M_ants}[${TEMPLATE},${sub_rf},1,${R_ants}] -o AtlasToTarget -t SyN[${syn_ants}] -r Gauss[3,0] -i ${i_ants}x${i_ants}x${i_ants} 
	
	if [ "${LEFT}" = "1" ]; then	
	ROI_L=${TemD}/${ROI}_L.nii.gz		
	# WarpImageMultiTransform 3 ${ROI_L} "${sub}"_"${ROI}"_L_DTI.nii.gz -R ${sub_rf} -i AtlasToTargetAffine.txt AtlasToTargetInverseWarp.nii.gz --use-NN
	# cp -a "${sub}"_"${ROI}"_L_DTI.nii.gz ${WD}/${sub}
	cp -a ${TEMPLATE} $WD/${sub}
	WarpImageMultiTransform 3 $WD/${sub}/"${sub}"_"${ROI}"_L_DTI.nii.gz $WD/${sub}/CIVM_"${ROI}"_L_DTI.nii.gz -R ${TEMPLATE} AtlasToTargetWarp.nii.gz AtlasToTargetAffine.txt --use-NN
	
	fi
		
	if [ "${RIGHT}" = "1" ]; then		
	ROI_R=${TemD}/${ROI}_R.nii.gz		
	# WarpImageMultiTransform 3 ${ROI_R} "${sub}"_"${ROI}"_R_DTI.nii.gz -R ${sub_rf} -i AtlasToTargetAffine.txt AtlasToTargetInverseWarp.nii.gz --use-NN
	# cp -a "${sub}"_"${ROI}"_R_DTI.nii.gz ${WD}/${sub}	
	WarpImageMultiTransform 3 $WD/${sub}/"${sub}"_"${ROI}"_R_DTI.nii.gz $WD/${sub}/CIVM_"${ROI}"_R_DTI.nii.gz -R ${TEMPLATE} AtlasToTargetWarp.nii.gz AtlasToTargetAffine.txt --use-NN
	fi	
done
###################################################################

