function replot_data

global 	abr_out_dir freq replot animal abr_Stimuli 


q_fldr = strcat('Q', num2str(animal));
if strcmp('pre',regexp(abr_Stimuli.dir,'pre','match')) == 1
    type = 'pre';
elseif strcmp('post',regexp(abr_Stimuli.dir,'post','match')) == 1
    type = 'post';
end
ChinDir = strcat(abr_out_dir, q_fldr, filesep, type, filesep);

cd(ChinDir)

d = dir(fullfile(ChinDir, '*.mat'));
d = d(find((strncmp('.',{d.name},1)==0))); % Only files which are not '.' nor '..'
str = {d.name};
[selection ok] = listdlg('Name', 'File Manager', ...
    'PromptString',   'Select data to replot',...
    'SelectionMode',  'single',...
    'ListSize',       [300,300], ...
    'InitialValue',    1, ...
    'ListString',      str);
drawnow; 

if (ok==0 | isempty(selection))
else
	replotfile=str{selection};
	replot = load([strcat(ChinDir, filesep, replotfile)], 'abrs');
	
	if ismember(freq,replot.abrs.thresholds(:,1))
 		replot.abrs.thresholds(replot.abrs.thresholds(:,1)~=freq,:)=[];    
		replot.abrs.z.par(replot.abrs.z.par(:,1)~=freq,:)=[];              
		replot.abrs.z.score(replot.abrs.z.score(:,1)~=freq,:)=[];        
		replot.abrs.amp(replot.abrs.amp(:,1)~=freq,:)=[];                  
		replot.abrs.x(replot.abrs.x(:,1)~=freq,:)=[];                      
		replot.abrs.y(replot.abrs.y(:,1)~=freq,:)=[];                     
		replot.abrs.waves(replot.abrs.waves(:,1)~=freq,:)=[];
        zzz2;
	else
		msgbox('Unable to replot incompatible data')
    end
end