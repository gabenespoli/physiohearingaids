function [logfilename,stimFiles,stimOrder,nResp,sResp]=promptParticipantNumber

promptAgain=1;
createNewLogfile=0;

while promptAgain

    % enter participant number
    p=input('Enter participant number: ');

    try load(['logfiles/',num2str(p),'.mat'])
        resp=input('Logfile exists, overwrite? [y/n/c/x]: ','s'); 
    catch     
        resp=input('Logfile doesn''t exist, create new? [y/n/x]: ','s');
    end
    
    % interpret input
    switch lower(resp)
        case 'y'
            promptAgain=0;
            createNewLogfile=1;
        case 'c'
            promptAgain=0;
            createNewLogfile=0;
        case 'x'
            disp('Exiting script...')
            return    
        otherwise
            promptAgain=1;
    end
end

logfilename=['logfiles/',num2str(p),'.mat'];

% create new logfile with given participant number
if createNewLogfile, disp(['Creating new logfile ',num2str(p),'.mat...'])
    
    stimFiles=getStimFiles({'stimuli','stimuli2'});
    
    for i=1:size(stimFiles,2)
        stimOrder(:,i)=randperm(length(stimFiles))';
        nResp(:,i)=zeros(length(stimFiles),1);
        sResp(:,i)=cell(length(stimFiles),1);
    end
    
    
else disp(['Loading existing logfile ',num2str(p),'.mat...'])
    
    load(['logfiles/',num2str(p),'.mat'])
end