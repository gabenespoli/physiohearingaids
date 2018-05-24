function stimFiles=getStimFiles(folders)

stimFiles={};

% loop through folders
for f=1:length(folders)
    
    allStimFiles=dir(folders{f});
    temp={};

    % loop through files in stimulus dir
    for i=1:length(allStimFiles)

        % get file extension
        [~,~,ext]=fileparts(allStimFiles(i).name);

        % if file is wav, add to list
        if strcmp(ext,'.wav')
            temp{end+1}=allStimFiles(i).name;    
        end
    end
    
    if f==1, stimFiles=temp';
    else stimFiles=[stimFiles temp'];
    end
end