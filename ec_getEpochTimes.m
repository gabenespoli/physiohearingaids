function times = ec_getEpochTimes(id)

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

rawFolder = fullfile('~','local','ec','data','raw');
suffix = '-times';

filename = fullfile(rawFolder, [id, '.mat']);

markerData = phz_create('file',     filename, ...
                        'channel',  6);

times = phzUtil_findAudioMarkers(markerData.data, ...
    threshold,      1 * markerData.srate, ...
    'window',       [0 8] * markerData.srate, ...
    'numMarkers',   64, ...
    'plotMarkers',  false);

timesfile = fullfile(rawFolder, [id, suffix, '.txt']);
if exist(timesfile, file)
    fprintf('File exists: %s\n', timesfile)
    s = input('[o]verwrite or [c]ancel: ', 's');
    if ~strcmpi(s, 'o')
        disp('Aborting...')
        return
    end
end

fid = fopen(timesfile, 'wt');
fprintf(fid, '%i\n', PHZ.proc.epoch.times);
fclose(fid);

end
