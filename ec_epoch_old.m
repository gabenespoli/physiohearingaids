function numEpochs = ec_epoch_old(participant,session,varargin)
% Caller function for AudioEpoch for EmoCom Physio study.

% errors:
% 1-1, thresh 0.1 found 55 markers, removed 11th marker, 54 markers remain
% 2-1, thresh 0.1 found 66 markers, removed 1st and 2nd, 64 remain
% 7-1, thresh 0.1 found 22 23 24
% 9-2, remove 1st
% 10-1 remove 28th

% 12-2, 65 markers, looks like there are really only 62 good ones though


% file I/O
filename = [num2str(participant),'-',num2str(session)];
inputfolder = gf('data','ec','raw');
outputfolder = gf('data','ec','split');
inputfile = fullfile(inputfolder,[filename,'.mat']);
outputfile = fullfile(outputfolder,[filename,'.mat']);

% fill params fields with study defaults
params.audioInd = 6;
params.Fs = 1000;
params.threshold = 0.1;
params.markerBetween = 1 * params.Fs;
params.extractWindow = [0 (8 * params.Fs) - 1];

params.markerMaxRegion = [];
params.stim = [];

params.numEpochs = 64;
params.numEpochsPrompt = 1;
params.plotMarkers = 0;

%  EMG(zyg) EMG(cor)    RSP     GSR     PPG
%  mV       mV          ?       µS      ?
params.conversion_factor = [(1/1000)*1000 (1/1000)*1000 1/10 1/5 1/100];
params.filterCutoff = [10 450; 10 450; 0.5 1; 0.5 0; 0.5 3]; % [locutoff hicutoff; lo hi; ...]
params.filterColumns = 1:5;
params.filterOrder = 3;
params.filterNotchfreq = 0;

% user-defined params
for i = 1:2:length(varargin)
    switch lower(varargin{i})
        case 'audioind',            params.audioInd = varargin{i+1};
        case 'fs',                  params.Fs = varargin{i+1};
        case 'threshold',           params.threshold = varargin{i+1};
        case 'markerbetween',       params.markerBetween = varargin{i+1};
        case 'markermaxregion',     params.markerMaxRegion = varargin{i+1};
        case 'stim',                params.stim = varargin{i+1};
        case 'numepochs',           params.numEpochs = varargin{i+1};
        case 'numepochsprompt',     params.numEpochsPrompt = varargin{i+1};            
        case 'plotmarkers',         params.plotMarkers = varargin{i+1};
        case 'conversion_factor',   params.conversion_factor = varargin{i+1};
        case 'filterchannels',      params.filterChannels = varargin{i+1};
        case 'filtercutoff',        params.filterCutoff = varargin{i+1};
        case 'filterorder',         params.filterOrder = varargin{i+1};
        case 'filternotchfreq',     params.filterNotchFreq = varargin{i+1};
        case 'extractwindow',       params.extractWindow = varargin{i+1};
    end
end

% load data
disp('Loading EmoCom Physio raw datafile...')
disp(inputfile)
load(inputfile,'data','labels')
params.channelLabels = labels;

% call AudioEpoch
try
    [data,params] = AudioEpoch(data,params);
    numEpochs = size(data,1);
catch me
    disp('AudioEpoch was terminated by the user or there was an error.')
%     rethrow(me)
    return
end

% save epoched data
disp('Saving EmoCom Physio epoched datafile...')
disp(outputfile)
params.date_epoched = datestr(now);
save(outputfile,'data','params')
end