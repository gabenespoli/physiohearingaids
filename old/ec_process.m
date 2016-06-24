function ec_process(varargin)
%EC_PROCESS  Emotional Communication & Physio Response Study.
%   converts split files into processed, ready-for-analysis files

% defaults
whichfiles='test2';

if nargin>1
    for i=1:length(varargin)
        switch class(varargin{i})
            case 'char'
                if ismember(varargin{i},{'all','test','test2'})
                    whichfiles=varargin{i};
                end
        end
    end
end

% specify files & folders
[physiofiles,id]=ec_datafiles('physio','split',whichfiles);
behavfiles=ec_datafiles('behav',whichfiles);
rawfiles=ec_datafiles('physio','raw',whichfiles);
outputfolder=getfolder('ec','data','/processed');

% specify other variables
Fs=1000;
baseline=1:1000;
target=1001:4500;

% loop participants
w=waitbar(0,'Processing EC data...','units','normalized','position',[0.35 0.6 0.3 0.1]);
for p=1:length(id)
    waitbar((p-1)/length(id),w,['Processing EC data ',...
        num2str(p),'/',num2str(length(id)),': ',id{p}])
%     disp(['Participant ',num2str(p),'/',num2str(length(id)),': ',id{p}])
    
    % physio data
    % -----------
    load(physiofiles{p})
    load(rawfiles{p},'units')
    
%     data=permute(data,[2 1 3]);
    labels=misc.channelLabels;
    t=-1:1/Fs:((size(data,1)-1)/Fs)-1;
    
    % baseline correction for zyg, cor, scl
%     rawdata=data;
%     for i=1:size(data,2)
%         for j=[1 2 4]
%             data(:,i,j)=data(:,i,j)-mean(data(baseline,i,j),1);
%         end
%     end
    

    
    % behavioural data
    % ----------------
    load(behavfiles{p})
    
    % make order numbers compatible with a single column
    if size(stimOrder,2)==2
        stimOrder(:,2)=stimOrder(:,2)+size(stimOrder,1);
    end
    
    % convert to single column vectors
    RT=makeOneCol(respTime);
    stimOrder=makeOneCol(stimOrder);
    rawStimFiles=makeOneCol(stimFiles);
    sResp=makeOneCol(sResp);
    
    % check number of trials
    switch size(data,2)
        case 64 % all is well
        case 32 % use only first block
            RT=RT(1:32);
            stimOrder=stimOrder(1:32);
            rawStimFiles=rawStimFiles(1:32);
            sResp=sResp(1:32);
        otherwise
            error(['Wrong number of trials for id ',id{p},'.'])
    end
        
        
    
    % get ordered list of stim files
    stimFiles=cell(size(rawStimFiles,1),1);
    for i=1:length(stimFiles)
        stimFiles{i}=rawStimFiles{stimOrder(i)};
    end
    
    % get indices of each emotion
    stiminfo=getRAVDESSinfo(stimFiles);
    happy=find(strcmp(stiminfo(:,3),'happy')==1);
    sad=find(strcmp(stiminfo(:,3),'sad')==1);
    angry=find(strcmp(stiminfo(:,3),'angry')==1);
    calm=find(strcmp(stiminfo(:,3),'calm')==1);
    
    % get accuracy
    acc=nan(size(rawStimFiles,1),1);
    for i=1:size(rawStimFiles,1)
        acc(i)=(strcmp(sResp{i},stiminfo{i,3}));
    end
    

filename=[outputfolder,id{p},'.mat'];
save(filename,'data','labels','units',...
    'stimFiles','happy','sad','angry','calm','stiminfo','RT','acc',...
    'Fs','t','target','baseline','filename')
end
close(w)
end % end ec_process.m

function y=makeOneCol(x)
if size(x,2)==1
    y=x;
    return
end % this var is already one column
y=x';
y=reshape(y.',[],1);
end
    