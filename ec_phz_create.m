function PHZ = ec_phz_create(varargin)
%% ec physio load phzfiles script
% 
%   1. pops up a dialog to select multiple acq-saved-as-mat files
%   2. loads the data and creates a PHZ file
%   3. filters the data
%   4. loads the marker channel and finds epoch times
%   5. epochs the data
%   6. saves the PHZ file.
%   7. combines all PHZ files into a single one and returns it

%% settings
verbose = false;

% 1. phz_create
study = 'Hearing Aids SCL';
filenameConvention = 'participant-group-session';

datatype = 'scl';
channelNumber = getChannelNumber(datatype);

region.baseline = [-1 0]; % in s
region.target = [1 5]; % in s
region.target2 = [];
region.target3 = [];
region.target4 = [];

% 2. phz_transform
conversionFactor = getConversionFactor(datatype);
dataUnits = getDataUnits(datatype);

% 3. phz_filter [locut hicut notch]
% EMG [10 450], RSP [0.5 1], SCR [0.05 0], PPG [0.5 3], ([hp lp])
%                            SCL []
filterCutoff = [0.05 0 0];
filterOrder = 4;
do_zerophase = false;

% 4a. phzUtil_findAudioMarkers
% exceptions:
% 1-1, thresh 0.1 found 55 markers, removed 11th marker, 54 markers remain
% 2-1, thresh 0.1 found 66 markers, removed 1st and 2nd, 64 remain
% 7-1, thresh 0.1 found 22 23 24
% 9-2, remove 1st
% 10-1 remove 28th
% ? 12-2, 65 markers, looks like there are really only 62 good ones though
% markerChannel = 6;
% threshold = 0.1;
% markerBetween = 1; % in seconds (converted to samples below)
% plotMarkers = false;
% numMarkers = 64;

% 4b. phz_epoch
extractWindow = [0 8]; % in seconds

% 5. phz_save
saveFolder       = fullfile('~','local','ec','data','phzfiles',datatype);
epochTimesFolder = fullfile('~','local','ec','data','epoch_times_in_samples');
behavFolder      = fullfile('~','local','ec','data','behav');

%% phzlab code

if nargin > 0 && nargin < 3
    for i = 1:length(varargin)
        if ischar(varargin{i}) && ... % folder
           isdir(varargin{i})
            folder = varargin{i};
        elseif (ischar(varargin{i}) && exist(varargin{i}, 'file')) || ...
                iscell(varargin{i}) % file(s)
            files = cellstr(varargin{i});
        end
    end
else
    % pop-up window to select files
    [files,folder] = uigetfile('.mat','MultiSelect','on');
end

if ~exist('files', 'var') && ~isempty(folder)
    d = dir(folder); % get files in folder
    names = {d.name}; % get only filenames
    ind = regexp(names, '^.*\.mat$'); % get only mat files
    ind = ~cellfun(@isempty, ind); % convert cell to vector
    files = names(ind);
end

if ~isempty(folder)
    for i = 1:length(files)
        files{i} = fullfile(folder, files{i});
    end
end

