function [Events Parameters Stimuli_sets Block_Export Trial_Export  Numtrials]=Demo(Parameters, Stimuli_sets, Trial, Blocknum, Modeflag, Events,Block_Export,Trial_Export,Demodata,fulldata)
load('blockvars')

Parameters.extratimeallowance = .015;
updateRate = .02;
if strcmp(Modeflag,'InitializeBlock')
    clear Stimuli_sets
    
    stimstruct = CreateStimStruct('shape');
    stimstruct.xdim = [54,109,218];
    stimstruct.ydim = [54,109,218];
    stimstruct.linewidth = 50;
    stimstruct.color = [255,255,255];
    for i = 1:3
        stimstruct.stimuli{i} = 'FillOval';
    end
    Stimuli_sets(1) = Preparestimuli(Parameters,stimstruct);
    
        stimstruct = CreateStimStruct('shape');
    stimstruct.xdim = [54,109,218];
    stimstruct.ydim = [54,109,218];
    stimstruct.linewidth = 50;
    stimstruct.color = [0,0,0];
    for i = 1:3
        stimstruct.stimuli{i} = 'FillOval';
    end
    Stimuli_sets(2) = Preparestimuli(Parameters,stimstruct);
    
    stimstruct = CreateStimStruct('shape');
    stimstruct.xdim = [10000,10000];
    stimstruct.ydim = [10000,10000];
    stimstruct.linewidth = 50;
    stimstruct.color = [0,0,0;255,255,255];
    for i = 1:2
        stimstruct.stimuli{i} = 'FillRect';
    end
    Stimuli_sets(3) = Preparestimuli(Parameters,stimstruct);
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
    Adj = -653;
    startTime = .02;
    for acrossUp = 1:2
        for place = 1:5
            if acrossUp == 1 && place == 1
                Adj = -653;
            elseif acrossUp == 2 && place ==1
                Adj = -326;
            end
            for background =1:2
                Events = newevent_show_stimulus(Events,3,background,locx+Adj,locy,startTime,'screenshot_no','clear_yes');
            for circle =  1:3
                if acrossUp ==1
                    Events = newevent_show_stimulus(Events,background,circle,locx+Adj,locy,startTime,'screenshot_no','clear_no');
                else
                    Events = newevent_show_stimulus(Events,background,circle,locx,locy+Adj,startTime,'screenshot_no','clear_no');
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