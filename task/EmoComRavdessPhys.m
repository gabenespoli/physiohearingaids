function EmoComRavdessPhys

% settings
% --------

% specify stimulus folders
session=input('Which stimulus set? [1=NH/HI, 2=HA] >> ','s');

switch session
    case '1', stimFolders={'stimuli' 'stimuli'};   % stimuli=NH/HI
    case '2', stimFolders={'stimuli2' 'stimuli2'}; % stimuli2=HA
    otherwise, error('Invalid stimulus set.')
end

% specify valid responses
validResponses=[4 22 7 9 39 20 26 8 21];

% a=4   s=22    d=7     f=9     zero=39
% q=20  w=26    e=8     r=21   


% prepare
% -------

% add psychtoolbox to path
addpath(genpath('/Applications/Psychtoolbox'))

% clear command window
clc
commandwindow

% prompt for participant number
[logfilename,stimFiles,stimOrder,nResp,sResp,respTime]=promptParticipantNumber(stimFolders,session);
clc

% prompt to begin experiment
fprintf('\tEmotion Identification\n')
fprintf('\t----------------------\n')
fprintf('\tOn each trial you will hear an audio clip of someone speaking a sentence in a emotional way.\n')
fprintf('\tIndicate which emotion was being expressed using the keyboard:\n')
    fprintf('\n')
    fprintf('\tWhich emotion was expressed?\n')
    fprintf('\n')
    fprintf('\tHappy   Sad   Angry   Calm\n')
    fprintf('\t  A      S      D      F\n')
    fprintf('\n')
% fprintf('\tThe expressed emotions will be either happy (''A''), sad (''S''), angry (''D''), or calm (''F'').\n')
fprintf('\tPlease listen to the entire sentence before responding.\n')

% wait for keyboard press to continue
fprintf('\tPress the spacebar to begin.\n')
WaitSecs(0.2);
[~,key]=KbWait;
if find(key==1)==39, stopProgram, return, end % zero key (0)

% turn off mouse cursor and keyboard output
HideCursor; % hide mouse cursor
% ListenChar(2); % suppress keyboard output to MATLAB command window


% begin experiment
% ----------------

try
    % find first trial without a response
    startTrial=[];
    startBlock=0;
    while isempty(startTrial)
        startBlock=startBlock+1;
        startTrial=find(nResp(:,startBlock)==0,1,'first');
    end

    % check that starting trial exists
    if startBlock>length(stimFolders), error('Couldn''t find starting trial'), end
     
    % loop blocks
    % -----------
    for block=startBlock:length(stimFolders)
        clc
        
        % find first trial without a response in current block
        startTrial=find(nResp(:,block)==0,1,'first');

        % prompt to begin block
        if startTrial==1
            fprintf(['\tBeginning Block ',num2str(block),'/',num2str(length(stimFolders)),'\n'])
             fprintf('\t-------------------\n')
        else
            fprintf(['\tContinuing Block ',num2str(block),'/',num2str(length(stimFolders)),'\n'])
             fprintf('\t--------------------\n')            
        end
        
        fprintf('\n')
        fprintf('\tPress the spacebar to continue.\n')
        WaitSecs(0.2);
        [~,key]=KbWait;
        if find(key==1)==39, stopProgram, return, end
        
        % loop trials
        % -----------
        for i=startTrial:length(stimFiles)
            clc
            
            % prepare valid response flag
            validResp=0;

            % count down to next trial
            fprintf(['\tBlock ',num2str(block),'/',num2str(size(stimFiles,2)),' - Trial ',num2str(i),'/',num2str(length(stimFiles)),'\n'])
            fprintf('\n')
            fprintf('\tPress the spacebar to continue.\n')
            WaitSecs(0.2);
            [~,key]=KbWait;
            if find(key==1)==39, stopProgram, return, end

            % variable inter-trial-interval - pause for 5-6 seconds
            fprintf('\n')
            fprintf('\tTrial will begin in a moment...\n')
            pause(5+((6-5)*rand))
            
            % load and play stimulus file
            fprintf('\n')
            fprintf('\tSentence playing...\n')

            [y,Fs]=audioread(fullfile(stimFolders{block},stimFiles{stimOrder(i,block),block}));

            stim=audioplayer(y,Fs);
            playblocking(stim)
            
            % loop until valid response received
            while validResp==0

                % response prompt
                fprintf('\n')
                fprintf('\tWhich emotion was expressed?\n')
                fprintf('\n')
                fprintf('\tHappy   Sad   Angry   Calm\n')
                fprintf('\t  A      S      D      F\n')
                fprintf('\n')
                
                % start RT timer
                timeOn=GetSecs;
                
                % get response
                [~,resp]=KbWait([],3);
                
                % determine which key was pressed
                resp=find(resp==1);
                
                % check if response is valid
                if ismember(resp,validResponses)
                    validResp=1;
                else
                    fprintf('Oops! We missed your response. Can you enter it again?\n')
                end

            end

            % get response time
            respTime(i,block)=GetSecs-timeOn;

            % interpret response
            switch resp
                case {4 20},    resp=1;     respStr='happy';
                case {22 26},   resp=2;     respStr='sad';
                case {7 8},     resp=3;     respStr='angry';
                case {9 21},    resp=4;     respStr='calm';
                case {39},
                    stopProgram
                    return
            end

            % log response
            nResp(i,block)=resp;
            sResp{i,block}=respStr;

            % save response (filename, response, response time)
            save(logfilename,'stimFiles','stimOrder','nResp','sResp','respTime')

        end
    end

    % end program
    clc
    stopProgram
    fprintf('\n')
    
    % remove psychtoolbox from path
    rmpath(genpath('/Applications/Psychtoolbox'))
    
    fprintf('\tExperiment complete!\n')
    
catch err
    stopProgram
    rethrow(err)
end
end

function stopProgram
fprintf('\n\tExiting program...\n')
ShowCursor; % display mouse cursor
% ListenChar(0); % enable keyboard
end
