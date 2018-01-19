% GETRAVDESSINFO takes a cell vector of RAVDESS filenames and returns a
%   cell array of parameters for those files. Each row is a different file,
%   and each column is a different paramenter. The parameter columns are
%   ordered as follows:
%   
%   1. filename
%   2. Modality
%   3. Vocal channel
%   4. Emotion
%   5. Emotional intensity
%   6. Statement
%   7. Repetition
%   8. Actor
%   9. Actor gender
%   10. RMS level

% The following is from the RAVDESS readme file:
%
% Each file is uniquely named using a unique 7-part identifier. The IDs are as follows:
%
% Modality (1 = full-AV, 2 = video-only, 3 = audio-only, 4 = full-AV full-length, 5 = audio-only full-length)
% Vocal channel (1 = speech, 2 = song)
% Emotion
%    Speech (1 = neutral, 2 = calm, 3 = happy, 4 = sad, 5 = angry, 6 = fearful, 7 = disgust, 8 = surprised)
%    Song   (1 = neutral, 2 = calm, 3 = happy, 4 = sad, 5 = angry, 6 = fearful)
% Emotional intensity (1 = normal, 2 = strong). NOTE: There is no strong intensity for the 'neutral' emotion.
% Statement (1 = Kids are talking by the door, 2 = Dogs are sitting by the door)
% Repetition (1 = 1st rep, 2 = 2nd rep)
% Actor (1 to 24, where odd numbers are male actors, even numbers are female actors)
%
% E.g., the file /default/12/02-01-06-01-02-01-12.mp4
% This is a public-release RAVDESS file (trimmed +-1s either side of vocal sound). It is the 12th actor, and is a female (even numbered). It is Video-only (02-), Speech (01-), Fearful (06-), Normal intensity (01-), Dogs statement (02-), 1st repetition (01-), Actor 12 (12).

function [T,C]=getRAVDESSinfo(filenames, verbose)
if nargin < 2, verbose = true; end

% remove leading singleton dimensions
filenames=shiftdim(filenames);

% create container
stiminfo=cell(size(filenames,1), 10);
badFilenames = {'.', '..'};
rmInds = [];

for i=1:size(filenames,1)
    if verbose, disp(filenames{i}), end
    [~,filename] = fileparts(filenames{i});

    if ismember(filename, badFilenames)
        rmInds = [rmInds, i];
        continue
    end

    % 
    stiminfo{i,1} = filename;

    % 1. MODALITY
    switch filename(1:2)
        case '01', stiminfo{i,2}='full-AV';
        case '02', stiminfo{i,2}='video-only';
        case '03', stiminfo{i,2}='audio-only';
        case '04', stiminfo{i,2}='full-AV full-length';
        case '05', stiminfo{i,2}='audio-only full-length';
    end

    % 2. VOCAL CHANNEL
    switch filename(4:5)
        case '01', stiminfo{i,3}='speech';
        case '02', stiminfo{i,3}='song';
    end

    % 3. EMOTION
    switch filename(7:8)
        case '01', stiminfo{i,4}='neutral';
        case '02', stiminfo{i,4}='calm';
        case '03', stiminfo{i,4}='happy';
        case '04', stiminfo{i,4}='sad';
        case '05', stiminfo{i,4}='angry';
        case '06', stiminfo{i,4}='fearful';
        case '07', stiminfo{i,4}='disgust';
        case '08', stiminfo{i,4}='surprise';
    end

    % 4. EMOTIONAL INTENSITY
    switch filename(10:11)
        case '01', stiminfo{i,5}='normal';
        case '02', stiminfo{i,5}='strong';
    end    

    % 5. STATEMENT
    switch filename(13:14)
        case '01', stiminfo{i,6}='kids';
        case '02', stiminfo{i,6}='dogs';
    end       

    % 6. REPETITION
    switch filename(16:17)
        case '01', stiminfo{i,7}=1;
        case '02', stiminfo{i,7}=2;
    end         

    % 7. ACTOR
    stiminfo{i,8}=str2double(filename(19:20));

    % 8. ACTOR GENDER
    switch mod(str2double(filename(19:20)),2)
        case 0, stiminfo{i,9}='female';
        case 1, stiminfo{i,9}='male';
    end

    % 9. RMS
    [y,Fs] = audioread(filenames{i});
    % remove first second, remove white noise channel
    sample1 = 1 * Fs;
    sample2 = 3 * Fs;
    y = y(sample1:sample2, 1);
    stiminfo{i,10} = sqrt(mean(mean(y .^ 2)));

end
stiminfo(rmInds,:) = [];

C = stiminfo;
T = cell2table(stiminfo, 'VariableNames', { ...
    'filename', ...
    'modality', ...
    'vocal_channel', ...
    'emotion', ...
    'emotional_intensity', ...
    'statement', ...
    'repetition', ...
    'actor', ...
    'actor_gender', ...
    'rms'});

if verbose
    emotions = unique(T.emotion);
    disp('RMS')
    for i = 1:length(emotions)
        fprintf('%s: %f\n', ...
            emotions{i}, ...
            mean(T.rms(contains(T.emotion,emotions{i}))))
    end
end
