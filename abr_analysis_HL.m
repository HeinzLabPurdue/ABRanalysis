function abr_analysis_HL(command_str,parm_num)

% June 21 2020 - taken from abr_analysis4_MH_HG2 (in Hannah's
% Y:\Users\Hannah\ARO_2018_MEMR_TTS\Analysis\ABR\Development)
% moved to Y:\HeinzLabCode for HeinzLab general use (abr_analysis_HL) 

%This function computes an ABR threshold based on series of AVERAGER files.

global paramsIN abr_FIG abr_Stimuli abr_root_dir abr_data_dir hearingStatus animal data ...
    han invert abr_out_dir freq date dataFolderpath viewraw

disp('in abr_analysis_HL.m')

% abr_root_dir, abr_data_dir, abr_out_dir must be set in abr_setup, and
% made global
paramsIN.abr_root_dir= abr_root_dir;

if nargin < 1
    
    get_noise;
    co=[0.0000    0.4470    0.7410;
        0.8500    0.3250    0.0980;
        0.9290    0.6940    0.1250;
        0.4940    0.1840    0.5560;
        0.4660    0.6740    0.1880;
        0.3010    0.7450    0.9330;
        0.6350    0.0780    0.1840; ];
    set(groot,'defaultAxesColorOrder',co);
    
    abr_gui_initiate; %% Makes the GUI visible
    
    %HG ADDED 9/30
    dataChinDir = pwd;
    
    %Set dummy variable for "view raw data" checkbox
    %viewraw = 0;
    
%Sets user-initiated value edit box
elseif strcmp(command_str,'stimulus')
    if ~isempty(get(abr_FIG.push.edit,'string'))
        new_value = get(abr_FIG.push.edit,'string');
        set(abr_FIG.push.edit,'string',[]);
        set(abr_FIG.parm_txt(parm_num),'string',upper(new_value));
        switch parm_num
            case 1
                abr_Stimuli.cal_pic = new_value;
            case 2
                abr_Stimuli.abr_pic = new_value;
            case 3
                abr_Stimuli.start = str2double(new_value);
            case 4
                abr_Stimuli.end = str2double(new_value);
            case 5
                abr_Stimuli.start_template = str2double(new_value);
            case 6
                abr_Stimuli.end_template = str2double(new_value);
            case 7
                abr_Stimuli.num_templates = str2double(new_value);
            case 8
                abr_Stimuli.maxdB2analyze= str2double(new_value);
        end
    else
        set(abr_FIG.push.edit,'string','ERROR');
    end
 
elseif strcmp(command_str,'nextPics')
    clear global 'replot';
    
    %HERE!!
    
    %If user has edited the figure in any way (threshold editing, peak
    %picking, etc.), checks to see if user wants to save before clearing data
    if ~isempty(data)
        if sum(sum(~isnan(data.x)))
            ButtonName=questdlg('Would you like to save?');
            if strcmp(ButtonName,'Yes')
                save_file2_HG; %Saves mat file
            elseif strcmp(ButtonName,'Cancel')
                return
            end
        end
    end
    
    %revised check for pop up box - CH
    %{
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
    %}
    
    %ExpDir=fullfile(abr_data_dir,abr_Stimuli.dir);
    ExpDir = dataFolderpath;
    cd(ExpDir);
    hhh=dir('a*ABR*'); %Looking at a-files only (not p-files)
    %     ABRpics=zeros(1,length(hhh));
    z = str2double(hhh(1).name(2:5));
    ABRpics=zeros(1,(length(hhh)+(z-1)));
    ABRfreqs=zeros(1,(length(hhh)+(z-1)));
%     for i=1:length(hhh)
    for i=z:length(ABRfreqs) 
