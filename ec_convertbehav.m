function ec_convertbehav

folderin=fullfile('~','local','ec','data','raw_behav');
folderout=fullfile('~','local','ec','data','behav');
stimfolder = fullfile('~','local','ec','stimuli');
id=ec_datafiles;

for p=1:length(id)
    fprintf('%i/%i: %s\n', p, length(id), id{p})

    clear nResp respTime sResp stimFiles stimOrder
    clear resp RT respString stimInfo answerString answer
    clear happy sad angry calm ACC

    load(fullfile(folderin,[id{p},'.mat']))
    stimulusSet = id{p}(end);
    if strcmp(stimulusSet, '1'), stimulusSet = ''; end

    resp=[nResp(:,1);nResp(:,2)];
    RT=[respTime(:,1);respTime(:,2)];
    respString=[sResp(:,1);sResp(:,2)];
    stimFiles=[stimFiles(:,1);stimFiles(:,2)];
    stimOrder=[stimOrder(:,1);stimOrder(:,2)];
    
    stimFiles = stimFiles(stimOrder);
    RAVDESSfilenames = strcat(stimfolder, stimulusSet, '/', stimFiles);
    stimInfo=getRAVDESSinfo(RAVDESSfilenames, false);
    % stimInfo=stimInfo(stimOrder,:);
    answerString=stimInfo{:,'emotion'};

    happy=find(strcmp(answerString,'happy'));
    sad=find(strcmp(answerString,'sad'));
    angry=find(strcmp(answerString,'angry'));
    calm=find(strcmp(answerString,'calm'));

    answer(happy)=1; %#ok<AGROW>
    answer(sad)=2; %#ok<AGROW>
    answer(angry)=3; %#ok<AGROW>
    answer(calm)=4; %#ok<AGROW>
    answer=answer';

    for i=1:length(resp)
        if answer(i)==resp(i)
            ACC(i)=1; %#ok<AGROW>
        else 
            ACC(i)=0; %#ok<AGROW>
        end
    end
    ACC=ACC';

    % all vars that are saved should be in the correct order
    % so we won't save stimOrder so that we don't get confused later
    save(fullfile(folderout,[id{p},'.mat']),'resp','respString','answer',...
        'answerString','RT','ACC','happy','sad','angry','calm',...
        'stimFiles')
    
end
