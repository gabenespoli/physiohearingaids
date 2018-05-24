function ec_plot(varargin)

% defaults for getting data
sChan='scl';
whichfiles='all';
feature='mean';
threshold=0;
% **there are other options that can only be set from ec_getdata.m

% defaults for plotting
plottype='emotionbar';
do_legend=1;
plotfilt=[0 2];
do_anova=0;

% user-defined
if nargin>0
    for i=1:length(varargin)
        switch class(varargin{i})
            case 'char'
                if ismember(varargin{i},{'zyg','cor','rsp','gsr','scl','ppg','hr'})
                    sChan=varargin{i};
                    
                elseif ismember(varargin{i},{'all','test','test2','allinboth'})
                    whichfiles=varargin{i};
                    
                elseif ismember(varargin{i},{'mean','max','latency','peak2rms','rms'})
                    feature=varargin{i};
                    
                elseif ismember(varargin{i},{'group','emotion','emotionbar','bar'})
                    plottype=varargin{i};
                    
                elseif ismember(varargin{i},{'legend'})
                    do_legend=1;                    
                    
                end
                
            otherwise
                threshold=varargin{i};
        end
    end
end

% constants
Fs=1000;

happylinespec='b';
sadlinespec='r--';
angrylinespec='r';
calmlinespec='b--';
NHlinespec='b';
HAlinespec='g';
HIlinespec='r';

% parse ID input
% if iscell(id) && length(id)==1, id=id{1}; end
% [datafiles,id]=ec_datafiles(whichfiles,'processed');

% parse CHAN input
if ischar(sChan)
    switch lower(sChan)
        case 'zyg',         plottitle='ZYG (''smiling'')';  ytitle='EMG: Zyg/Smiling (mV)';
        case 'cor',         plottitle='COR (''frowning'')'; ytitle='EMG: Cor/Brow (mV)';
        case 'rsp',         plottitle='Respiration Rate';   ytitle='Rate';
        case {'gsr','scl'}, plottitle='Skin Conductance';   ytitle='SCL (microsiemens)';
        case {'ppg','hr'},  plottitle='Heart Rate';         ytitle='Rate';
    end
end

% GET DATA
% --------
[alldata,allfeatures,emotions,~,g,t]=ec_getdata(whichfiles,sChan,feature,threshold);

