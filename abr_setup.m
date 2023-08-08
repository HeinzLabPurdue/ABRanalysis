function abr_setup

global abr_root_dir abr_data_dir abr_out_dir 

addpath(genpath(pwd)) %ENTER the path of the directory containing your 'ABRAnalysis' folder
rmpath(genpath('Trash'));

%linux
addpath(genpath('/media/asivapr/AndrewNVME/Pitch_Study/Pitch_Diagnostics_SH_AS/ABR/Chin/')) %ENTER the path of the directory containing your project folder
project_DIR='/media/asivapr/AndrewNVME/Pitch_Study/Pitch_Diagnostics_SH_AS/ABR/Chin/Baseline/'; %ENTER the path of your project folder

% %windows
% addpath(genpath('A:/Pitch_Study/Pitch_Diagnostics_SH_AS/ABR/Chin/')) %ENTER the path of the directory containing your project folder
% project_DIR='A:/Pitch_Study/Pitch_Diagnostics_SH_AS/ABR/Chin/Baseline/'; %ENTER the path of your project folder

% code_DIR=[pwd,'/']; %ENTER the path of your 'ABRAnalysis' folder
code_DIR = pwd;
abr_root_dir = [code_DIR];
abr_data_dir = [project_DIR];
abr_out_dir = [project_DIR 'Analysis'];

addpath([abr_root_dir])

if ~exist(abr_out_dir,'dir')
    mkdir(abr_out_dir);
end

% cd([abr_root_dir 'ABR_analysis/'])

abr_analysis_HL

