function abr_setup

[~,host]=system('hostname');
switch (host)
    case {'1353-Baltimore'}
        addpath C:\NEL2\Users\MH\Matlab_ABR\ABR_analysis;
    case {'neurophysiology'}
        addpath C:\NEL\Users\MH\Matlab_ABR\ABR_analysis;
    otherwise
        addpath C:\NEL2\Users\MH\Matlab_ABR\ABR_analysis
end

