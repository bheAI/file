function group_refer_xmm(PWD,ROI,SUB_LIST,MAX_CL_NUM,METHOD,VOX_SIZE,GROUP_THRES,LorR)
% group REFER


% NIFTI='/DATA/249/bhe/data_process/f20170503_KM_8/ATPP_cing';
% addpath('/DATA/249/bhe/data_process/f20170503_KM_8/ATPP_cing/NIfTI_20130306')
% PWD='/DATA/249/bhe/data_process/f20170503_KM_8/cing_parcellation';
% ROI='cing'
% SUB_LIST='/DATA/249/bhe/data_process/f20170503_KM_8/subject_order.txt'
% MAX_CL_NUM=12
% METHOD='sc'
% VOX_SIZE=0.5
% GROUP_THRES=0.25
% LEFT=1
% RIGHT=0
% LorR=1
% COMMAND_MATLAB='matlab'




% NIFTI='/DATA/249/bhe/data_process/f20170413_KM_8/ATPP_cing/NIfTI_20130306';
% VOX_SIZE=0.3
% GROUP_THRES=0.25
% LEFT=1
% RIGHT=1
% COMMAND_MATLAB='matlab'

% addpath('/DATA/249/bhe/data_process/f20170413_KM_8/ATPP_cing/NIfTI_20130306')
% PWD='/DATA/249/bhe/data_process/f20170413_KM_8/cing_parcellation';
% ROI='cing'
% SUB_LIST='/DATA/249/bhe/data_process/f20170413_KM_8/subject_order.txt'
% MAX_CL_NUM=12
% METHOD='sc'

% VOX=0.3

% THRES=0.25


SUB = textread(SUB_LIST,'%s');
subnum = length(SUB);

if LorR == 1
	LR='L';
elseif LorR == 0
	LR='R';
end 
if GROUP_THRES == 0
	GROUP_THRES_REAL=eps;
else
	GROUP_THRES_REAL=GROUP_THRES;
end

defnii = load_untouch_nii(strcat(PWD,'/',SUB{1},'/',SUB{1},'_',ROI,'_',LR,'_',METHOD,'/',num2str(VOX_SIZE),'mm/',num2str(VOX_SIZE),'mm_',ROI,'_',LR,'_',num2str(2),'_MNI.nii.gz'));
sumimg = zeros(size(defnii.img));
for j = 1:subnum 
	  disp(strcat(SUB{j},'_',LR));
	  datanii = load_untouch_nii(strcat(PWD,'/',SUB{j},'/',SUB{j},'_',ROI,'_',LR,'_',METHOD,'/',num2str(VOX_SIZE),'mm/',num2str(VOX_SIZE),'mm_',ROI,'_',LR,'_',num2str(2),'_MNI.nii.gz'));
	  datanii.img(datanii.img>0) = 1;
	  datanii.img=datanii.img;
	  sumimg = sumimg + datanii.img;
end

defimg = sumimg;
defimg(defimg<GROUP_THRES_REAL*subnum)=0;
defimg(defimg>0)=1;
defnii.img = defimg;
grouproipath = strcat(PWD,'/','group_',num2str(length(SUB)),'_',num2str(VOX_SIZE),'mm/');
if ~exist(grouproipath,'dir')
	mkdir(grouproipath);
end
save_untouch_nii(defnii,strcat(grouproipath,ROI,'_',LR,'_roimask_thr',num2str(GROUP_THRES_REAL*100),'.nii.gz'));

roiindex = find(sumimg >= GROUP_THRES_REAL*subnum);
ROISIZE = length(roiindex);


for CL_NUM=2:MAX_CL_NUM
	%if ~exist(strcat(grouproipath,num2str(VOX_SIZE),'mm_',ROI,'_',LR,'_',num2str(CL_NUM),'_',num2str(GROUP_THRES_REAL*100),'_group.nii'),'file')
    	disp(strcat(ROI,'_',LR,' cluster number_',num2str(CL_NUM),' is running...'));
	    groupmatrix = zeros(ROISIZE,ROISIZE);
	    for j = 1:length(SUB)
			datanii = load_untouch_nii(strcat(PWD,'/',SUB{j},'/',SUB{j},'_',ROI,'_',LR,'_',METHOD,'/',num2str(VOX_SIZE),'mm/',num2str(VOX_SIZE),'mm_',ROI,'_',LR,'_',num2str(CL_NUM),'_MNI.nii.gz'));
			dataimg = datanii.img;
			kimatrix=zeros(ROISIZE,ROISIZE);
			for ki=1:CL_NUM
				kimatrix(:)=0;
				kind = find(dataimg==ki);
			  	[tf,vind] = ismember(kind,roiindex);
				kimatrix(vind(vind>0),vind(vind>0)) = 1;
				groupmatrix = groupmatrix + kimatrix;
			end	
	    end
	    groupmatrix=groupmatrix-diag(diag(groupmatrix));
	    index=sc3(CL_NUM,groupmatrix);
	    img_f = zeros(size(defnii.img));
	    a=1:1:length(index);
	    img_f(roiindex(a)) = index(a);
	    defnii.img = img_f;
	    save_untouch_nii(defnii,strcat(grouproipath,num2str(VOX_SIZE),'mm_',ROI,'_',LR,'_',num2str(CL_NUM),'_',num2str(GROUP_THRES_REAL*100),'_group.nii.gz'));

		disp(strcat(ROI,'_',LR,' cluster number_',num2str(CL_NUM),' Done !!'));
	%end
end
