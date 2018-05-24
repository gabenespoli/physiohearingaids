function [times, PHZ] = ec_getEpochTimes(id, plotMarkers)
if nargin < 2, plotMarkers = true; end

% exceptions:
% 1-1, thresh 0.1 found 55 markers, removed 11th marker, 54 markers remain
% 2-1, thresh 0.1 found 66 markers, removed 1st and 2nd, 64 remain
% 7-1, thresh 0.1 found 22 23 24
% 9-2, remove 1st
% 10-1 remove 28th
% ? 12-2, 65 markers, looks like there are really only 62 good ones though

rawFolder = fullfile('~','local','ec','data','raw');
suffix = '-times';

filename = fullfile(rawFolder, [id, '.mat']);

PHZ = phz_create('file',     filename, ...
                 'channel',  6);

times = phzUtil_findAudioMarkers(PHZ.data, ...
    0.1, ...            % threshold
    1 * PHZ.srate, ...  % time between
    'numMarkers',   64, ...
    'plotMarkers',  plotMarkers);
times = times';

timesfile = fullfile(rawFolder, [id, suffix, '.txt']);
if exist(timesfile, 'file')
    fprintf('File exists: %s\n', timesfile)
    s = input('[o]verwrite or [c]ancel: ', 's');
    if ~strcmpi(s, 'o')
        disp('Aborting...')
        return
    end
end

fid = fopen(timesfile, 'wt');
fprintf(fid, '%i\n', times);
fclose(fid);

end
