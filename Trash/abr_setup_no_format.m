function abr_setup_no_format
%This will be the only setup folder...no worrying about format. Should only
%need your ABR data directory

global abr_root_dir abr_data_dir abr_out_dir 

addpath(genpath(pwd)) %ENTER the path of the directory containing your 'ABRAnalysis' folder
rmpath(genpath('Trash'));

addpath(genpath('/media/sivaprakasaman/AndrewNVME/Pitch_Study/Pitch_Diagnostics_SH_AS/ABR/Chin/')) %ENTER the path of the directory containing your project folder
project_DIR='/media/sivaprakasaman/AndrewNVME/Pitch_Study/Pitch_Diagnostics_SH_AS/ABR/Chin/Baseline/'; %ENTER the path of your project folder

code_DIR=[pwd,'/']; %ENTER the path of your 'ABRAnalysis' folder

abr_root_dir = [code_DIR];
abr_data_dir = [project_DIR];
abr_out_dir = [project_DIR 'Analysis'];

addpath([abr_root_dir])

if ~exist(abr_out_dir,'dir')
    mkdir(abr_out_dir);
end

% cd([abr_root_dir 'ABR_analysis/'])

abr_analysis_HL

