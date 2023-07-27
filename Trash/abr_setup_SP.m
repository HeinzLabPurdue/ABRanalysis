function abr_setup_SP
% global AutoLevel_params 
% host = lower(getenv('hostname'));
% switch (host)
% case {'south-chamber'}
%    addpath c:\Users\GE\Matlab_ABR\abr_analysis;
% case {'north-chamber'}
%    addpath d:\Users\GE\Matlab_ABR\abr_analysis;
% end   
cur_dir=pwd;
addpath ([cur_dir filesep 'Matlab_ABR' filesep 'ABR_analysis'])

abr_analysis_SP;