% ACTUAL PLOTTING
% ---------------
switch plottype
    
    
    case 'emotionbar' % emotions on separate plots, groups are lines, bar graphs beside
        % ----------  % 2 x 4
        figure('units','normalized','outerposition',[0 0 1 1])
        
        % line graphs
        for i=1:4
            subplot(2,4,i*2-1)
            
            NHplot=nanmean(alldata{i}(:,g.NH),2);
            HIplot=nanmean(alldata{i}(:,g.HI),2);
            HAplot=nanmean(alldata{i}(:,g.HA),2);
            
            if plotfilt(1)~=0 || plotfilt(2)~=0
                NHplot=butterfilter(NHplot,Fs,plotfilt);
                HIplot=butterfilter(HIplot,Fs,plotfilt);
                HAplot=butterfilter(HAplot,Fs,plotfilt);
            end
            
            plot(t,NHplot,NHlinespec,...
                t,HIplot,HIlinespec,...
                t,HAplot,HAlinespec)
            title(emotions{i})
            ylabel(ytitle)
            xlabel('Time (s)')
            set(gca,'fontsize',14)
            fitx
        end
        
        % set y-axis limits the same for all plots
        yl=nan(4,2);
        for i=1:4, subplot(2,4,i*2-1), yl(i,:)=ylim; end % get y axis limits
        for i=1:4, subplot(2,4,i*2-1),ylim([min(yl(:,1)) max(yl(:,2))]), end
        
        % create bar to indicate target region
        for i=1:4
            subplot(2,4,i*2-1)
            yl=ylim;
            line([0 3.5],[yl(1) yl(1)],'color','k','linewidth',3.5)            
        end
        
        % bar graphs
        for i=1:4
            subplot(2,4,i*2)
            f=allfeatures{i};
            bar([1 2 3],[mean(f(g.NH)) 0 0],'facecolor',NHlinespec);
            hold on
            bar([1 2 3],[0 mean(f(g.HI)) 0],'facecolor',HIlinespec);
            bar([1 2 3],[0 0 mean(f(g.HA))],'facecolor',HAlinespec);
            errorbar([1 2 3],[mean(f(g.NH)) mean(f(g.HI)) mean(f(g.HA))],...
                [ste(f(g.NH)) ste(f(g.HI)) ste(f(g.HA))],'.k')
            set(gca,'xticklabel',{'Normal','Impaired','Aided'})
            title(getfeaturetitle(feature))
        end
        
        % set y-axis limits the same for all plots
        yl=nan(4,2);
        for i=1:4, subplot(2,4,i*2), yl(i,:)=ylim; end % get y axis limits
        for i=1:4, subplot(2,4,i*2),ylim([min(yl(:,1)) max(yl(:,2))]), end
        
        
    case 'bar' % 2 x 2 emotions on separate plots, features only
        % ---
        figure('units','normalized','outerposition',[0 0 1 1])
        
         for i=1:4
            subplot(2,2,i)
            f=allfeatures{i};
            bar([1 2 3],[mean(f(g.NH)) 0 0],'facecolor',NHlinespec);
            hold on
            bar([1 2 3],[0 mean(f(g.HI)) 0],'facecolor',HIlinespec);
            bar([1 2 3],[0 0 mean(f(g.HA))],'facecolor',HAlinespec);
            errorbar([1 2 3],[mean(f(g.NH)) mean(f(g.HI)) mean(f(g.HA))],...
                [ste(f(g.NH)) ste(f(g.HI)) ste(f(g.HA))],'.k')
            set(gca,'xticklabel',{'Normal','Impaired','Aided'})
            title([getfeaturetitle(feature), ' for ',emotions{i}])
            ylabel(ytitle)
            
            if do_anova
                g1={'NH';'NH';'NH';'HA';'HI';'HA';'HI';'HA';'HI';'HA';'HI';'HA';'HI';'NH'};
                str{i}=anovap(f,{g1});
            end
        end
        
        % set y-axis limits the same for all plots
        yl=nan(4,2);
        for i=1:4, subplot(2,2,i), yl(i,:)=ylim; end % get y axis limits
        for i=1:4
            subplot(2,2,i)
            ylim([min(yl(:,1)) max(yl(:,2))])
            set(gca,'fontsize',14)

            if do_anova % add anova string
                range=max(yl(:,2))-min(yl(:,1));
                text(1,min(yl(:,1))+0.05*range,str{i},'fontsize',14)
            end 
        end
        
        
       
        
    case 'emotion' % emotions on separate plots, groups are lines
        % -------
        
        % line graphs
        for i=1:4
            subplot(2,2,i)
            
            NHplot=nanmean(alldata{i}(:,g.NH),2);
            HIplot=nanmean(alldata{i}(:,g.HI),2);
            HAplot=nanmean(alldata{i}(:,g.HA),2);
            
            if plotfilt(1)~=0 || plotfilt(2)~=0
                NHplot=butterfilter(NHplot,Fs,plotfilt);
                HIplot=butterfilter(HIplot,Fs,plotfilt);
                HAplot=butterfilter(HAplot,Fs,plotfilt);
            end
            
            plot(t,NHplot,NHlinespec,...
                t,HIplot,HIlinespec,...
                t,HAplot,HAlinespec)
            title(emotions{i})
            ylabel(ytitle)
            xlabel('Time (s)')
            set(gca,'fontsize',14)
            fitx
        end
        
        % set y-axis limits the same for all plots
        yl=nan(4,2);
        for i=1:4, subplot(2,2,i), yl(i,:)=ylim; end % get y axis limits
        for i=1:4, subplot(2,2,i),ylim([min(yl(:,1)) max(yl(:,2))]), end
        
        % create bar to indicate target region
        for i=1:4
            subplot(2,2,i)
            yl=ylim;
            line([0 3.5],[yl(1) yl(1)],'color','k','linewidth',3.5)            
        end
        
    case 'group' % groups on separate plots, emotions are lines
        % -----
        
        [angrydata,happydata,saddata,calmdata]=split_alldata(alldata);
        
        allgroups=unique(g.group);
        switch length(allgroups)
            case 1
                switch allgroups{1}
                    case 'normal',  select=g.NH; plottitle=[plottitle,' - Normal Hearing'];
                    case 'aided',   select=g.HA; plottitle=[plottitle,' - Aided'];
                    case 'unaided', select=g.HI; plottitle=[plottitle,' - Impaired'];
                end
                
                plot(t,mean(happydata(:,select),2),happylinespec,...
                    t,mean(calmdata(:,select),2),calmlinespec,...
                    t,mean(angrydata(:,select),2),angrylinespec,...
                    t,mean(saddata(:,select),2),sadlinespec)
                if do_legend, legend({'happy','calm','angry','sad'},'Location','NorthWest'), end
                set(gca,'fontsize',16)
                title(plottitle)
                ylabel(ytitle)
                
            case 2
                
            case 3
                figure('units','normalized','outerposition',[0 0 1 1])
                
                subplot(311)
                plot(t,mean(happydata(:,g.NH),2),happylinespec,...
                    t,mean(calmdata(:,g.NH),2),calmlinespec,...
                    t,mean(angrydata(:,g.NH),2),angrylinespec,...
                    t,mean(saddata(:,g.NH),2),sadlinespec)
                legend({'happy','calm','angry','sad'},'Location','NorthWest')
                title(['Normal Hearing (n=',num2str(length(g.NH)),')'])
                
                subplot(312)
                plot(t,mean(happydata(:,g.HI),2),happylinespec,...
                    t,mean(calmdata(:,g.HI),2),calmlinespec,...
                    t,mean(angrydata(:,g.HI),2),angrylinespec,...
                    t,mean(saddata(:,g.HI),2),sadlinespec)
                title(['Impaired (n=',num2str(length(g.HI)),')'])
                
                subplot(313)
                plot(t,mean(happydata(:,g.HA),2),happylinespec,...
                    t,mean(calmdata(:,g.HA),2),calmlinespec,...
                    t,mean(angrydata(:,g.HA),2),angrylinespec,...
                    t,mean(saddata(:,g.HA),2),sadlinespec)
                title(['Aided (n=',num2str(length(g.HA)),')'])
                xlabel('Time (s)')
                
                % set parameters for all plots
                yl=nan(3,2);
                for i=1:3, subplot(3,1,i), yl(i,:)=ylim; end % get y limits for all plots
                yl=[min(yl(:,1)) max(yl(:,2))];
                for i=1:3, subplot(3,1,i) % apply same y limits to all plots
                    ylim(yl)
                    set(gca,'fontsize',16)
                    ylabel(ytitle)
                    line([0 3.5],[yl(1) yl(1)],'color','k','linewidth',3.5) % line to indicate target region
                end
                     
        end 
end




end

function [angrydata,happydata,saddata,calmdata]=split_alldata(alldata)
angrydata=alldata{1};
happydata=alldata{2};
saddata=alldata{3};
calmdata=alldata{4};
end

function plottitle=getfeaturetitle(feature)
    switch feature
        case 'mean',        plottitle='Average Response';
        case 'max',         plottitle='Max Response';
        case 'latency',     plottitle='Latency of Max Response (s)';
        case 'peak2rms',    plottitle='Ratio of Peak to RMS';
        case 'rms',         plottitle='RMS';
            
    end
end