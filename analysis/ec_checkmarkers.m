function ec_checkmarkers(id, start)
if nargin < 2, start = 1; end
verbose = false;

folder = fullfile('~','local','ec','data','raw');
id = cellstr(id);

for i = start:length(id)

    filename = fullfile(folder, [id{i}, '.mat']);
    timesname = fullfile(folder, [id{i}, '-times.txt']);

    PHZ = phz_create('filename', filename, 'channel', 6, 'verbose', verbose);
    times = dlmread(timesname);
    PHZ = phz_epoch(PHZ, times, [0 8], 'timeUnits', 'samples', 'verbose', verbose);

    fprintf('%i/%i: %s\n', i, length(id), id{i})
    phz_review(PHZ, [], false);
end
