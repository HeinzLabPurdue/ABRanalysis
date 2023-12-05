function abr_setup_no_format
%This will be the only setup folder...no worrying about format. Should only
%need your ABR data directory

global abr_root_dir abr_data_dir abr_out_dir 

%addpath(genpath(pwd)) 
%rmpath(genpath('Trash'));

% Directory containing your data folder
uiwait(warndlg('Please, select folder containing data to analyze','Select Data Folder'));
abr_data_dir = uigetdir;
addpath(genpath(abr_data_dir)) % directory containing your project folder
uiwait(warndlg('Please, select folder to save files','Select Saving Folder'));
abr_out_dir = uigetdir;% directory containing ABR Analysis folder
abr_out_dir = [abr_out_dir '/Analysis'];
uiwait(warndlg('Please, select folder containing ABR analysis scripts','Select ABR Analysis Folder'));
abr_root_dir = uigetdir;
abr_root_dir = [abr_root_dir,'/']; %ENTER the path of your 'ABRAnalysis' folder

addpath([abr_root_dir])

if ~exist(abr_out_dir,'dir')
    mkdir(abr_out_dir);
end

% cd([abr_root_dir 'ABR_analysis/'])

abr_analysis_HL

