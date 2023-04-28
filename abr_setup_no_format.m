function abr_setup_no_format
% Follow instructions in Readme.txt if having trouble setting up
% Use this setup if you do not have a correctly formatted project folder

global abr_root_dir abr_data_dir abr_out_dir
if (ismac == 1) %Use if using a MAC
    addpath(genpath('/Volumes/Elements/HeinzLab Code/')) %ENTER the path of the directory containing your 'ABRAnalysis' folder
    addpath(genpath('/Volumes/Elements/HeinzLab Code/Project/Data/')) %ENTER the path of the data directory
    addpath(genpath('/Volumes/Elements/HeinzLab Code/Project/Analysis/ABR/')) %ENTER the path of the output directory
    code_DIR='/Volumes/Elements/HeinzLab Code/ABRanalysis/'; %ENTER the path of your 'ABRAnalysis' folder

    abr_root_dir = [code_DIR 'ABR-master/Matlab_ABR/'];
    abr_data_dir = '/Volumes/Elements/HeinzLab Code/Project/Data/'; %ENTER the path containing your Data folders 
    abr_out_dir = '/Volumes/Elements/HeinzLab Code/Project/Analysis/ABR/'; %ENTER the path of your output directory

    addpath([abr_root_dir 'ABR_analysis/'])
    cd([abr_root_dir 'ABR_analysis/'])
    
    
else %Use if using Windows/Linux
    addpath(genpath('/mnt/ECF4E22CF4E1F92A/Research/Code/ABRanalysis/')) %ENTER the path of the directory containing your 'ABRAnalysis' folder
    addpath(genpath('/media/asivapr/AndrewNVME/Pitch_Study/F30_Full_Data/ABR/HeinzLab/')) %ENTER the path of the directory containing your project folder
    code_DIR='/mnt/ECF4E22CF4E1F92A/Research/Code/ABRanalysis/'; %ENTER the path of your 'ABRAnalysis' folder
    project_DIR='/media/asivapr/AndrewNVME/Pitch_Study/F30_Full_Data/ABR/HeinzLab/Baseline/'; %ENTER the path of your project folder

    abr_root_dir = [code_DIR 'ABR-master/Matlab_ABR/'];
    
    abr_data_dir = [project_DIR ''];
    abr_out_dir = [project_DIR 'Analysis/ABR/'];
    
    addpath([abr_root_dir 'ABR_analysis/'])
    cd([abr_root_dir 'ABR_analysis/'])
end

abr_analysis_HL

