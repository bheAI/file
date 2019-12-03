#! /bin/bash

WD='/DATA/249/bhe/data_process/f20170329_KM_8';
DATA_DIR='/DATA/249/bhe/data_process/f20170329_KM_8/DATA';
WD1='/DATA/249/bhe/data_process/f20170329_KM_8/cing_parcellation/cing_cooni';
WD2='/DATA/249/bhe/data_process/f20170329_KM_8/cing_parcellation/cing_cooni/txt_conni';

for sub in $(cat ${SUB_LIST})
do
WD3=${DATA_DIR}/${sub}/"DTI.bedpostX";
WD4=${WD1}/${sub};
WD5=${WD4}/cing_Sc_cluster_L;
WD6=${WD4}/cing_Sc_cluster_R;
	if [ "${LEFT}" = "1" ]; then
			for i in `cat $WD2/ROI_name_L.txt`;
			do
			mkdir -P $WD4/${sub}"_cing_L_probtrackx_seed"
			WD7=$WD4/${sub}"_cing_L_L_probtrackx_seed"
			job_id=$(${COMMAND_FSLSUB} -l ${WD}/log ${COMMAND_PROBTRACKX} -x $WD5/$i.nii -l --onewaycondition -c ${CUR_THRES} -S ${N_STEPS} --steplength=${LEN_STEP} -P ${N_SAMPLES} --fibthresh=0.01 --distthresh=0.0 --sampvox=0.0 --forcedir --opd -s $WD3/merged -m $WD3/nodif_brain_mask --dir=$WD7/$i --targetmasks=${WD1}/${sub}/targetmask_L.txt ${DIS_COR} --os2t &)
			WD8=$WD4/${sub}"_cing_L_R_probtrackx_seed"
			job_id=$(${COMMAND_FSLSUB} -l ${WD}/log ${COMMAND_PROBTRACKX} -x $WD5/$i.nii -l --onewaycondition -c ${CUR_THRES} -S ${N_STEPS} --steplength=${LEN_STEP} -P ${N_SAMPLES} --fibthresh=0.01 --distthresh=0.0 --sampvox=0.0 --forcedir --opd -s $WD3/merged -m $WD3/nodif_brain_mask --dir=$WD8/$i --targetmasks=${WD1}/${sub}/targetmask_R.txt ${DIS_COR} --os2t &)
			echo "${sub}_L_seed probtrackx is running...! job_ID is ${job_id}"
			mute=$(${COMMAND_FSLSUB} -j ${job_id} -N running... -l ${WD}/log touch ${WD}/probtrackx_jobdone/${sub}_L.jobdone)
			done				
	fi
	if [ "${RIGHT}" = "1" ]; then	
			for j in `cat $WD2/ROI_name_R.txt`;
			do
			mkdir -P $WD4/${sub}"_cing_R_probtrackx_seed"
			WD9=$WD4/${sub}"_cing_R_L_probtrackx_seed"
			job_id=$(${COMMAND_FSLSUB} -l ${WD}/log ${COMMAND_PROBTRACKX} -x $WD5/$j.nii -l --onewaycondition -c ${CUR_THRES} -S ${N_STEPS} --steplength=${LEN_STEP} -P ${N_SAMPLES} --fibthresh=0.01 --distthresh=0.0 --sampvox=0.0 --forcedir --opd -s $WD3/merged -m $WD3/nodif_brain_mask --dir=$WD7/$j --targetmasks=${WD1}/${sub}/targetmask_L.txt ${DIS_COR} --os2t &)
			WD10=$WD4/${sub}"_cing_R_R_probtrackx_seed"
			job_id=$(${COMMAND_FSLSUB} -l ${WD}/log ${COMMAND_PROBTRACKX} -x $WD5/$j.nii -l --onewaycondition -c ${CUR_THRES} -S ${N_STEPS} --steplength=${LEN_STEP} -P ${N_SAMPLES} --fibthresh=0.01 --distthresh=0.0 --sampvox=0.0 --forcedir --opd -s $WD3/merged -m $WD3/nodif_brain_mask --dir=$WD10/$j --targetmasks=${WD1}/${sub}/targetmask_R.txt ${DIS_COR} --os2t &)
			echo "${sub}_R_seed probtrackx is running...! job_ID is ${job_id}"
			mute=$(${COMMAND_FSLSUB} -j ${job_id} -N running... -l ${WD}/log touch ${WD}/probtrackx_jobdone/${sub}_R.jobdone)
			done		
	
	fi	
done


