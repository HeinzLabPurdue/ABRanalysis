function update_picnums_for_freqval(freq_val_kHz)%,animal,hearingStatus)

global abr_FIG abr_Stimuli abr_data_dir data han animal hearingStatus dataFolderpath viewraw dimcheck

%% Check if checkbox is already dim
if dimcheck == 1
   set(han.viewraw,'Enable','off');
else
    %Reset checkbox to unchecked when loading new frequency set
    viewraw = 0;
    set(han.viewraw,'Enable','on');
    set(han.viewraw,'Value',0);  
end

%% Checks to see if user wants to save before clearing data
if ~isempty(data)
    if isfield(data, 'save_chk')
        if (data.save_chk == 0) && (sum(sum(~isnan(data.x))) ~= 0)
            ButtonName=questdlg('Would you like to save?');
            if strcmp(ButtonName,'Yes')
                save_file2_HG;
            elseif strcmp(ButtonName,'Cancel')
                return
            end
        else
            data.save_chk = 0;
        end
    elseif isfield(data, 'x') %this still asks when just open file?
        if sum(sum(~isnan(data.x))) ~= 0
            ButtonName=questdlg('Would you like to save?');
            if strcmp(ButtonName,'Yes')
                save_file2_HG;
            elseif strcmp(ButtonName,'Cancel')
                return
            end
        end
    end
end

%{
if ~isempty(data)
    if isfield(data,'x')
        if sum(sum(~isnan(data.x)))
            ButtonName=questdlg('Would you like to save?');
            if strcmp(ButtonName,'Yes')
                save_file2_HG;
            elseif strcmp(ButtonName,'Cancel')
                return
            end
        end
    end
end
%}

%HG Added 10/21/19
% Qanimal = strcat('Q',num2str(animal));
% if hearingStatus == 'NH'
%     condFolder = 'pre';
% elseif hearingStatus = 'HI'
%     condFolder = 'post';
% end


%ExpDir=fullfile(abr_data_dir,Qanimal,'ABR',condFolder,abr_Stimuli.dir); %%%THIS
ExpDir = dataFolderpath;
cd(ExpDir);
if freq_val_kHz~=0
    allfiles=dir(['a*ABR*' num2str(round(freq_val_kHz*1e3)) '*.mat']);
    if isempty(allfiles)
        allfiles=dir(['p*ABR*' num2str(round(freq_val_kHz*1e3)) '*.mat']);
    end
elseif freq_val_kHz==0
    allfiles=dir('a*ABR*click*.mat');
    if isempty(allfiles)
        allfiles=dir('p*ABR*click*.mat');
    end
end

SPL=nan(1,length(allfiles));
ABRpics=nan(1,length(allfiles));

for i=1:length(allfiles)
    filename=allfiles(i).name;
%     eval(['run(''' filename ''');']);
%     eval('x=ans;')
    load(filename,'x');
    if ~isfield(x.Stimuli,'MaxdBSPLCalib')
        allcalfiles=dir('p*calib*');
        calfile=allcalfiles(1).name;
        x.Stimuli.MaxdBSPLCalib=read_calib_interpolated(calfile,x.Stimuli.freq_hz/1e3);
    end
    
    SPL(i)=x.Stimuli.MaxdBSPLCalib-x.Stimuli.atten_dB;
    if SPL(i)<=abr_Stimuli.maxdB2analyze+2
        ABRpics(i)=str2double(allfiles(i).name(2:5));
    end
end

ABRpics(isnan(ABRpics))=[];
new_value=MakeInputPicString(ABRpics);

set(abr_FIG.parm_txt(2),'string',upper(new_value));
abr_Stimuli.abr_pic = new_value;

zzz5;
set(han.peak_panel,'Box','on');
set(abr_FIG.handle, 'CurrentObject', abr_FIG.push.edit);