% loop through files
for i = 1:length(files)

    if exist(files{i}, 'file')
        [pathstr,filename] = fileparts(files{i});
    else
        pathstr = folder;
    end
    currentFile = fullfile(pathstr,[filename,'.mat']);
    if ~exist(currentFile, 'file')
        warning(['File ''', currentFile, ''' not found. Skipping...'])
        continue
    end
        
    PHZ = phz_create('file',currentFile,...
        'namestr',filenameConvention,...
        'channel',channelNumber,...
        'study',study,...
        'datatype',datatype, ...
        'verbose',verbose);

    PHZ.group = ec_group([char(PHZ.participant),'-',char(PHZ.session)]);
    PHZ.region = region;
    
    PHZ = phz_transform(PHZ,conversionFactor,verbose);
    PHZ.units = dataUnits;
    
    PHZ = phz_filter(PHZ,filterCutoff,...
        'zerophase',do_zerophase,...
        'order',filterOrder,...
        'verbose',verbose);

%     markerData = phz_create('file',currentFile,'channel',markerChannel);
%     times = phzUtil_findAudioMarkers(markerData.data,...
%         threshold,markerBetween * markerData.srate,...
%         'window',extractWindow * markerData.srate,...
%         'numMarkers',numMarkers,...
%         'plotMarkers',plotMarkers);

%     timesFilename = [char(PHZ.participant),'-',...
%         char(PHZ.group),'-',...
%         char(PHZ.session)];
    times = dlmread(fullfile(epochTimesFolder,[filename,'.txt']));
    PHZ = phz_epoch(PHZ,extractWindow,times,'timeUnits','samples','verbose',verbose);
    
    PHZ = insertTrialsAndBehaviouralResponses(PHZ,behavFolder);
    
    phz_save(PHZ,fullfile(saveFolder,[filename,'.phz']));
    
    % save epoch times to text file
%     fid = fopen(fullfile(epochTimesFolder,[filename,'.txt']),'w');
%     fprintf(fid,'%i\n',PHZ.proc.epoch.times);
%     fclose(fid);
    
end

PHZ = phz_combine(saveFolder);



end

function chan = getChannelNumber(datatype)
switch lower(datatype)
    case 'zyg',         chan = 1;
    case 'cor',         chan = 2;
    case 'rsp',         chan = 3;
    case {'scl','scr'}, chan = 4;
    case {'hr','ppg'},  chan = 5;
end
end

function units = getDataUnits(datatype)
switch lower(datatype)
    case 'zyg',         units = 'mV';
    case 'cor',         units = 'mV';
    case 'rsp',         units = '';
    case {'scl','scr'}, units = '\muS';
    case {'hr','ppg'},  units = '';
end
end

function conversionFactor = getConversionFactor(datatype)
switch lower(datatype)
    case {'zyg','cor'}, conversionFactor = (1/1000)*1000;
    case 'rsp',         conversionFactor = 1/10;
    case {'scl','scr'}, conversionFactor = 1/5;
    case {'hr','ppg'},  conversionFactor = 1/100;
end
end

function PHZ = insertTrialsAndBehaviouralResponses(PHZ,behavFolder)
% load behav file
load(fullfile(behavFolder,...
    [char(PHZ.participant),'-',char(PHZ.session),'.mat']),...
    'answerString','respString','ACC','RT','stimFiles');

% deal with exceptions (i.e., incorrect number of epochs)
% 1-1, thresh 0.1 found 55 markers, removed 11th marker, 54 markers remain
% 2-1, thresh 0.1 found 66 markers, removed 1st and 2nd, 64 remain
% 7-1, thresh 0.1 found 22 23 24
% 9-2, remove 1st
% 10-1 remove 28th

% 12-2, 65 markers, looks like there are really only 62 good ones though
% 14-1, can't read mat file
% 30-2, can't read mat file
switch [char(PHZ.participant),'-',char(PHZ.session)]
    case '1-1',     ind = [1:32,43:64]; % 54 markers
    case '4-1',     ind = 1:31; % 31 markers
    case '4-2',     ind = 1:32; % 32 markers
    case '15-1',    ind = 6:64; % 59 markers
    case '23-1',    ind = 2:64; % 63 markers
    case '24-1',    ind = 5:64; % 60 markers
    case '26-1',    ind = 2:64; % 63 markers
    case '27-1',    ind = 2:64; % 63 markers
    otherwise,      ind = 1:64; % 64 (all) markers
end

% add trial info and responses
PHZ.lib.tags.trials = answerString(ind);
PHZ.resp.q1 = respString(ind);
PHZ.resp.q1_acc = ACC(ind);
PHZ.resp.q1_rt = RT(ind);

% set trial order and plot colours
PHZ.trials = {'angry','happy','sad','calm'};
PHZ.lib.spec.trials = {'k-.','k-','k:','k--'};

% save stimulus orders too
PHZ.lib.tags.condition = stimFiles(ind);
end
