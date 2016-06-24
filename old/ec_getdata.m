function [alldata,allfeatures,emotions,id,g,t]=ec_getdata(varargin)

% defaults
sChan='scl';
whichfiles='all';
feature='mean';
threshold=0;

% these cannot be set from ec_plot
do_filter=[0 0.4];
do_baseline=1;

% user-defined
if nargin>0
    for i=1:length(varargin)
        switch class(varargin{i})
            case 'char'
                if ismember(varargin{i},{'zyg','cor','rsp','gsr','scl','ppg','hr'})
                    sChan=varargin{i};
                    
                elseif ismember(varargin{i},{'all','test','test2','allinboth','allinboth-between','allinboth-within'})
                    whichfiles=varargin{i};
                    
                elseif ismember(varargin{i},{'mean','max','latency','peak2rms','rms'})
                    feature=varargin{i};
                
                else warning(['Input argument ',varargin{i},' not recognized.']);
                end
                
            otherwise
                threshold=varargin{i};
        end
    end
end

% constants
Fs=1000;
win=0; % RMS smoothing window for EMG data (in ms), 0 == abs() instead

% counters
numArtifacts=0;
numTrials=0;

% parse ID input
% if iscell(id) && length(id)==1, id=id{1}; end
% if ismember(id,{'all','test','test2'})
    [datafiles,id]=ec_datafiles(whichfiles,'processed');
% end
g=ec_group(id);

% parse CHAN input
if ischar(sChan)
    switch lower(sChan)
        case 'zyg',         chan=1;
        case 'cor',         chan=2;
        case 'rsp',         chan=3;
        case {'gsr','scl'}, chan=4;
        case {'ppg','hr'},  chan=5;
    end
end

% loop participants and average data
for p=1:length(id)
    
    % load data, create time vector, discard data from other channels
    load(datafiles{p})
    t=-1:1/Fs:((size(data,1)-1)/Fs)-1;
    data=data(:,:,chan); % DATA is now TIME x TRIALS
    target=target(1:end-1000);
    
    % EMG data: restrict to target region only
%     if chan==1 || chan==2
%         disp('Adjusting target region for EMG data...')
%         % only deal with target region
%         data=data([baseline,target],:);
%         t=t([baseline,target]);
%     end
    
    % get indices of artifacts
    if threshold
        [~,locs]=reject_artifacts(data,threshold,'verboseon');
        
        numArtifacts=numArtifacts+length(locs);
        numTrials=numTrials+size(data,2);
        
        rmhappy=[]; rmsad=[]; rmangry=[]; rmcalm=[];
        for i=1:length(happy)
            if ismember(happy(i),locs), rmhappy=[rmhappy i]; end
            if ismember(sad(i),locs),   rmsad=[rmsad i]; end
            if ismember(angry(i),locs), rmangry=[rmangry i]; end
            if ismember(calm(i),locs),  rmcalm=[rmcalm i]; end
        end
        happy(rmhappy)=[]; sad(rmsad)=[]; angry(rmangry)=[]; calm(rmcalm)=[];
        
    end
    

    % EMG data: RMS smoothing (rectification)
    if chan==1 || chan==2
        if win>0
            disp('RMS smoothing EMG data...')
            win=round(win/1000*Fs);
            data=RMS50(data,win);
            %             data=RMSfilter(data,win);
            
            % adjust lengths of other vectors to account for RMS
            rm1=ceil(win/2);
            rm2=floor(win/2)+1;
            t=t(rm1:end-rm2);
            baseline=baseline(1:end-rm1);
            target=target(1)-rm1:target(end)-rm1-rm1;
            
        elseif win==0
            disp('Full wave rectification to EMG data (abs)...')
            data=abs(data);
        end
    end
    
    % extra filtering
    if do_filter(1)~=0 || do_filter(2)~=0
        disp('Filtering data...')
        data=butterfilter(data,Fs,do_filter);
    end    
    
    % baseline correction
    if do_baseline
        for i=1:size(data,2)
            data(:,i)=data(:,i)-mean(data(baseline,i),1);
            %         data(:,i)=data(:,i)-mean(data(1:0.8*Fs,i),1);
        end
    end
    
    % split into emotions, average data trials for plots, add to containers
    % (have to split here because each participant has a different order)
    happydata(:,p)=mean(data(:,happy),2);
    saddata(:,p)=mean(data(:,sad),2);
    angrydata(:,p)=mean(data(:,angry),2);
    calmdata(:,p)=mean(data(:,calm),2);
    
    % get features
    if chan==1 || chan==2, target_temp=target; else target_temp=[]; end
    [happyfeatures(:,p),happyste(:,p)]=ec_getfeature(data(:,happy),[],feature,Fs,target_temp);
    [sadfeatures(:,p),sadste(:,p)]=ec_getfeature(data(:,sad),[],feature,Fs,target_temp);
    [angryfeatures(:,p),angryste(:,p)]=ec_getfeature(data(:,angry),[],feature,Fs,target_temp);
    [calmfeatures(:,p),calmste(:,p)]=ec_getfeature(data(:,calm),[],feature,Fs,target_temp);
end % end looping participants


if threshold
    disp(['Removed ',num2str(numArtifacts),' / ',num2str(numTrials),...
        ' trials with values above ',num2str(threshold),...
        '. ',num2str(numTrials-numArtifacts),' trials remain.'])
end

% ** don't change order of emotions (angry, happy, sad, calm) because
% ec_plot takes all data and splits it back up based on this order
alldata={angrydata,happydata,saddata,calmdata}; % arranged in plotting order
allfeatures={angryfeatures,happyfeatures,sadfeatures,calmfeatures};
emotions={'Angry','Happy','Sad','Calm'};

end

function [f,sterr,plottitle]=ec_getfeature(data,locs,operation,varargin)

% locs = cell array of vectors of indices of groups
% operation = 'mean'|'max'|'latency'|'peak2rms'|'rms'

% defaults
Fs=[];
target=[];

% user-defined
if nargin>3
    for i=1:length(varargin)
        switch class(varargin{i})
            case {'single','double'}
                switch length(varargin{i})
                    case 1, Fs=varargin{i};
                    otherwise, target=varargin{i};
                end
        end
    end
end

if isempty(locs), locs={1:size(data,2)}; end
if isempty(target), target=1:size(data,1); end
f=nan(1,length(locs));
sterr=nan(1,length(locs));

for i=1:length(locs)
    switch operation
        case 'mean'
            val=nanmean(data(target,locs{i}));
            plottitle='Average Response';
            
        case 'max'
            val=max(data(target,locs{i}));
            plottitle='Max Response';
            
        case 'latency'
            [~,val]=max(data(target,locs{i}));
            val=val/Fs;
            plottitle='Latency of Max Response (s)';
            
        case 'peak2rms'
            val=peak2rms(data(target,locs{i}));
            plottitle='Ratio of Peak to RMS';
            
        case 'rms'
%             baseline=1:size(data,1);
%             baseline(target)=[];
%             val=rms(data(target,locs{i}))-rms(data(baseline,locs{i}));
            val=rms(data(target,locs{i}));
            plottitle='RMS';
            
    end
    f(i)=nanmean(val); % average across dim 2 of DATA (trials or participants)
    sterr(i)=ste(val); % get standard error of the mean

end
end