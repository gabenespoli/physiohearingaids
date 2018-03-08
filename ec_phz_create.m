function [PHZ, raw] = ec_phz_create(id, datatype, verbose)
%ec_phz_create  For a single file. Use phz_create_loop for looping.
%
% usage:
%   PHZ = ec_phz_create(id, [datatype='scl', verbose=true])
%
% input:
%   id          = [string] participant id. i.e., '10-1'
%   datatype    = [string] 'scl', 'emg', etc.
%   verbose     = [true|false]

if nargin < 2, datatype = 'scl'; end
if nargin < 3, verbose = true; end

% settings
rawFolder       = fullfile('~','local','ec','data','raw');
timesSuffix     = '-times';

% prepare
datafile  = fullfile(rawFolder, [id, '.mat']);
timesfile = fullfile(rawFolder, [id, timesSuffix, '.txt']);
verifyFilesExist(datafile, timesfile);

% create PHZ var
PHZ = phz_create('file',        datafile, ...
                 'namestr',     'participant-session', ...
                 'channel',     getChannelNumber(datatype), ...
                 'study',        'Hearing Aids SCL', ...
                 'datatype',    upper(datatype), ...
                 'group',       ec_group(id), ...
                 'verbose',     verbose);
raw = PHZ;

% convert units to microsiemens (uS) if necessary
if ~strcmp(PHZ.units, 'microsiemens')
    conversionFactor = getConversionFactor(datatype);
    PHZ = phz_history(PHZ, ...
                      ['Units are not microsiemens. Using conversion of ', ...
                      num2str(conversionFactor), ' microsiemens per volt.'], ...
                      verbose);
    PHZ = phz_transform(PHZ, conversionFactor, verbose);
    PHZ.units = getDataUnits(datatype); 
end

% filtering
% PHZ.data = medfilt1(PHZ.data,7);
% PHZ = phz_smooth(PHZ, 'rms');
% EMG [10 450], RSP [0.5 1], SCL [0.05 0], PPG [0.5 3],
PHZ = phz_filter(PHZ, [0.05 0 0],...
                 'order',     4,...
                 'zerophase', false,...
                 'verbose',   verbose);

% epoching
times = dlmread(timesfile);
PHZ = phz_epoch(PHZ, ...
                times, ...
                [0 8], ... % marker starts 1 s before stimulus
                'timeUnits', 'samples', ...
                'timesAdjust', -1, ... % adjust times to be [-1 7]
                'verbose',   verbose);
PHZ.region.baseline = [-1 0]; % in s
PHZ.region.target = [1 5]; % in s

% behavioural data
PHZ = insertTrialsAndBehaviouralResponses(PHZ, id);

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
    case {'scl','scr'}, units = 'microsiemens';
    case {'hr','ppg'},  units = '';
end
end

function conversionFactor = getConversionFactor(datatype)
switch lower(datatype)
    case {'zyg','cor'}, conversionFactor = (1/1000)*1000;
    case 'rsp',         conversionFactor = 1/10;
    % case {'scl','scr'}, conversionFactor = 1/5;
    case {'scl','scr'}, conversionFactor = 5;
    case {'hr','ppg'},  conversionFactor = 1/100;
end
end

function PHZ = insertTrialsAndBehaviouralResponses(PHZ, id)

s = ec_convertbehav(id);

% deal with exceptions (i.e., incorrect number of epochs)
% 1-1, thresh 0.1 found 55 markers, removed 11th marker, 54 markers remain
% 2-1, thresh 0.1 found 66 markers, removed 1st and 2nd, 64 remain
% 7-1, thresh 0.1 found 22 23 24
% 9-2, remove 1st
% 10-1 remove 28th

% 12-2, 65 markers, looks like there are really only 62 good ones though
% 14-1, can't read mat file
% 30-2, can't read mat file
switch id
    case '1-1',     ind = [1:32,43:64]; % 54 markers
    case '4-1',     ind = 1:31; % 31 markers
    case '4-2',     ind = 1:32; % 32 markers
    % case '12-2',    ind = 3:64; % 62 markers
    case '12-2',    ind = 5:64; % 60 markers
    case '15-1',    ind = 6:64; % 59 markers
    case '23-1',    ind = 2:64; % 63 markers
    case '24-1',    ind = 5:64; % 60 markers
    case '26-1',    ind = 2:64; % 63 markers
    case '27-1',    ind = 2:64; % 63 markers
    otherwise,      ind = 1:64; % 64 (all) markers
end

% add trial info and responses
PHZ.lib.tags.trials = s.answerString(ind);
PHZ.resp.q1 = s.respString(ind);
PHZ.resp.q1_acc = s.acc(ind);
PHZ.resp.q1_rt = s.rt(ind);

% set trial order and plot colours
PHZ.trials = {'angry','happy','sad','calm'};
PHZ.lib.spec.trials = {'k-.','k-','k:','k--'};

% save stimulus orders too
PHZ.lib.tags.condition = s.stimFiles(ind);
end

function verifyFilesExist(varargin)
for i = 1:length(varargin)
    if ~exist(varargin{i}, 'file')
        error(['File doesn''t exist: ', varargin{i}])
    end
end
end
