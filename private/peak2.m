%function [pastPeaks] = peak2(type,id,pastPeaks)
function peak2(type,id)

%HG ADDED 2/6/20
%In order to add in vertical line 3 ms after P1


global abr_Stimuli num abr upper_y_bound lower_y_bound y_shift data abr_time abr padvoltage AR_marker abr_FIG

warning off;

%Keep track of past peaks picked
%Peaks = [P1 N1 P2 N2 P3 N3 P4 N4 P5 N5];
%pastPeaks = [0 0 0 0 0 0 0 0 0 0];

%Initializes marker
vertLineMarker = 0;

x=abr_Stimuli.start;
while x >= abr_Stimuli.start && x <= abr_Stimuli.end
    hold on;
    [x,y,marker] = ginput(1);
    %Marker=1 if left mouse button pressed
    %Marker=2 if middle mouse button pressed
    %Marker=3 if right mouse button pressed
    %Plot points
    ax = gca;
    %User chosen-peak ONLY, NOT optimized peak
    %plot(ax,x,y,'b*');
    
    %Find dB SPL plot - HG added
    %     for w=1:num
    %         if ((y<= upper_y_bound(w)) & (y>= lower_y_bound(w)))
    %             ydata = abr(:,w);
    %             xdata = abr_time;
    %             lowbound = lower_y_bound(w);
    %             highbound = upper_y_bound(w);
    %         end
    %     end
    
    %Find dB SPL plot - HG added
    for i=1:num
        if y>lower_y_bound(1,i) & y<upper_y_bound(1,i)
            index=i;
        end
    end
    
    %Set initial cutoff
    cutoff = 0.15;
    
    %Colors
    linestyles = {'--','--',':','-.'};
    colors = {'r','c'};
    
    %Peak 1, P2, P3, P4, P5
    colors2 = {'r','b','m','g','c'};
    
    %Peak
    exitwhile = 0;
    count = 1;
    stop2 = 0;
    %assumption -- FIX - ADD in IF statements
    maxloops = 10; %correlates to count
    maxpeaks = 30; %correlates to pks
    maxtime = 30;
    %if type == 'P' & x >= abr_Stimuli.start & x <= abr_Stimuli.end
    %if (x >= abr_Stimuli.start & x <= abr_Stimuli.end)
    if (type == 'P')
        invert = 1;
    else %type N
        invert = -1;
    end
    %declare pks
    pks2 = zeros(maxloops,maxpeaks);
    time_loc = zeros(maxtime,maxpeaks);
    %Loop for user choosing peaks
    %while ((exitwhile == 0) && (x >= abr_Stimuli.start & x <= abr_Stimuli.end))
    while (exitwhile == 0)
        if (x < abr_Stimuli.start || x > abr_Stimuli.end)
            stop2 = 1;
            break;
        end
        %[yy, xx]=max(abr(bin_of_time(x-0.15):bin_of_time(x+0.15),index));
        %xxx=time_of_bin(xx)+time_of_bin(bin_of_time(x-0.15));
        [yy, xx]=max(abr(bin_of_time(x-cutoff(count)):bin_of_time(x+cutoff(count)),index));
        xxx=time_of_bin(xx)+time_of_bin(bin_of_time(x-cutoff(count)));
        %Pop-up figure
        if (count == 1) %Only create figure once
            %hfig = figure('Name','Chosen Peaks');
            hfig = figure('Name','Chosen Peaks','units','normalized','outerposition',[0.25 0.15 0.5 0.5]);
            %hfig = uifigure('Name','Chosen Peaks');
            %Move figure lower for visual purposes
            %movegui(hfig,[400 150]);
            %hfig.UIFigure.AutoResizeChildren = 'off';
        end
        secCutoff = 1.5;
        ptofInterest = bin_of_time(xxx);
        time_cutoff1 = xxx-secCutoff;
        time_cutoff2 = xxx+secCutoff;
        bin_time_cutoff1 = bin_of_time(time_cutoff1);
        bin_time_cutoff2 = bin_of_time(time_cutoff2);
        bin_ptofInterest = ptofInterest + bin_time_cutoff1;
        start_pt = bin_time_cutoff1;
        end_pt = bin_time_cutoff2;
        abr_1 = abr(:,index);
        %FIX
        %nfw=5;
        %abr_1_filt = trifilt(abr_1,nfw);
        window = abr(bin_of_time(x-cutoff(count)):bin_of_time(x+cutoff(count)),index);
        bin_start(count)= find(abr_1 == window(1));
        bin_end(count)= find(abr_1 == window(end));
        confidence = 0.99;
        if (count == 1)
            bin_start_cutoff = round(bin_start(count)*confidence);
            bin_end_cutoff = round(bin_end(count)*(1/confidence));
            %bin_start_cutoff = bin_of_time(x*0.9);
            %bin_end_cutoff = bin_of_time(x*1.1);
        end %FIX THIS!
        if (count == 1) %only do once
            %Non-zoomed plot
            %ax11 = subnplot(1,2,1,'Parent',hfig.UIFigure);
            %ax22 = subplot(1,2,2,'Parent',hfig.UIFigure);
            subplot(2,1,1);
            cutoff3 = 1.25;
            ax2 = gca;
            maxPT1 = max(abr_1(start_pt:end_pt,1));
            minPT1 = min(abr_1(start_pt:end_pt,1));
            plot1 = plot(abr_time(1,start_pt:end_pt),abr_1(start_pt:end_pt,1));
            %plot1 = plot(ax11,abr_time(1,start_pt:end_pt),abr_1(start_pt:end_pt,1));
            hold on;
            name = strcat(type,num2str(id));
            title(name);
            ylabel('Amplitude');
            xlabel('Time in ms');
            %ylim([(1/cutoff3)*minPT1, cutoff3*maxPT1]);
            ylim([cutoff3*minPT1, cutoff3*maxPT1]);
            %xlim(abr_time(1,start_pt:end_pt));
            subplot(2,1,2);
            ax3 = gca;
            maxPT2 = max(abr_1(bin_start_cutoff:bin_end_cutoff));
            minPT2 = min(abr_1(bin_start_cutoff:bin_end_cutoff));
            plot2 = plot(abr_time(1,bin_start_cutoff:bin_end_cutoff),abr_1(bin_start_cutoff:bin_end_cutoff));
            %plot2 = plot(ax22,abr_time(1,bin_start_cutoff:bin_end_cutoff),abr_1(bin_start_cutoff:bin_end_cutoff));
            hold on;
            ylabel('Amplitude');
            xlabel('Time in ms');
            %ylim([(1/cutoff3)*minPT2, cutoff3*maxPT2]);
            ylim([cutoff3*minPT2, cutoff3*maxPT2]);
            title(name);
        end
        
        if count > 1
            count2 = 2;
            lineapp1 = strcat(colors{count2-1},linestyles{count2-1}); %old
            lineapp2 = strcat(colors{count2},linestyles{count2}); %current
            for jj = 1:count-1
                subplot(2,1,1);
                %xline(abr_time(bin_start(jj)),lineapp2); %avoid current
                %xline(abr_time(bin_end(jj)),lineapp2);
                %line([abr_time(bin_start(jj)), abr_time(bin_start(jj))],[(1/cutoff3)*minPT1, cutoff3*maxPT1],'Color',colors{count2},'LineStyle',linestyles{count2});
                %line([abr_time(bin_end(jj)), abr_time(bin_end(jj))],[(1/cutoff3)*minPT1, cutoff3*maxPT1],'Color',colors{count2},'LineStyle',linestyles{count2});
                line([abr_time(bin_start(jj)), abr_time(bin_start(jj))],[cutoff3*minPT1, cutoff3*maxPT1],'Color',colors{count2},'LineStyle',linestyles{count2});
                line([abr_time(bin_end(jj)), abr_time(bin_end(jj))],[cutoff3*minPT1, cutoff3*maxPT1],'Color',colors{count2},'LineStyle',linestyles{count2});
                subplot(2,1,2);
                %xline(abr_time(bin_start(jj)),lineapp2); %avoid current
                %xline(abr_time(bin_end(jj)),lineapp2);
                %line([abr_time(bin_start(jj)), abr_time(bin_start(jj))],[(1/cutoff3)*minPT2, cutoff3*maxPT2],'Color',colors{count2},'LineStyle',linestyles{count2});
                %line([abr_time(bin_end(jj)), abr_time(bin_end(jj))],[(1/cutoff3)*minPT2, cutoff3*maxPT2],'Color',colors{count2},'LineStyle',linestyles{count2});
                line([abr_time(bin_start(jj)), abr_time(bin_start(jj))],[cutoff3*minPT2, cutoff3*maxPT2],'Color',colors{count2},'LineStyle',linestyles{count2});
                line([abr_time(bin_end(jj)), abr_time(bin_end(jj))],[cutoff3*minPT2, cutoff3*maxPT2],'Color',colors{count2},'LineStyle',linestyles{count2});
            end
            subplot(2,1,1);
            %xline(abr_time(bin_start(count)),lineapp1); %plot current
            %xline(abr_time(bin_end(count)),lineapp1);
            %line([abr_time(bin_start(count)), abr_time(bin_start(count))],[(1/cutoff3)*minPT1, cutoff3*maxPT1],'Color',colors{count2-1},'LineStyle',linestyles{count2-1});
            %line([abr_time(bin_end(count)), abr_time(bin_end(count))],[(1/cutoff3)*minPT1, cutoff3*maxPT1],'Color',colors{count2-1},'LineStyle',linestyles{count2-1});
            line([abr_time(bin_start(count)), abr_time(bin_start(count))],[cutoff3*minPT1, cutoff3*maxPT1],'Color',colors{count2-1},'LineStyle',linestyles{count2-1});
            line([abr_time(bin_end(count)), abr_time(bin_end(count))],[cutoff3*minPT1, cutoff3*maxPT1],'Color',colors{count2-1},'LineStyle',linestyles{count2-1});
            subplot(2,1,2);
            %xline(abr_time(bin_start(count)),lineapp1); %plot current
            %xline(abr_time(bin_end(count)),lineapp1);
            %line([abr_time(bin_start(count)), abr_time(bin_start(count))],[(1/cutoff3)*minPT2, cutoff3*maxPT2],'Color',colors{count2-1},'LineStyle',linestyles{count2-1});
            %line([abr_time(bin_end(count)), abr_time(bin_end(count))],[(1/cutoff3)*minPT2, cutoff3*maxPT2],'Color',colors{count2-1},'LineStyle',linestyles{count2-1});
            line([abr_time(bin_start(count)), abr_time(bin_start(count))],[cutoff3*minPT2, cutoff3*maxPT2],'Color',colors{count2-1},'LineStyle',linestyles{count2-1});
            line([abr_time(bin_end(count)), abr_time(bin_end(count))],[cutoff3*minPT2, cutoff3*maxPT2],'Color',colors{count2-1},'LineStyle',linestyles{count2-1});
        else %first time through
            count2 = 1;
            lineapp1 = strcat(colors{count2},linestyles{count2}); %current
            subplot(2,1,1);
            %xline(abr_time(bin_start(count)),lineapp1);
            %xline(abr_time(bin_end(count)),lineapp1);
            %line([abr_time(bin_start(count)), abr_time(bin_start(count))],[(1/cutoff3)*minPT1, cutoff3*maxPT1],'Color',colors{count2},'LineStyle',linestyles{count2});
            %line([abr_time(bin_end(count)), abr_time(bin_end(count))],[(1/cutoff3)*minPT1, cutoff3*maxPT1],'Color',colors{count2},'LineStyle',linestyles{count2});
            line([abr_time(bin_start(count)), abr_time(bin_start(count))],[cutoff3*minPT1, cutoff3*maxPT1],'Color',colors{count2},'LineStyle',linestyles{count2});
            line([abr_time(bin_end(count)), abr_time(bin_end(count))],[cutoff3*minPT1, cutoff3*maxPT1],'Color',colors{count2},'LineStyle',linestyles{count2});
            %xline(x,'k:');
            %line([x, x],[(1/cutoff3)*minPT1, cutoff3*maxPT1],'Color','k','LineStyle',':');
            line([x, x],[cutoff3*minPT1, cutoff3*maxPT1],'Color','k','LineStyle',':');
            subplot(2,1,2);
            %xline(abr_time(bin_start(count)),lineapp1);
            %xline(abr_time(bin_end(count)),lineapp1);
            %xline(x,'k:');
            %line([abr_time(bin_start(count)), abr_time(bin_start(count))],[(1/cutoff3)*minPT2, cutoff3*maxPT2],'Color',colors{count2},'LineStyle',linestyles{count2});
            %line([abr_time(bin_end(count)), abr_time(bin_end(count))],[(1/cutoff3)*minPT2, cutoff3*maxPT2],'Color',colors{count2},'LineStyle',linestyles{count2});
            %line([x, x],[(1/cutoff3)*minPT2, cutoff3*maxPT2],'Color','k','LineStyle',':');
            line([abr_time(bin_start(count)), abr_time(bin_start(count))],[cutoff3*minPT2, cutoff3*maxPT2],'Color',colors{count2},'LineStyle',linestyles{count2});
            line([abr_time(bin_end(count)), abr_time(bin_end(count))],[cutoff3*minPT2, cutoff3*maxPT2],'Color',colors{count2},'LineStyle',linestyles{count2});
            line([x, x],[cutoff3*minPT2, cutoff3*maxPT2],'Color','k','LineStyle',':');
        end
        %xline(abr_time(bin_start(count)),'--r');
        %xline(abr_time(bin_end(count)),'--r');
        %line([abr_time(bin_start(count)), abr_time(bin_start(count))],[(1/cutoff3)*minPT2, cutoff3*maxPT2],'Color','r','LineStyle','--');
        %line([abr_time(bin_end(count)), abr_time(bin_end(count))],[(1/cutoff3)*minPT2, cutoff3*maxPT2],'Color','r','LineStyle','--'); 
        line([abr_time(bin_start(count)), abr_time(bin_start(count))],[cutoff3*minPT2, cutoff3*maxPT2],'Color','r','LineStyle','--');
        line([abr_time(bin_end(count)), abr_time(bin_end(count))],[cutoff3*minPT2, cutoff3*maxPT2],'Color','r','LineStyle','--'); 
        %plot(abr_time(bin_start:bin_end),abr(bin_of_time(x-cutoff):bin_of_time(x+cutoff),index),'g');
        %Find peaks in window
        yWindow1 = abr_1(bin_start(count):bin_end(count));
        yWindow = yWindow1*invert;
        minpeakdis = 10;
        [pks,loc] = findpeaks(yWindow,'MinPeakDistance',minpeakdis);
        %First, check to make sure peaks exist at all
        if (length(pks) < 1) 
            %CH made error box more interactive
            answer6 = questdlg('No peaks found. Would you like to repeat?',...
                'No peaks found', 'Repeat', 'Exit', 'Manually enter peak', 'I dont know');
            answer = {answer6};
            if contains(answer, 'Repeat')
                stop2 = 1; %allows code to go back to main while loop
                close(hfig);
                break;
            elseif contains(answer, 'Manually enter peak')
                firstpart3 = strcat('Enter peak time:');
                prompt3 = strcat(firstpart3);
                answer6 = inputdlg(prompt3,'Manual peak selection');
                peakTime = str2double(cell2mat(answer6));
                x11 = peakTime;
                %yD = plot1.Ydata;
                xdata=get(plot1,'Xdata');
                ydata=get(plot1,'Ydata');
                closest = 0;
                mindiff = 100;
                for c = 1:length(xdata)
                    diff = abs(peakTime-xdata(c));
                    if diff < mindiff
                        mindiff = diff;
                        closest = c;
                    end
                end
                y11 = ydata(closest);
                exitwhile = 1;
                
            else
                close(hfig);
                stop2 = 1;
                x = -1; %forces exit of main while loop
                break;
            end