%         ABRpics(i)=str2double(hhh(i).name(2:5);
%         ABRfreqs(i)=str2double(hhh(i).name(11:14);
        ABRpics(i)=str2double(hhh(i-(z-1)).name(2:5));
        ABRfreqs(i)=str2double(hhh(i-(z-1)).name(11:14));
%         hhh(i).freq = str2double(hhh(i).name(11:14));
    end
    
    if ABRfreqs(end) == 0
        ABRfreqs = ABRfreqs(1:end-1);
    end
%     new_hhh = struct2table(hhh);
%     sortedhhh = sortrows(new_hhh, 'freq', 'ascend');
%     sortedhhh = table2struct(sortedhhh);
%     hhh = sortedhhh;
%     if strcmp(get(han.abr_panel,'Box'),'on')
%         firstPic=max(ParseInputPicString_V2(abr_Stimuli.abr_pic))+1;
%     else
%         firstPic=min(ABRpics);
%     end

    freqORDER = [500 1000 2000 4000 8000 NaN];

    %AS | THIS SEEMS BADLY WRITTEN. COME BACK TO THIS
    %if strcmp(get(han.abr_panel,'Box'),'on')
        %firstPic=max(ParseInputPicString_V2(abr_Stimuli.abr_pic))+1;
        xxx = ABRfreqs(ParseInputPicString_V2(abr_Stimuli.abr_pic));
        xx = xxx(1:end-1); %Remove last pt which is next freq
        avgx = mean(xx); %all pts should have same value
        set(abr_FIG.push.freq500,'Value',0);        
        set(abr_FIG.push.freq1k,'Value',0);
        set(abr_FIG.push.freq2k,'Value',0);
        set(abr_FIG.push.freq4k,'Value',0);
        set(abr_FIG.push.freq8k,'Value',0);
        set(abr_FIG.push.freqClick,'Value',0);
        if isequaln(freq,500)
            set(abr_FIG.push.freq1k,'Value',1);
        end
        if isequaln(freq,1000)
            set(abr_FIG.push.freq2k,'Value',1);
        end
        if isequaln(freq,2000)
            set(abr_FIG.push.freq4k,'Value',1);
        end
        if isequaln(freq,4000)
            set(abr_FIG.push.freq8k,'Value',1);
        end
        if isequaln(freq,8000)
            set(abr_FIG.push.freqClick,'Value',1);
        end
        if isequaln(freq,0)
            set(abr_FIG.push.freq500,'Value',1);
        end
        if isequaln(avgx,xx(1))
            %Find next freq
%             freqNOW1 = find(freqORDER==avgx);f
%             freqNOW = freqORDER(freqNOW1);
            if ~isnan(avgx) %NaN is last element
                freqNOW1 = find(freqORDER==avgx);
                freqNOW = freqORDER(freqNOW1);
                freqNEXT = freqORDER(freqNOW1+1);
            elseif isnan(avgx) %circle back!
               freqNEXT = freqORDER(1);
            end
            
            if ~isnan(freqNEXT)
                ABRfreqsNEXT = find(ABRfreqs==freqNEXT);
            elseif isnan(freqNEXT)
                ABRfreqsNEXT = find(isnan(ABRfreqs));
            end
            ABRpicsNEXT = ABRpics(ABRfreqsNEXT);
        end
    %else
     %   firstPic=min(ABRpics);
    %end
    
    %Set freq label -- fix!!!!
    %text(0.24,0.9375,['Freq: ' num2str(freqNEXT) ' Hz'],'FontSize',14,'horizontalalignment','left','VerticalAlignment','bottom');
    %text(0.24,0.9375,['Freq: ' num2str(freqNEXT) ' Hz'],'FontSize',14);
    
%     if firstPic <= max(ABRpics)
%         freqTarget=min(ABRfreqs(ABRpics==firstPic));
%         picNow=firstPic;
%         %while (ABRfreqs(ABRpics==picNow)==freqTarget) & (picNow <= max(ABRpics)) %HG changed && to & on 10/23/19        
%         while isequaln(ABRfreqs(ABRpics==picNow),freqTarget) & (picNow <= max(ABRpics))
%             lastPic=picNow;
%             picNow=picNow+1;
%         end
%         new_value=[num2str(firstPic) '-' num2str(lastPic)];
%     else %Circle back around to first freq when at last freq
%         firstPic = min(ABRpics);
%         freqTarget=min(ABRfreqs(ABRpics==firstPic));
%         picNow=firstPic;
%         %while (ABRfreqs(ABRpics==picNow)==freqTarget) & (picNow <= max(ABRpics))
%         while isequaln(ABRfreqs(ABRpics==picNow),freqTarget) & (picNow <= max(ABRpics))
%            lastPic=picNow;
%            picNow=picNow+1;
%         end
%         %new_value=abr_Stimuli.abr_pic;
%         new_value=[num2str(firstPic) '-' num2str(lastPic)];
%     end
%     
    %set(abr_FIG.parm_txt(2),'string',upper(new_value));
    firstPic = min(ABRpicsNEXT);
    if (ABRpicsNEXT(1)+(length(ABRpicsNEXT)-1)) ~= ABRpicsNEXT(end)
        m = 2;
        if (ABRpicsNEXT(1)+1) ~= ABRpicsNEXT(2)
            for i = 1:length(ABRpicsNEXT)
                if (ABRpicsNEXT(i)+1) == ABRpicsNEXT(i+1)
                    firstPic = ABRpicsNEXT(i);
                    lastPic = ABRpicsNEXT(end);
                    break
                end
            end
        else
            for i = 1:length(ABRpicsNEXT)
                if (ABRpicsNEXT(i)+1) ~= ABRpicsNEXT(m)
                    lastPic = ABRpicsNEXT(i);
                    break
                end
                m = m + 1;
            end
        end
    else
        lastPic = max(ABRpicsNEXT);
    end
%     firstPic = min(ABRpicsNEXT);
%     lastPic = max(ABRpicsNEXT);
    new_value=[num2str(firstPic) '-' num2str(lastPic)];
    set(abr_FIG.parm_txt(2),'string',upper(new_value));
    abr_Stimuli.abr_pic = new_value;
    
    clear global 'replot'
    zzz2;
    set(han.peak_panel,'Box','on');
    set(abr_FIG.handle, 'CurrentObject', abr_FIG.push.edit);
    
elseif strcmp(command_str,'directory')
    abr_Stimuli.dir = get_directory;
    %TODO JB: Find inactive freqs and disable inactive freq buttons
    TEMPdir=dir('*2000.mat');
    if isempty(TEMPdir)
        set(abr_FIG.push.freq2k,'Enable','off');
    end
    set(han.abr_panel,'Box','off');
    set(han.peak_panel,'Box','off');
    set(abr_FIG.dir_txt,'string',abr_Stimuli.dir);
    
    if strcmp(get(han.abr_panel,'Box'),'off')
%         animal= cell2mat(cellfun(@(x) sscanf(char(x{1}), '-Q%d*'), regexp(abr_Stimuli.dir,'(-Q\d+)','tokens'), 'UniformOutput', 0));
        animal = sscanf(abr_Stimuli.dir, 'Q%d');
        
        paramsIN.animal= animal;
        if contains(lower(abr_Stimuli.dir), {'nh', 'pre'})
            hearingStatus = 'NH';
        elseif contains(lower(abr_Stimuli.dir), {'hi', 'pts', 'tts', 'post'})
            hearingStatus= 'HI';
        end
        paramsIN.hearingStatus= hearingStatus;
        axes(han.text_panel);
        text(0.04,0.95,['Q' num2str(paramsIN.animal) ':'],'FontSize',14,'horizontalalignment','left','VerticalAlignment','bottom')
        set(han.abr_panel,'Box','on');
    end
    
elseif strcmp(command_str,'peaks')
    replot_data;
    set(han.peak_panel,'Box','on');
    set(abr_FIG.handle, 'CurrentObject', abr_FIG.push.edit);

    
elseif strcmp(command_str,'process')
    clear global 'replot'
    zzz2;
    set(han.peak_panel,'Box','on');
    set(abr_FIG.handle, 'CurrentObject', abr_FIG.push.edit);

elseif strcmp(command_str,'refdata')
    if strcmp(get(han.peak_panel,'Box'),'on')
        refdata;
    else
        msgbox('Load new ABR files before plotting reference data')
    end
    set(abr_FIG.handle, 'CurrentObject', abr_FIG.push.edit);

elseif strcmp(command_str,'viewraw')
    %The checkbox should only be pressed if AC data exists
    
	%Situation 1: Corrected data has been plotted, want to go back and
  	%plot raw data
   	%AC performed = araw files exist
    %///
  	%Situation 2: AC not needed
  	%AR_marker = 1 in a file
  	%Automatically check the box and do not let user to uncheck box
   	%since only raw data exists
  	%Pop-up warning to remind user that AC was not performed
    
    viewraw = get(han.viewraw,'Value'); %should become equal to 1
    zzz5;


%KEEP cbh and cbh2????  
elseif strcmp(command_str,'cbh')
    if strcmp(get(han.peak_panel,'Box'),'on')
       stop=0;
       %AR_marker=0;
       vertLineMarker = 0;
       plot_data2(stop,vertLineMarker);
    else
        msgbox('Load new ABR files before plotting reference data')
    end
    set(abr_FIG.handle, 'CurrentObject', abr_FIG.push.edit);
    
elseif strcmp(command_str,'cbh2')
    if strcmp(get(han.peak_panel,'Box'),'on')
        AVG_refdata2;
    else
        msgbox('Load new ABR files before plotting reference data')
    end
    set(abr_FIG.handle, 'CurrentObject', abr_FIG.push.edit);
    
elseif strcmp(command_str,'invert')
    invert=get(han.invert,'Value');
    clear global 'replot'
    zzz2;
    
elseif strcmp(command_str,'change_weights')
    if strcmp(get(han.peak_panel,'Box'),'on')
        change_weights;
    else
        msgbox('Load ABR files before optimizing model fit')
    end
    set(abr_FIG.handle, 'CurrentObject', abr_FIG.push.edit);
    
elseif strcmp(command_str,'peak1')
    if strcmp(get(han.peak_panel,'Box'),'on')
        peak2('P',1);
    else
        msgbox('Load new ABR files before marking peaks');
    end
    set(abr_FIG.handle, 'CurrentObject', abr_FIG.push.edit);
    
elseif strcmp(command_str,'trou1')
    if strcmp(get(han.peak_panel,'Box'),'on')
        peak2('N',1)
    else
        msgbox('Load new ABR files before marking peaks');
    end
    set(abr_FIG.handle, 'CurrentObject', abr_FIG.push.edit);
    
elseif strcmp(command_str,'peak2')
    if strcmp(get(han.peak_panel,'Box'),'on')
        peak2('P',2)
    else
        msgbox('Load new ABR files before marking peaks')
    end
    set(abr_FIG.handle, 'CurrentObject', abr_FIG.push.edit);
    
elseif strcmp(command_str,'trou2')
    if strcmp(get(han.peak_panel,'Box'),'on')
        peak2('N',2)
    else
        msgbox('Load new ABR files before marking peaks')
    end
    set(abr_FIG.handle, 'CurrentObject', abr_FIG.push.edit);
    
elseif strcmp(command_str,'peak3')
    if strcmp(get(han.peak_panel,'Box'),'on')
        peak2('P',3)
    else
        msgbox('Load new ABR files before marking peaks')
    end
    set(abr_FIG.handle, 'CurrentObject', abr_FIG.push.edit);
    
elseif strcmp(command_str,'trou3')
    if strcmp(get(han.peak_panel,'Box'),'on')
        peak2('N',3)
    else
        msgbox('Load new ABR files before marking peaks')
    end
    set(abr_FIG.handle, 'CurrentObject', abr_FIG.push.edit);
    
elseif strcmp(command_str,'peak4')
    if strcmp(get(han.peak_panel,'Box'),'on')
        peak2('P',4)
    else
        msgbox('Load new ABR files before marking peaks')
    end
    set(abr_FIG.handle, 'CurrentObject', abr_FIG.push.edit);
    
elseif strcmp(command_str,'trou4')
    if strcmp(get(han.peak_panel,'Box'),'on')
        peak2('N',4)
    else
        msgbox('Load new ABR files before marking peaks')
    end
    set(abr_FIG.handle, 'CurrentObject', abr_FIG.push.edit);
    
elseif strcmp(command_str,'peak5')
    if strcmp(get(han.peak_panel,'Box'),'on')
        peak2('P',5)
    else
        msgbox('Load new ABR files before marking peaks')
    end
    set(abr_FIG.handle, 'CurrentObject', abr_FIG.push.edit);
    
elseif strcmp(command_str,'trou5')
    if strcmp(get(han.peak_panel,'Box'),'on')
        peak2('N',5)
    else
        msgbox('Load new ABR files before marking peaks')
    end
    set(abr_FIG.handle, 'CurrentObject', abr_FIG.push.edit);

    
%elseif strcmp(command_str,'autofdind') %AUTOFIND FUNCTION HERE -- DOES NOTHING???
    %peak1af2;
    %set(abr_FIG.handle, 'CurrentObject', abr_FIG.push.edit);

%Commented out AR on 2/19/20 -- restructuring
%elseif strcmp(command_str,'artifactrejection') %HG ADDED 2/5/20 -- ARTIFACT REJECTION
    
    %clearvars abr_AR
    %Number of lowest levels to average
    %n = 3;
    
    %Average levels -- bring this into ar function
    %levelstoAvg = abr(:,end-n+1:end);
    %meanLevels = mean(levelstoAvg,2);
    
    %Pop-up figure for sanity check
%     figure;
%     for r = 1:n
%        plot(abr_time,levelstoAvg(:,r));
%        hold on;
%     end
%     plot(abr_time,meanLevels(:,1),'k','LineWidth',2);
%     title('Sanity Check - Demeaning','FontSize',14);
%     xlabel('Time in ms', 'FontSize',12);
%     ylabel('Amplitude in uV','FontSize',12);
%     xlim([0 30]);
    
%     %Question dialog pop-up
%     continueButton=questdlg('Would you like to continue demeaning?');
%     if strcmp(continueButton,'Yes')
%         %Replot waterfall after subtracting mean waveform from each
%         close(gcf);
%         abr_artifact_rejection(meanLevels)
%     elseif strcmp(continueButton,'No')
%     	close(gcf);
%     elseif strcmp(continueButton,'Cancel')
%     	return
%     end
    
    %set(abr_FIG.handle, 'CurrentObject', abr_FIG.push.edit);

%PRINT
elseif strcmp(command_str,'print')
    set(gcf,'PaperOrientation','portrait');
    %curChinDir= strrep(strcat(abr_out_dir, 'Q',num2str(animal),'_',hearingStatus,'_',date, filesep), '-', '_');
   
    %HG ADDED 9/30/19
    date=abr_Stimuli.dir(4:13);
    
    q_fldr = strcat('Q', num2str(animal));
    if strcmp('pre',regexp(abr_Stimuli.dir,'pre','match')) == 1
        type = 'pre';
    elseif strcmp('post',regexp(abr_Stimuli.dir,'post','match')) == 1
        type = 'post';
    else
        type = 'none';
    end
    ChinDir = strcat(abr_out_dir, q_fldr, filesep, type, filesep);
    
    if ~isdir(ChinDir)
        mkdir(ChinDir);
    end
    cd(ChinDir)
    
    x = dir;
    fldr = "";
    for i = 1:length(x)
        if (~contains(x(i).name,'.'))&&(~contains(x(i).name,'.DS_Store','IgnoreCase',true))
            fldr = x(i).name;
        end
    end
    currChinDir = strcat(ChinDir, fldr);
    cd(currChinDir)
    
%     curChinDir1= strrep(strcat('Q',num2str(animal),'_',hearingStatus,'_',date, filesep), '-', '_');
%     curChinDir = strcat(abr_out_dir,curChinDir1);
%     
%     if ~isdir(curChinDir)
%         mkdir(curChinDir);
%     end
%     
%     %HG ADDED 9/30/19
%     %Make sure saving is done in correct folder
%     cd(curChinDir)
    
    if freq~=0 %HG EDITED 9/30/19
        %fName= strrep(strcat(curChinDir, 'Q',num2str(animal),'_',hearingStatus,'_', num2str(freq), 'Hz','_',date), '-', '_');
        %fName= strrep(horzcat(curChinDir, 'Q',num2str(animal),'_',hearingStatus,'_', num2str(freq), 'Hz','_',date), '-', '_');
        fName= strrep(horzcat('Q',num2str(animal),'_',hearingStatus,'_', num2str(freq), 'Hz','_',date), '-', '_');
    else
        %fName= strrep(strcat(curChinDir, 'Q',num2str(animal),'_',hearingStatus,'_', 'click','_',date), '-', '_');
        %fName= strrep(horzcat(curChinDir, 'Q',num2str(animal),'_',hearingStatus,'_', 'click','_',date), '-', '_');
        fName= strrep(horzcat('Q',num2str(animal),'_',hearingStatus,'_', 'click','_',date), '-', '_');
    end
    
    %Save tiff figure
    saveas(gcf, fName, 'tiff');
    
    %HG ADDED 9/30/19
    %Notifying tiff figure was saved -- from save_file2_HG.m
    filename = strcat('Q',num2str(animal),'_',hearingStatus,'_',date);
    figure(22); set(gcf,'Units','normalized','Position',[0.5 0.5 0.2 0.1])
    text(0,0,['File printed as tiff:' filename])
    axis off; pause(0.5); close(22);
    
    % % % %     set(gcf,'PaperOrientation','Landscape','PaperPosition',[0 0 11 8.5]);
    % % % %     if ispc
    % % % %         print('-dwinc','-r200');
    % % % %     else
    % % % %         print('-PNeptune','-dpsc','-r200','-noui');
    % % % %     end

%SAVE -- pressing push button "Save as File"
elseif strcmp(command_str,'file')
    if strcmp(get(han.abr_panel,'Box'),'on')
        save_file2_HG
        data.save_chk = 1;
    else 
        %save_file2_HG;
        msgbox('Data not saved')
    end
    
elseif strcmp(command_str,'edit') % added by GE 15Apr2004 %NEED THIS? -HG
    
elseif strcmp(command_str,'close') %NEED THIS? -HG
    update_params3;
    closereq;
    cd(fileparts(abr_root_dir(1:end-1)));
    
elseif strcmp(command_str,'freq_proc500')
    clear global 'replot';
    update_picnums_for_freqval(parm_num) %animal,hearingStatus);
    set(abr_FIG.push.freq1k,'Value',0);
    set(abr_FIG.push.freq2k,'Value',0);
    set(abr_FIG.push.freq4k,'Value',0);
    set(abr_FIG.push.freq8k,'Value',0);
    set(abr_FIG.push.freqClick,'Value',0);
elseif strcmp(command_str,'freq_proc1k')
    clear global 'replot';
    update_picnums_for_freqval(parm_num) %animal,hearingStatus);
    set(abr_FIG.push.freq500,'Value',0);
    set(abr_FIG.push.freq2k,'Value',0);
    set(abr_FIG.push.freq4k,'Value',0);
    set(abr_FIG.push.freq8k,'Value',0);
    set(abr_FIG.push.freqClick,'Value',0);
