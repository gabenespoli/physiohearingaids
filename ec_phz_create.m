function PHZ = ec_phz_create(participant,session,datatype)

% file I/O
filename = [num2str(participant),'-',num2str(session)];
inputfolder = gf('data','ec','split');
outputfolder = gf('data','ec','phzfiles',lower(datatype));
inputfile = fullfile(inputfolder,[filename,'.mat']);
outputfile = fullfile(outputfolder,[filename,'.mat']);

% load epoched data file
disp('Loading EmoCom epoched datafile...')
disp(inputfile)
load(inputfile,'data','params')

% load behav file
load(fullfile(gf('data','ec','behav'),...
    [num2str(participant),'-',num2str(session),'.mat']),...
    'answerString','respString','ACC','RT');

% deal with exceptions (i.e., incorrect number of epochs)
switch [num2str(participant),'-',num2str(session)]
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

% create blank PHZ structure
PHZ = phz_create;

% fill PHZ structure fields
PHZ.study = 'Phonak Physio Speech';
PHZ.participant = participant;
PHZ.group = ec_group([num2str(participant),'-',num2str(session)]);
PHZ.session = session;
PHZ.datatype = lower(datatype);

PHZ.srate = params.Fs;

PHZ.data = data(:,:,getChannelNumber(datatype));

% PHZ.locs.data = 1:size(PHZ.data,1);
PHZ.times = (-1000:1:6999) / params.Fs;

PHZ.region.baseline = [-1 0]; % in s
PHZ.region.target = [0 4]; % in s
PHZ.region.target2 = [1 5];
PHZ.region.target3 = [2 6];

PHZ.units = getDataUnits(datatype);

PHZ.meta.tags.trials = answerString(ind);

PHZ.resp.q1 = respString(ind);
PHZ.resp.q1_acc = ACC(ind);
PHZ.resp.q1_rt = RT(ind);

PHZ.trials = {'angry','happy','sad','calm'};
PHZ.meta.spec.trials = {'r','b','r--','b--'};

PHZ.misc.epoch_params = params;

% PHZ = phz_check(PHZ);

% save phyzlab file
% disp('Saving EmoCom Physio PHZLAB datafile...')
% disp(outputfile)
% save(outputfile,'PHZ')

PHZ = phz_save(PHZ,outputfile);

end

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
    case {'scl','gsr'}, units = 'µS';
    case {'hr','ppg'},  units = '';
end
end