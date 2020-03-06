function [Events Parameters Stimuli_sets Block_Export Trial_Export  Numtrials]=Demo(Parameters, Stimuli_sets, Trial, Blocknum, Modeflag, Events,Block_Export,Trial_Export,Demodata,fulldata)
load('blockvars')

Parameters.extratimeallowance = .015;
updateRate = .02;
if strcmp(Modeflag,'InitializeBlock')
    clear Stimuli_sets
    
    stimstruct = CreateStimStruct('shape');
    stimstruct.xdim = [10];
    stimstruct.ydim = [10];
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
    stimstruct.xdim = [54,109,218];
    stimstruct.ydim = [54,109,218];
    stimstruct.linewidth = 50;
    stimstruct.color = [0,0,0];
    stimstruct.stimuli{1} = 'FillOval';
    stimstruct.stimuli{2} = 'FillOval';
    stimstruct.stimuli{3} = 'FillOval';
    Stimuli_sets(3) = Preparestimuli(Parameters,stimstruct);
    
    stimstruct = CreateStimStruct('shape');
    stimstruct.xdim = [54,109,218];
    stimstruct.ydim = [54,109,218];
    stimstruct.linewidth = 50;
    stimstruct.color = [255,255,255];
    stimstruct.stimuli{1} = 'FillOval';
    stimstruct.stimuli{2} = 'FillOval';
    stimstruct.stimuli{3} = 'FillOval';
    Stimuli_sets(4) = Preparestimuli(Parameters,stimstruct);
    
    stimstruct = CreateStimStruct('shape');
    stimstruct.xdim = [100000];
    stimstruct.ydim = [10];
    stimstruct.color = [0,0,0];
    stimstruct.stimuli{1} = 'FillRect';
    Stimuli_sets(5) = Preparestimuli(Parameters,stimstruct);
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
    dim =10;
    for checkersCon = 1%:7
        Events = newevent_show_stimulus(Events,2,1,locx,locy,startTime,'screenshot_no','clear_yes');
        resp = CreateResponseStruct;
        resp.spatialwindows = {[500,500,9999999]};
        Events = newevent_mouse(Events,startTime,resp);
        startTime = startTime+.01;
        for blackWhite =1:2
            for size=1:3
                for rowChunk =1:96
                    adj = (rowChunk-1)*20;
                    %1
                    Events = newevent_show_stimulus(Events,5,1,1,0+adj,startTime,'screenshot_no','clear_no');
                    Events = newevent_show_stimulus(Events,1,1,1,0+adj,startTime,'screenshot_no','clear_no');
                    for i = 1:95
                    Events = newevent_show_stimulus(Events,1,1,round(192*(i/96))*dim,0+adj,startTime,'screenshot_no','clear_no');
                    end
                    %2
                    Events = newevent_show_stimulus(Events,5,1,1,10+adj,startTime,'screenshot_no','clear_no');
                    for i = 1:2:191
                    Events = newevent_show_stimulus(Events,1,1,round(192*(i/192))*dim,10+adj,startTime,'screenshot_no','clear_no');
                    end
                end
                if blackWhite==1
                    Events = newevent_show_stimulus(Events,3,size,locx,locy,startTime,'screenshot_no','clear_no');
                else
                    Events = newevent_show_stimulus(Events,4,size,locx,locy,startTime,'screenshot_no','clear_no');
                end
                
                resp = CreateResponseStruct;
                resp.spatialwindows = {[500,500,9999999]};
                Events = newevent_mouse(Events,startTime,resp);
                startTime = startTime+.01;
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