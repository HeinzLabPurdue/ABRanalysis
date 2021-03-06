function update_params;	

global FIG Stimuli root_dir						

fid = fopen(fullfile(root_dir,'calibrate','private','get_cal_ins.m'),'wt');

fprintf(fid,'%s\n\n','%QuickCal Instruction Block');

fprintf(fid,'%s%6.3f%s\n','Stimuli = struct(''frqlo'',',Stimuli.frqlo,', ...');
fprintf(fid,'\t%s%6.3f%s\n'  ,'''frqhi'', ',Stimuli.frqhi,', ...');
fprintf(fid,'\t%s%6.3f%s\n'  ,'''frqcal'',',Stimuli.frqcal,', ...');
fprintf(fid,'\t%s%6.3f%s\n'  ,'''attencal'',',Stimuli.attencal,', ...');
fprintf(fid,'\t%s%s%s\n'  ,'''nmic'',  ''',Stimuli.nmic,''');');

fclose(fid);
