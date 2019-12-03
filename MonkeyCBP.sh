#! /bin/bash

# Automatic connectivity-based parcellation of monkey brain (MonkeyCBP)
#
# ---- Multi-ROI oriented brain parcellation
# ---- Automatic parallel computing
# ---- Modular and flexible structure
# ---- Simple and easy-to-use settings
#
# Usage: bash MonkeyCBP.sh batch_list.txt
# Bin He (bin.he@nlpr.ia.ac.cn)
# MonkeyCBP V1.0


# Copyright (C) 2018  Bin He
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.


#==============================================================================
# Prerequisites:
# 1) Tools: FSL (with FDT toolbox), SGE and MATLAB (with SPM8)
# 2) Data files:
#    > T1 image for each subject
#    > b0 image for each subject
#    > images preprocessed by FSL(BedpostX) for each subject
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
#==============================================================================

# usage function
show_usage() {
    cat << EOF
Automatic connectivity-based parcellation of monkey brain (MonkeyCBP)
    
    Usage: bash MonkeyCBP.sh batch_list.txt

Please refer the instructions in MonkeyCBP.sh for detailed info
EOF
    exit 1
}

#==============================================================================
# batch processing parameter list
# DO NOT FORGET TO EDIT batch_list.txt to include the appropriate parameters
#==============================================================================
# batch_list.txt contains the following 7 parameters in order in each line:
# - data directory, e.g. /DATA/249/bhe/data_process/DataKMC
# - list of subjects, e.g. /DATA/249/bhe/data_process/DataKMC/subject_order.txt
# - working directory, e.g. /DATA/249/bhe/data_process/DataKMC/PMC_parcellation
# - brain region name, e.g. PMC
# - maximum cluster number , e.g. 6
#==============================================================================

if [ $# -ne 1 ]; then
    show_usage
elif [ -f $1 ]; then 
    BATCH_LIST=$1
else
    echo "ERROR: $1 not found!"
    show_usage
    exit 1
fi


#==============================================================================
# Global configuration file
# Before running the pipeline, you NEED to modify parameters in the file.
#==============================================================================
set -o allexport
if [ -f "./config.sh" ]; then
	source ./config.sh
else
	echo "ERROR: Cannot find the configuration file!"
	exit 1
fi

#==============================================================================
#----------------------------START OF SCRIPT-----------------------------------
#------------NO EDITING BELOW UNLESS YOU KNOW WHAT YOU ARE DOING---------------
#==============================================================================

# show header info 
HEADER=${PIPELINE}/header.txt

if [ -f ${HEADER} ]; then
	cat ${HEADER}
fi

while read line
do

# 1. cut specific parameters from batch_list
DATA_DIR=$( echo $line | cut -d ' ' -f1 )
SUB_LIST=$( echo $line | cut -d ' ' -f2 )
WD=$( echo $line | cut -d ' ' -f3 )
ROI=$( echo $line | cut -d ' ' -f4 )
MAX_CL_NUM=$( echo $line | cut -d ' ' -f5 )

# 2. make a proper bash script 
mkdir -p ${WD}/log
LOG_DIR=${WD}/log
LOG=${LOG_DIR}/MonkeyCBP_log_$(date +%m-%d_%H-%M-%S).txt
CONFIG=${PIPELINE}/config.sh

echo "\
#!/bin/bash
#$ -V
#$ -cwd
#$ -N MonkeyCBP_${ROI}
#$ -o ${LOG_DIR}
#$ -e ${LOG_DIR}

bash ${PIPELINE}/pipeline.sh ${PIPELINE} ${CONFIG} ${HEADER} ${WD} ${DATA_DIR} ${SUB_LIST} ${ROI} ${MAX_CL_NUM} >${LOG} 2>&1"\
>${LOG_DIR}/MonkeyCBP_${ROI}_qsub.sh

# 3. submit the task
echo "$(printf " %.0s" {1..28})MonkeyCBP is running for ${ROI}"
${COMMAND_QSUB} ${WD}/log/MonkeyCBP_${ROI}_qsub.sh

echo "log: ${LOG_DIR}/MonkeyCBP_log_$(date +%m-%d_%H-%M-%S).txt" 
echo "$(printf "━ %.0s" {1..49})"

# waiting for a proper host
sleep 3s 

done < ${BATCH_LIST} 
echo "▂▂▂▂▂▂▂▂▂▂▂▂ Please type 'qstat' to show the status of job(s) ▂▂▂▂▂▂▂▂▂▂▂▂"


#================================ END =======================================
