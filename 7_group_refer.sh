#! /bin/bash
# calculate symmetric group reference images to prepare for the relabel step

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
NIFTI=$1
shift
METHOD=$1
shift
VOX_SIZE=$1
shift
GROUP_THRES=$1
shift
LEFT=$1
shift
RIGHT=$1

# NIFTI='/DATA/249/bhe/data_process/f20170503_KM_8/ATPP_cing/NIfTI_20130306';
# WD='/DATA/249/bhe/data_process/f20170503_KM_8/cing_parcellation';
# ROI='cing'
# SUB_LIST='/DATA/249/bhe/data_process/f20170503_KM_8/subject_order.txt'
# MAX_CL_NUM=12
# METHOD='sc'
# VOX_SIZE=0.15
# GROUP_THRES=0.25
# LEFT=1
# RIGHT=1
# COMMAND_MATLAB='matlab'



if [ "${LEFT}" = "1" ] && [ "${RIGHT}" = "0" ]
then
	${COMMAND_MATLAB} -nodisplay -nosplash -r "addpath('${PIPELINE}');addpath('${NIFTI}');group_refer_xmm('${WD}','${ROI}','${SUB_LIST}',${MAX_CL_NUM},'${METHOD}',${VOX_SIZE},${GROUP_THRES},1);exit" &
	wait
elif [ "${LEFT}" = "0" ] && [ "${RIGHT}" = "1" ]
then
	${COMMAND_MATLAB} -nodisplay -nosplash -r "addpath('${PIPELINE}');addpath('${NIFTI}');group_refer_xmm('${WD}','${ROI}','${SUB_LIST}',${MAX_CL_NUM},'${METHOD}',${VOX_SIZE},${GROUP_THRES},0);exit" &
	wait
elif [ "${LEFT}" = "1" ] && [  "${RIGHT}" = "1" ]
then
	${COMMAND_MATLAB} -nodisplay -nosplash -r "addpath('${PIPELINE}');addpath('${NIFTI}');group_refer_xmm('${WD}','${ROI}','${SUB_LIST}',${MAX_CL_NUM},'${METHOD}',${VOX_SIZE},${GROUP_THRES},1);exit" &
	${COMMAND_MATLAB} -nodisplay -nosplash -r "addpath('${PIPELINE}');addpath('${NIFTI}');group_refer_xmm('${WD}','${ROI}','${SUB_LIST}',${MAX_CL_NUM},'${METHOD}',${VOX_SIZE},${GROUP_THRES},0);exit" &
	wait
	${COMMAND_MATLAB} -nodisplay -r "addpath('${PIPELINE}');addpath('${NIFTI}');symmetry_group('${WD}','${ROI}','${SUB_LIST}',${MAX_CL_NUM},${VOX_SIZE},${GROUP_THRES});exit" &
	wait
fi









