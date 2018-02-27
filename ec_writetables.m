function [meanscl, rt, acc] = ec_writetables

% settings
suffix = '_with_stimulus_name';
savename = [];
savedir = fullfile('~','projects','archive','2014','ec','stats');

% load and preprocess data
PHZ = phz_load(fullfile('~','local','ec','data','phzfiles','scl.phz'));
scl   = PHZ;
scl   = phz_blsub(scl, 'baseline');
scl   = phz_reject(scl, 0.05);
behav = PHZ;
behav = phz_subset(behav, PHZ.resp.q1_rt < 7);

% calls to phz_writetable
region = [1 5];
savename = fullfile(savedir, ['mean_', phzUtil_num2strRegion(region, '-'), suffix, '.csv']);
meanscl = phz_writetable(scl,...
    'region',   region,...
    'feature',  'mean',...
    'save',     savename);

savename = fullfile(savedir, ['rt', suffix, '.csv']);
rt = phz_writetable(behav,...
    'feature',  'rt',...
    'save',     savename);

savename = fullfile(savedir, ['acc', suffix, '.csv']);
acc = phz_writetable(behav,...
    'feature',  'acc',...
    'save',     savename);
