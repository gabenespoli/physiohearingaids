function ec_plot(data,stiminfo,chan,varargin)

% defaults
threshold=[];
do_legend=0;

% user-defined
if nargin>3
    for i=1:length(varargin)
        switch class(varargin{i})
            case 'char'
                if ismember(varargin{i},{'legend'})
                    do_legend=1;
                end
                
            otherwise
                threshold=varargin{i};
        end
    end
end


Fs=1000;
t=-1:1/Fs:((size(data,1)-1)/Fs)-1;

happy=find(strcmp(stiminfo(:,3),'happy')==1);
sad=find(strcmp(stiminfo(:,3),'sad')==1);
angry=find(strcmp(stiminfo(:,3),'angry')==1);
calm=find(strcmp(stiminfo(:,3),'calm')==1);

% adjustments for EMG data
if chan==1 || chan==2
    data=RMS50(data(:,:,chan),Fs);
    data=data(30:end-30,:);
    t=t(30:end-30);
    
else data=data(:,:,chan);
end

% split data into emotions
happydata=data(:,happy);
saddata=data(:,sad);
angrydata=data(:,angry);
calmdata=data(:,calm);

% reject artifacts
if threshold
    happydata=reject_artifacts(happydata,threshold);
    saddata=reject_artifacts(saddata,threshold);
    angrydata=reject_artifacts(angrydata,threshold);
    calmdata=reject_artifacts(calmdata,threshold);
end

% average data for plots
happydata=mean(happydata,2);
saddata=mean(saddata,2);
angrydata=mean(angrydata,2);
calmdata=mean(calmdata,2);

% plot data
plot(t,happydata,'b',t,calmdata,'c--',t,angrydata,'r',t,saddata,'m--')

if do_legend, legend({'happy','calm','angry','sad'},'Location','NorthWest'), end
set(gca,'fontsize',16)

switch chan
    case 1, title('EMG Zygomaticus (''smiling'')')
%         ylim([-2 3])
        ylabel('EMG (mV)')
    case 2, title('EMG Corrugator (''frowning'')')
%         ylim([-2 3])
        ylabel('EMG (mV)')
    case 3, title('Respiration Rate')
    case 4, title('Skin Conductance')
%         ylim([-0.05 0.15])
        ylabel('SCL (microsiemens)')
    case 5, title('Heart Rate')
end