function PHZ = ec_phz_create
%% ec physio load phzfiles script
% 
%   1. pops up a dialog to select multiple acq-saved-as-mat files
%   2. loads the data and creates a PHZ file
%   3. filters the data
%   4. loads the marker channel and finds epoch times
%   5. epochs the data
%   6. saves the PHZ file.

%% settings

% 1. phz_create
study = 'EmoCom Physio';
filenameConvention = 'participant-session';

datatype = 'scl';
channelNumber = getChannelNumber(datatype);

region.baseline = [-1 0]; % in s
region.target = [0 4]; % in s
region.target2 = [1 5];
region.target3 = [2 6];
region.target4 = [];

% 2. phz_transform
conversionFactor = getConversionFactor(datatype);
dataUnits = getDataUnits(datatype);

% 3. phz_filter [locut hicut notch order]
% EMG [10 450], RSP [0.5 1], GSR [0.5 0], PPG [0.5 3], ([hp lp])
filterCutoff = [];

% 4a. phzUtil_findAudioMarkers
% exceptions:
% 1-1, thresh 0.1 found 55 markers, removed 11th marker, 54 markers remain
% 2-1, thresh 0.1 found 66 markers, removed 1st and 2nd, 64 remain
% 7-1, thresh 0.1 found 22 23 24
% 9-2, remove 1st
% 10-1 remove 28th
% ? 12-2, 65 markers, looks like there are really only 62 good ones though
markerChannel = 6;
threshold = 0.1;
markerBetween = 1; % in seconds (converted to samples below)
plotMarkers = false;
numMarkers = 64;

% 4b. phz_epoch
extractWindow = [0 8]; % in seconds

% 5. phz_save
saveFolder = '/Users/gmac/Documents/data/ec/phzfiles';
makeSubfolderWithDatatypeName = true;

%% phzlab code

% pop-up window to select files
[files,folder] = uigetfile('.mat','Select PHZ files to gather...','MultiSelect','on');
files = cellstr(files);

% loop through files
for i = 1:length(files)
    
    [~,filename] = fileparts(files{i});
    currentFile = fullfile(folder,[filename,'.mat']);
        
    PHZ = phz_create(currentFile,...
        'namestr',filenameConvention,...
        'channel',channelNumber,...
        'study',study);
    PHZ.group = ec_group([char(PHZ.participant),'-',char(PHZ.session)]);
    PHZ.region = region;
    
    
    PHZ = phz_transform(PHZ,conversionFactor,dataUnits);
    
    PHZ = phz_filter(PHZ,filterCutoff);
    
    markerData = phz_create(currentFile,'channel',markerChannel);
    times = phzUtil_findAudioMarkers(markerData.data,...
        threshold,markerBetween * markerData.srate,...
        'window',extractWindow * markerData.srate,...
        'numMarkers',numMarkers,...
        'plotMarkers',plotMarkers);
    PHZ = phz_epoch(PHZ,extractWindow,times);
    
    PHZ = insertTrialsAndBehaviouralResponses(PHZ);
    
    if makeSubfolderWithDatatypeName, saveFolder = getDataDir(saveFolder,PHZ.datatype); end
    PHZ = phz_save(PHZ,fullfile(saveFolder,[filename,'.phz']));
    
end
end

%% support functions
function chan = getChannelNumber(datatype)
switch lower(datatype)
    case 'zyg',         chan = 1;
    case 'cor',         chan = 2;
    case 'rsp',         chan = 3;
    case {'scl','gsr'}, chan = 4;
    case {'hr','ppg'},  chan = 5;
end
end

function units = getDataUnits(datatype)
switch lower(datatype)
    case 'zyg',         units = 'mV';
    case 'cor',         units = 'mV';
    case 'rsp',         units = '';
    case {'scl','gsr'}, units = '�S';
    case {'hr','ppg'},  units = '';
end
end

function conversionFactor = getConversionFactor(datatype)
switch lower(datatype)
    case {'zyg','cor'}, conversionFactor = (1/1000)*1000;
    case 'rsp',         conversionFactor = 1/10;
    case {'scl','gsr'}, conversionFactor = 1/5;
    case {'hr','ppg'},  conversionFactor = 1/100;
end
end

function PHZ = insertTrialsAndBehaviouralResponses(PHZ)
% load behav file
load(fullfile(gf('data','ec','behav'),...
    [char(PHZ.participant),'-',char(PHZ.session),'.mat']),...
    'answerString','respString','ACC','RT');

% deal with exceptions (i.e., incorrect number of epochs)
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
PHZ.meta.tags.trials = answerString(ind);
PHZ.resp.q1 = respString(ind);
PHZ.resp.q1_acc = ACC(ind);
PHZ.resp.q1_rt = RT(ind);

% set trial order and plot colours
PHZ.trials = {'angry','happy','sad','calm'};
PHZ.meta.spec.trials = {'r','b','r--','b--'};
end

function newFolder = getDataDir(saveFolder,datatype)
newFolder = fullfile(saveFolder,datatype);
if ~exist(newFolder,'dir')
    [~,~] = system(['mkdir ',newFolder]);
end
end