elseif strcmp(command_str,'freq_proc2k')
    clear global 'replot';
    update_picnums_for_freqval(parm_num) %animal,hearingStatus);
    set(abr_FIG.push.freq1k,'Value',0);
    set(abr_FIG.push.freq500,'Value',0);
    set(abr_FIG.push.freq4k,'Value',0);
    set(abr_FIG.push.freq8k,'Value',0);
    set(abr_FIG.push.freqClick,'Value',0);
elseif strcmp(command_str,'freq_proc4k')
    clear global 'replot';
    update_picnums_for_freqval(parm_num) %animal,hearingStatus);
    set(abr_FIG.push.freq1k,'Value',0);
    set(abr_FIG.push.freq2k,'Value',0);
    set(abr_FIG.push.freq500,'Value',0);
    set(abr_FIG.push.freq8k,'Value',0);
    set(abr_FIG.push.freqClick,'Value',0);
elseif strcmp(command_str,'freq_proc8k')
    clear global 'replot';
    update_picnums_for_freqval(parm_num) %animal,hearingStatus);
    set(abr_FIG.push.freq1k,'Value',0);
    set(abr_FIG.push.freq2k,'Value',0);
    set(abr_FIG.push.freq4k,'Value',0);
    set(abr_FIG.push.freq500,'Value',0);
    set(abr_FIG.push.freqClick,'Value',0);
elseif strcmp(command_str,'freq_procClick')
    clear global 'replot';
    update_picnums_for_freqval(parm_num) %animal,hearingStatus);
    set(abr_FIG.push.freq1k,'Value',0);
    set(abr_FIG.push.freq2k,'Value',0);
    set(abr_FIG.push.freq4k,'Value',0);
    set(abr_FIG.push.freq8k,'Value',0);
    set(abr_FIG.push.freq500,'Value',0);
end