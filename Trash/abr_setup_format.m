function abr_setup_format
% Follow instructions in Readme.txt if having trouble setting up
% Only use this setup script if you have a correctly formatted project folder

% It's HIGHLY recommended to download your data from synology before running,
% as the code will otherwise run very slowly 

global abr_root_dir abr_data_dir abr_out_dir
if (ismac == 1) %Use if using a MAC
    addpath(genpath('/Volumes/Elements/HeinzLab Code/')) %ENTER the path of the directory containing your 'ABRAnalysis' folder
    addpath(genpath('/Volumes/Elements/HeinzLab Code/')) %ENTER the path of the directory containing your project folder
    code_DIR='/Volumes/Elements/HeinzLab Code/ABRanalysis/'; %ENTER the path of your 'ABRAnalysis' folder
    project_DIR='/Volumes/Elements/HeinzLab Code/Ivy_Andrew_CARBOvTTS/'; %ENTER the path of your project folder

    abr_root_dir = [code_DIR 'ABR-master/Matlab_ABR/'];
    abr_data_dir = [project_DIR 'Data/'];
    abr_out_dir = [project_DIR 'Analysis/ABR/'];

    addpath([abr_root_dir 'ABR_analysis/'])
    cd([abr_root_dir 'ABR_analysis/'])
    
    
else %Use if using Windows/Linux
    addpath(genpath('C:\Users\bundyj\Downloads\')) %ENTER the path of the directory containing your 'ABRAnalysis' folder
    addpath(genpath('C:\Users\bundyj\Downloads\')) %ENTER the path of the directory containing your project folder
    code_DIR='C:\Users\bundyj\Downloads\ABRAnalysis\'; %ENTER the path of your 'ABRAnalysis' folder
    project_DIR='C:\Users\bundyj\Downloads\Ivy_Andrew_CARBOvTTS_2\'; %ENTER the path of your project folder

    abr_root_dir = [code_DIR 'ABR-master\Matlab_ABR\'];
    
    abr_data_dir = [project_DIR 'Data\'];
    abr_out_dir = [project_DIR 'Analysis\ABR\'];
    
    addpath([abr_root_dir 'ABR_analysis\'])
    cd([abr_root_dir 'ABR_analysis\'])
end

abr_analysis_HL

