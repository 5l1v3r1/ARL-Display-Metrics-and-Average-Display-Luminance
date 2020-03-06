function [Events Parameters Stimuli_sets Block_Export Trial_Export  Numtrials]=Demo(Parameters, Stimuli_sets, Trial, Blocknum, Modeflag, Events,Block_Export,Trial_Export,Demodata,fulldata)
load('blockvars')

Parameters.extratimeallowance = .015;
updateRate = .02;
if strcmp(Modeflag,'InitializeBlock')
    clear Stimuli_sets
    
    stimstruct = CreateStimStruct('shape');
    stimstruct.xdim = [1];
    stimstruct.ydim = [10000];
    stimstruct.color = [255,255,255];
    stimstruct.stimuli{1} = 'FillRect';
    Stimuli_sets(1) = Preparestimuli(Parameters,stimstruct);
    
    stimstruct = CreateStimStruct('shape');
    stimstruct.xdim = [54];
    stimstruct.ydim = [54];
    stimstruct.linewidth = 50;
    stimstruct.color = [255,0,0];
    stimstruct.stimuli{1} = 'FillOval';
    Stimuli_sets(2) = Preparestimuli(Parameters,stimstruct);
    
    stimstruct = CreateStimStruct('shape');
    stimstruct.xdim = [1000000];
    stimstruct.ydim = [1];
    stimstruct.color = [255,255,255];
    stimstruct.stimuli{1} = 'FillRect';
    Stimuli_sets(3) = Preparestimuli(Parameters,stimstruct);
    
    stimstruct = CreateStimStruct('shape');
    stimstruct.xdim = [1];
    stimstruct.ydim = [1];
    stimstruct.color = [255,255,255];
    stimstruct.stimuli{1} = 'FillRect';
    Stimuli_sets(4) = Preparestimuli(Parameters,stimstruct);
    %     sca
    %     keyboard
    % Set the number of trials
    Numtrials = 1; %was 36
    
elseif strcmp(Modeflag,'InitializeTrial');
    %this part is to make sure the task bar doesn't show up during the
    %trial
    try
        if ispc
            try
                ShowHideFullWinTaskbarMex(0);
            catch
                ShowHideWinTaskbarMex(0);
            end
        end
    end
    
    %for simplicity, define these shorter variables
    locx = Parameters.centerx;
    locy = Parameters.centery;
    startlocy=1;
    startTime = .02;
    Adj = -653;
    for acrossUp = 1:2
        for pos = 1:5
            if acrossUp == 1 && pos == 1
                Adj = -653;
            elseif acrossUp == 2 && pos ==1
                Adj = -326;
            end
            if acrossUp ==1
                Events = newevent_show_stimulus(Events,2,1,locx+Adj,locy,startTime,'screenshot_no','clear_yes');
            else
                Events = newevent_show_stimulus(Events,2,1,locx,locy+Adj,startTime,'screenshot_no','clear_yes');
            end
            resp = CreateResponseStruct;
            resp.spatialwindows = {[500,500,9999999]};
            Events = newevent_mouse(Events,startTime,resp);
            startTime = startTime+.01;
            for vertHorz = 1:2
                for lineCon =  1:7
                    startlocx = 1;
                    startlocy = 1;
                    Events = newevent_show_stimulus(Events,1,1,startlocx,startlocy,startTime,'screenshot_no','clear_yes');
                    if vertHorz == 1
                        numsects = 192;
                        lineset = 1;
                    else
                        numsects = 108;
                        lineset = 3;
                    end
                    for sect = 1:numsects
                        if sect ==1
                        Events = newevent_show_stimulus(Events,4,1,1,1,startTime,'screenshot_no','clear_yes');
                        end
                        for line = 1:10                
                            if lineCon == 1 % 100%
                                Events = newevent_show_stimulus(Events,lineset,1,startlocx,startlocy,startTime,'screenshot_no','clear_no');
                            elseif lineCon == 2% 90%
                                if line <=9
                                    Events = newevent_show_stimulus(Events,lineset,1,startlocx,startlocy,startTime,'screenshot_no','clear_no');
                                end
                            elseif lineCon == 3 % 80%
                                if line <=8
                                    Events = newevent_show_stimulus(Events,lineset,1,startlocx,startlocy,startTime,'screenshot_no','clear_no');
                                end
                            elseif lineCon == 4 % 50%
                                if line <=5
                                    Events = newevent_show_stimulus(Events,lineset,1,startlocx,startlocy,startTime,'screenshot_no','clear_no');
                                end
                            elseif lineCon == 5 % 20%
                                if line <=2
                                    Events = newevent_show_stimulus(Events,lineset,1,startlocx,startlocy,startTime,'screenshot_no','clear_no');
                                end
                            elseif lineCon == 6 % 10%
                                if line <= 1
                                    Events = newevent_show_stimulus(Events,lineset,1,startlocx,startlocy,startTime,'screenshot_no','clear_no');
                                end
                            elseif lineCon == 7 % 0%

                            end
                            if vertHorz == 1
                            startlocx = startlocx+1;
                            else
                               startlocy = startlocy+1;
                            end
                        end
                    end
                    resp = CreateResponseStruct;
                    resp.spatialwindows = {[500,500,9999999]};
                    Events = newevent_mouse(Events,startTime,resp);
                    startTime = startTime+.01;
                end
            end
            if acrossUp ==1
                Adj=Adj+326;
            else
                Adj = Adj +163;
            end
        end
    end
    %show correct answers
    blankTime = startTime+.04;
    Events = newevent_blank(Events,blankTime);
    
    %create an event to end the trial.
    endTime = blankTime+.01;
    Events = newevent_end_trial(Events,endTime);
    
    
    
elseif strcmp(Modeflag,'EndTrial' );
    
elseif strcmp(Modeflag,'EndBlock');
    
    
    
else   %something went wrong in runblock (you should never see this error)
    error('Invalid modeflag');
end
saveblockspace
end