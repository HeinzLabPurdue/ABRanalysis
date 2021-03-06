function abr_setup
% Follow instructions in Readme.txt if having trouble setting up

global abr_root_dir abr_data_dir abr_out_dir
if (ismac == 1) %Use if using a MAC
    addpath(genpath('/Users/jimmys_macbook/Desktop/stuff/files/ABR Test/')) %ENTER the path of the directory containing your 'ABRAnalysis' folder
    addpath(genpath('/Volumes/Heinz-Lab/Users/Jim/')) %ENTER the path of the directory containing your project folder
    code_DIR='/Users/jimmys_macbook/Desktop/stuff/files/ABR Test/ABRanalysis/'; %ENTER the path of your 'ABRAnalysis' folder
    project_DIR='/Volumes/Heinz-Lab/Users/Jim/ABR_Test/'; %ENTER the path of your project folder

    abr_root_dir = [code_DIR 'ABR-master/Matlab_ABR/'];
    abr_data_dir = [project_DIR 'Data/'];
    abr_out_dir = [project_DIR 'Analysis/ABR/'];

    addpath([abr_root_dir 'ABR_analysis/'])
    cd([abr_root_dir 'ABR_analysis/'])
else %Use if using Windows/Linux
    addpath(genpath('Add code directory')) %ENTER the path of the directory containing your 'ABRAnalysis' folder
    addpath(genpath('Add project directory')) %ENTER the path of the directory containing your project folder
    code_DIR='Add code directory'; %ENTER the path of your 'ABRAnalysis' folder
    project_DIR='Add project directory'; %ENTER the path of your project folder

    abr_root_dir = [code_DIR 'ABR-master\Matlab_ABR\'];
    
    abr_data_dir = [project_DIR 'Data\'];
    abr_out_dir = [project_DIR 'Analysis\ABR\'];
    
    addpath([abr_root_dir 'ABR_analysis\'])
    cd([abr_root_dir 'ABR_analysis\'])
end

abr_analysis_HL