%             errordlg('Error! No peaks found. Repeat.');
%             stop2 = 1;
%             break;
        else %at least one peak found
            if (invert == -1)
                pks = pks*-1;
            end
            pks2(count,1:length(pks')) = pks';
            time_loc_2 = time_of_bin(loc)+abr_time(bin_start(count));
            time_loc(count,1:length(loc')) = time_loc_2;
            if count > 1
                if ((sum(pks2(count-1,:)) - sum(pks2(count,:))) ~= 0) %only change if peaks are different from last time
                    for hh=1:(count-1)
                        len_hh = nnz(pks2(hh,:));
                        subplot(2,1,1);
                        plot(ax2,time_loc(hh,1:len_hh),pks2(hh,1:len_hh),'kx');
                        subplot(2,1,2);
                        plot(ax2,time_loc(hh,1:len_hh),pks2(hh,1:len_hh),'kx');
                    end
                end
                len_hh_2 = nnz(pks2(count,:));
                subplot(2,1,1);
                plot(ax2,time_loc(count,1:len_hh_2),pks2(count,1:len_hh_2),'rx');
                subplot(2,1,2);
                plot(ax3,time_loc(count,1:len_hh_2),pks2(count,1:len_hh_2),'rx');
            else %first time through
                len_hh_2 = nnz(pks2(count,:));
                subplot(2,1,1);
                plot(ax2,time_loc(count,1:len_hh_2),pks2(count,1:len_hh_2),'rx'); %%HERE -- gx??
                subplot(2,1,2);
                plot(ax3,time_loc(count,1:len_hh_2),pks2(count,1:len_hh_2),'rx');
            end
            %plot(ax2,time_loc,pks,'gx');
            if (length(pks) > 1) %if more than one peak exists
                %Option 1: Closest point becomes chosen peak
%                 for kk=1:length(pks2(count,1:len_hh_2)) 
%                     subPts_time(kk) = abs(time_loc(count,kk)-xxx);
%                 end
%                 chosenPeak_sub = min(subPts_time);
%                 chosenPeak_index = find(subPts_time == chosenPeak_sub);
                %Option 2: Max peak becomes chosen peak
                if (invert == 1) %Peak
                    chosenPeak_sub = max(pks2(count,1:len_hh_2));
                else %Trough
                    chosenPeak_sub = min(pks2(count,1:len_hh_2));
                end
                chosenPeak_index = find(pks2(count,1:len_hh_2) == chosenPeak_sub);
                %Same
                chosenPeak(count) = pks(chosenPeak_index);
                time_xx(count) = time_loc(count,chosenPeak_index);
            else
                chosenPeak(count) = pks;
                time_xx(count) = time_loc(1,1);
            end
            if count > 1
                subplot(2,1,1);
                plot(ax2,time_xx(1:count-1),chosenPeak(1:count-1),'cx');
                plot(ax2,time_xx(count),chosenPeak(count),'gx');
                subplot(2,1,2);
                plot(ax3,time_xx(1:count-1),chosenPeak(1:count-1),'cx');
                plot(ax3,time_xx(count),chosenPeak(count),'gx');
            else %first time through
                subplot(2,1,1);
                plot(ax2,time_xx(count),chosenPeak(count),'gx');
                subplot(2,1,2);
                plot(ax3,time_xx(count),chosenPeak(count),'gx');
            end
        end
        %     end
        
        %Location of question dialog box
        %scnsize=get(0,'ScreenSize');
        %FigPos = get(0,'DefaultFigurePosition');
        %Question dialog box
        answer3 = questdlg('Do you agree with the chosen peak?','Yes/No?','Yes','No','I dont know');
        answer = {answer3};
        warning('off','all');
        if contains(answer,'Yes')
            x11 = time_xx(count);
            y11 = chosenPeak(count);
            %plot(ax,x11,y11,'r*');
            exitwhile = 1;
            break;
        elseif contains(answer,'No')
            answer4 = questdlg('Would you like to:','Next Step','User choose peak','Change cutoff','Cancel','I dont know');
            if contains(answer4,'Change cutoff')
                %Option 1: Lower cutoff value
                firstpart = strcat('The  current cutoff is',{' '},'+/-', num2str(cutoff(count,1)),'ms.');
                prompt = strcat(firstpart,{' '},'Enter a lower cutoff value:');
                answer2 = inputdlg(prompt,'Change cutoff');
                count = count+1;
                cutoff(count,1) = str2double(answer2);
                exitwhile = 0;
            elseif contains(answer4, 'User choose peak')
                %First number peaks from left to right
                answer7 = questdlg('Would you like to:','Peak Selection Type','Pick preset peak','Manually enter peak','Cancel','I dont know');
                if contains(answer7,'Pick preset peak')
                    for ww = 1:length(pks)
                        xloc2 = time_loc(count,ww);
                        yloc2 = pks(ww)+0.05;
                        text(ax3,xloc2,yloc2,num2str(ww));
                    end
                    %User inputs peak number
                    firstpart2 = strcat('What point do you want to choose as the peak?');%{' '},'Insert',{' '},num2str(cutoff(count,1)),{'-'},num2str());
                    prompt2 = strcat(firstpart2);
                    answer5 = inputdlg(prompt2,'Choose peak');
                    numberPeak = str2num(cell2mat(answer5));
                    if (numberPeak <= length(pks)) %inputted peak must be one of the peaks 
                        x11 = time_loc(count,numberPeak);
                        y11 = pks(numberPeak);
                        exitwhile = 1;
                    end
                elseif contains(answer7, 'Manually enter peak')
                    firstpart3 = strcat('Enter peak time:');
                    prompt3 = strcat(firstpart3);
                    answer6 = inputdlg(prompt3,'Manual peak selection');
                    peakTime = str2double(cell2mat(answer6));
                    x11 = peakTime;
                    %yD = plot1.Ydata;
                    xdata=get(plot1,'Xdata');
                    ydata=get(plot1,'Ydata');
                    closest = 0;
                    mindiff = 100;
                    for c = 1:length(xdata)
                        diff = abs(peakTime-xdata(c));
                        if diff < mindiff
                            mindiff = diff;
                            closest = c;
                        end
                    end
                    y11 = ydata(closest);
                    exitwhile = 1;
                elseif contains(answer7, 'Cancel')
                    stop2 = 1; %allows code to go back to main while loop
                    close(hfig);
                    break;
                end
            elseif contains(answer4, 'Cancel')
                stop2 = 1; %allows code to go back to main while loop
                close(hfig);
                break;
            else
                warndlg('Potential problem with code.');
            end
        else
            warndlg('Potential problem with code.');
            %end
        end
    end
    
    
    %         %Snap-to-peak functionality - 95% CI - HG added -- OLD
    %         minvalue = xxx*0.95;p
    %         maxvalue = xxx*1.05;
    %         [val,idx] = min(abs(xdata-minvalue));
    %         [val2,idx2] = min(abs(xdata-maxvalue));
    %         yWindow = ydata(idx:idx2);
    %         [pks,loc] = findpeaks(yWindow);
    %         peakLoc = idx + loc;
    %         x1 = xdata(1,peakLoc);
    %         y11 = ydata(peakLoc,1);
    %         %y1 = y11 + lowbound;
    %         y1 = highbound - y11;
    %         size_y = highbound-lowbound;
    %         numPads = size_y/padvoltage;
    %         plot(ax,x1,y1,'b*');
    %         %Problem: ydata is ABR waveform; but y is actually upper to lower y
    %         %bound
    if stop2 == 0
        if marker==1
            %data.x(id*2-1,index)=xxx;
            %data.y(id*2-1,index)=yy;
            %data.y_forfig(id*2-1,index)=yy+y_shift(1,index);
            
            
%             data.x(id*2-1,index)=x11;
%             data.y(id*2-1,index)=y11;
%             data.y_forfig(id*2-1,index)=y11+y_shift(1,index);
%             plot_yy = data.y_forfig(id*2-1,index);
            
            if invert == 1 %P
                data.x(id*2-1,index)=x11;
                data.y(id*2-1,index)=y11;
                data.y_forfig(id*2-1,index)=y11+y_shift(1,index);
                plot_yy = data.y_forfig(id*2-1,index);   
            else %N
                data.x(id*2,index)=x11;
                data.y(id*2,index)=y11;
                data.y_forfig(id*2,index)=y11+y_shift(1,index);
                plot_yy = data.y_forfig(id*2,index);
            end
            
            if (type == 'P') && (id == 1)
                if ((nnz(~isnan(data.x))) >= 3)
                    %Basis is average of P1 for top 3 levels
                    kk = ~isnan(data.x);
                    avgLine = mean(data.x(kk));
                    vertLineMarker = avgLine;
                end
            %else -- initialize earlier
                %vertLineMarker = 0;
            end
                
            
            %Close peak fig
            close(hfig);
            %Plots optimized peak
            %plot(ax,x11,plot_yy,'rx');
            colorPT = strcat(colors2{id},'x');
            plot(ax,x11,plot_yy,colorPT); %line that plots point, needs axes, x coord, y coord, and color.
            %Labels Peak/Trough on waterfall
            %xloc = x11*0.75;
            backtrack_ms = 1;
            %xloc = x11-backtrack_ms;
            %yloc = plot_yy;
            %xloc = x11;
            %yloc = plot_yy-backtrack_ms;
            %text(ax,xloc,yloc,name,'fontsize',8);
            
            %Remember: colors2 = {'r','b','m','g','c'};
            if (invert == 1) %PEAK - place above peak
                text(ax,x11,plot_yy,name,'HorizontalAlignment','center','VerticalAlignment','bottom','fontsize',8,'Color',colors2{id});
            else %TROUGH - place below peak
                text(ax,x11,plot_yy,name,'HorizontalAlignment','center','VerticalAlignment','top','fontsize',8,'Color',colors2{id});  
            end
            
        else
            %elseif marker==3
            warndlg('Use left mouse button ONLY to choose peaks! Repeat to save data.')
            %data.x(id*2-1,index)=NaN; data.y(id*2-1,index)=NaN; data.y_forfig(id*2-1,index)=NaN;
        end
    end
    
    %Trough
    % 	elseif type == 'N' & x >= abr_Stimuli.start & x <= abr_Stimuli.end
    % 		%[yy, xx]=min(abr(bin_of_time(x-0.15):bin_of_time(x+0.15),index));
    % 		%xxx=time_of_bin(xx)+time_of_bin(bin_of_time(x-0.15));
    % 		[yy, xx]=min(abr(bin_of_time(x-cutoff):bin_of_time(x+cutoff),index));
    % 		xxx=time_of_bin(xx)+time_of_bin(bin_of_time(x-cutoff));
    % 		if marker==1
    % 			data.x(id*2,index)=xxx;
    %             data.y(id*2,index)=yy;
    %             data.y_forfig(id*2,index)=yy+y_shift(1,index);
    %         else
    %  		%elseif marker==3
    % 			warndlg('Use left mouse button ONLY to choose peaks! Repeat to save data.')
    %             %data.x(id*2,index)=NaN; data.y(id*2,index)=NaN; data.y_forfig(id*2,index)=NaN;
    %         end
    %
end

%Call plot data function and disable buttons
stop=1;
set(abr_FIG.push.peak1,'Value',0);
set(abr_FIG.push.trou1,'Value',0);
set(abr_FIG.push.peak2,'Value',0);
set(abr_FIG.push.trou2,'Value',0);
set(abr_FIG.push.peak3,'Value',0);
set(abr_FIG.push.trou3,'Value',0);
set(abr_FIG.push.peak4,'Value',0);
set(abr_FIG.push.trou4,'Value',0);
set(abr_FIG.push.peak5,'Value',0);
set(abr_FIG.push.trou5,'Value',0);
%AR_marker = 0;
plot_data2(stop,vertLineMarker)
end




