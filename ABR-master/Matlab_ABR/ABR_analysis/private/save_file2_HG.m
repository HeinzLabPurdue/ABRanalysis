function save_file2

global num freq spl animal date freq_level data abr ABRmag w hearingStatus abr_out_dir abr_Stimuli ...
    AR_marker
%abr_AR AR_marker

filename = strcat('Q',num2str(animal),'_',hearingStatus,'_',date);
figure(22); set(gcf,'Units','normalized','Position',[0.5 0.5 0.2 0.1])
text(0,0,['saving to file:' filename])
axis off; pause(0.5); close(22);

% curChinDir1= strrep(strcat('Q',num2str(animal),'_',hearingStatus,'_',date, filesep), '-', '_');
% curChinDir = strcat(abr_out_dir,curChinDir1);
% if ~isdir(curChinDir)
%     mkdir(curChinDir);    
% end

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
for i = 1:length(x)
    if (~contains(x(i).name,'.'))&&(~contains(x(i).name,'.DS_Store','IgnoreCase',true))
        fldr = x(i).name;
    else
        fldr = '';
    end
end
currChinDir = strcat(ChinDir, fldr);
cd(currChinDir)

if ~isempty(filename)
    %filename2 = char(strcat(curChinDir,filename,'.mat'));
    
    %HG ADDED 9/30/19
    %Make sure saving is done in correct folder
%     cd(curChinDir)
   
    if freq~=0 %HG EDITED 9/30/19
        filename2= strrep(horzcat('Q',num2str(animal),'_',hearingStatus,'_', num2str(freq), 'Hz','_',date), '-', '_');
    else
        filename2= strrep(horzcat('Q',num2str(animal),'_',hearingStatus,'_', 'click','_',date), '-', '_');
    end
    
    freq2=ones(1,num)*freq; replaced=0;
    
    if exist(filename2,'file') %Replaces file if file already exists
        load(filename2)
        if exist('abrs','var')
            if ismember(freq,abrs.thresholds(:,1))
                abrs.thresholds(abrs.thresholds(:,1)==freq,:)=[];
                abrs.z.par(abrs.z.par(:,1)==freq,:)=[];
                abrs.z.score(abrs.z.score(:,1)==freq,:)=[];
                abrs.amp(abrs.amp(:,1)==freq,:)=[];
                abrs.x(abrs.x(:,1)==freq,:)=[];
                abrs.y(abrs.y(:,1)==freq,:)=[];
                abrs.waves(abrs.waves(:,1)==freq,:)=[];
                replaced=1;
            end
            
            if size(abrs.x,2)<12
                abrs.x=[abrs.x nan(size(abrs.x,1),12-size(abrs.x,2))];
                abrs.y=[abrs.y nan(size(abrs.y,1),12-size(abrs.y,2))];
            end
            
            abrs.thresholds = [abrs.thresholds; freq data.threshold data.amp_thresh -freq_level];
            abrs.z.par = [abrs.z.par; freq data.z.intercept data.z.slope];
            abrs.z.score = [abrs.z.score; freq2' spl' data.z.score' w'];
            abrs.amp = [abrs.amp; freq2' ABRmag];
            abrs.x = [abrs.x; freq2' spl' data.x'];
            abrs.y = [abrs.y; freq2' spl' data.y'];
            abrs.waves = [abrs.waves; freq2' spl' abr'];
            
            %HG ADDED 2/11/20
            abrs.AR_marker = AR_marker;
            
            save(filename2, 'abrs','-append'); clear abrs;
            if replaced==0
                figure(22); set(gcf,'Units','normalized','Position',[0.5 0.5 0.2 0.1])
                text(0,0,'data added to ABR field')
                axis off; pause(0.5); close(22);
                
            else
                figure(22); set(gcf,'Units','normalized','Position',[0.5 0.5 0.2 0.1])
                text(0,0,'data replaced in ABR field')
                axis off; pause(0.5); close(22);
                
            end
        else
            abrs.thresholds = [freq data.threshold data.amp_thresh -freq_level];
            abrs.z.par = [freq data.z.intercept data.z.slope];
            abrs.z.score = [freq2' spl' data.z.score' w'];
            abrs.amp = [freq2' ABRmag];
            abrs.x = [freq2' spl' data.x'];
            abrs.y = [freq2' spl' data.y'];
            abrs.waves = [freq2' spl' abr'];
            save(filename2, 'abrs','-append'); clear abrs;
            figure(22); set(gcf,'Units','normalized','Position',[0.5 0.5 0.2 0.1])
            text(0,0,'ABR field added')
            axis off; pause(0.5); close(22);
            
        end
    else %Creates new file because no file currently exists
        abrs.thresholds = [freq data.threshold data.amp_thresh -freq_level];
        abrs.z.par = [freq data.z.intercept data.z.slope];
        abrs.z.score = [freq2' spl' data.z.score' w'];
        abrs.amp = [freq2' ABRmag];
        abrs.x = [freq2' spl' data.x'];
        abrs.y = [freq2' spl' data.y'];
        abrs.waves = [freq2' spl' abr'];
        
        if exist(strcat(filename2, '.mat'),'file')
            filename3 = strcat(filename2, '_old');
            file_num = 2;
            while exist(strcat(filename3, '.mat'),'file')
                filename3 = strcat(filename3, num2str(file_num));
                file_num = file_num + 1;
            end
            copyfile(strcat(filename2, '.mat'), strcat(filename3, '.mat'));
        end
        
        %HG ADDED 2/11/20
        abrs.AR_marker = AR_marker;
        
        save(filename2, 'abrs'); clear abrs;
        figure(22); set(gcf,'Units','normalized','Position',[0.5 0.5 0.2 0.1])
        text(0,0,'New file created')
        axis off; pause(0.5); close(22);
        

    end
end