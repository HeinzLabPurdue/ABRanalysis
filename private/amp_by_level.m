function amp_by_level(hname,freq,level)

global dd han_abrcomp colorr

plot(hname,0,0,'*w',...
		dd(1).data.abrs.y(dd(1).data.abrs.y(:,1)==freq,level),dd(1).data.abrs.y(dd(1).data.abrs.y(:,1)==freq,11),[colorr(1,:) '*-'],...
		dd(2).data.abrs.y(dd(2).data.abrs.y(:,1)==freq,level),dd(2).data.abrs.y(dd(2).data.abrs.y(:,1)==freq,11),[colorr(2,:) '*-'],...
		dd(3).data.abrs.y(dd(3).data.abrs.y(:,1)==freq,level),dd(3).data.abrs.y(dd(3).data.abrs.y(:,1)==freq,11),[colorr(3,:) '*-'],...
		dd(4).data.abrs.y(dd(4).data.abrs.y(:,1)==freq,level),dd(4).data.abrs.y(dd(4).data.abrs.y(:,1)==freq,11),[colorr(4,:) '*-'],...
		dd(5).data.abrs.y(dd(5).data.abrs.y(:,1)==freq,level),dd(5).data.abrs.y(dd(5).data.abrs.y(:,1)==freq,11),[colorr(5,:) '*-'],...
		dd(6).data.abrs.y(dd(6).data.abrs.y(:,1)==freq,level),dd(6).data.abrs.y(dd(6).data.abrs.y(:,1)==freq,11),[colorr(6,:) 'o-'],...
		dd(7).data.abrs.y(dd(7).data.abrs.y(:,1)==freq,level),dd(7).data.abrs.y(dd(7).data.abrs.y(:,1)==freq,11),[colorr(7,:) 'o-'],...
		dd(8).data.abrs.y(dd(8).data.abrs.y(:,1)==freq,level),dd(8).data.abrs.y(dd(8).data.abrs.y(:,1)==freq,11),[colorr(8,:) 'o-'],...
		dd(9).data.abrs.y(dd(9).data.abrs.y(:,1)==freq,level),dd(9).data.abrs.y(dd(9).data.abrs.y(:,1)==freq,11),[colorr(9,:) 'o-'],...
		dd(10).data.abrs.y(dd(10).data.abrs.y(:,1)==freq,level),dd(10).data.abrs.y(dd(10).data.abrs.y(:,1)==freq,11),[colorr(10,:) 'o-'],...
		dd(11).data.abrs.y(dd(11).data.abrs.y(:,1)==freq,level),dd(11).data.abrs.y(dd(11).data.abrs.y(:,1)==freq,11),[colorr(11,:) 'x-'],...
		dd(12).data.abrs.y(dd(12).data.abrs.y(:,1)==freq,level),dd(12).data.abrs.y(dd(12).data.abrs.y(:,1)==freq,11),[colorr(12,:) 'x-'],...
		dd(13).data.abrs.y(dd(13).data.abrs.y(:,1)==freq,level),dd(13).data.abrs.y(dd(13).data.abrs.y(:,1)==freq,11),[colorr(13,:) 'x-'],...
		dd(14).data.abrs.y(dd(14).data.abrs.y(:,1)==freq,level),dd(14).data.abrs.y(dd(14).data.abrs.y(:,1)==freq,11),[colorr(14,:) 'x-'],...
		dd(15).data.abrs.y(dd(15).data.abrs.y(:,1)==freq,level),dd(15).data.abrs.y(dd(15).data.abrs.y(:,1)==freq,11),[colorr(15,:) 'x-'])
	