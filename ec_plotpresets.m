function PHZ = ec_plotpresets(PHZ)

if ismember('plots', fieldnames(PHZ.lib))
    PHZ.lib = rmfield(PHZ.lib, 'plots');
end

PHZ.lib.spec.group = {'k-', 'k:', 'k--'};

folder = fullfile('~','projects','ec','plots');
ext = '.eps';
fontsize = 18;

name = 'acc';
PHZ.lib.plots.(name).subset         = 'PHZ.resp.q1_rt < 7';
PHZ.lib.plots.(name).feature        = 'acc';
PHZ.lib.plots.(name).summary        = 'group';
PHZ.lib.plots.(name).pretty         = true;
PHZ.lib.plots.(name).title          = false;
PHZ.lib.plots.(name).simpleytitle   = true;
PHZ.lib.plots.(name).fontsize       = fontsize;
PHZ.lib.plots.(name).filename       = fullfile(folder, ['Figure 3 ', name, ext]);
% PHZ.lib.plots.(name).sigstar        = { {{'normal', 'impaired'}, ...
%                                          {'impaired', 'aided'}, ...
%                                          {'normal', 'aided'}}, ...
%                                         [0.07991 0.2 0.001778], 1, fontsize };

name = 'rt';
PHZ.lib.plots.(name)                = PHZ.lib.plots.acc;
PHZ.lib.plots.(name).feature        = 'rt';
PHZ.lib.plots.(name).fontsize       = fontsize;
PHZ.lib.plots.(name).filename       = fullfile(folder, ['Figure 5 ', name, ext]);
% PHZ.lib.plots.(name).sigstar        = { {{'normal', 'impaired'}, ...
%                                          {'impaired', 'aided'}, ...
%                                          {'normal', 'aided'}}, ...
%                                         [9.219e-6 0.7759 5.578e-6], 1, fontsize };

name = 'sclMean';
PHZ.lib.plots.(name).transform      = 1/5; % convert to same units as first time preprocessing 
PHZ.lib.plots.(name).blsub          = 'baseline';
PHZ.lib.plots.(name).reject         = 0.05;
PHZ.lib.plots.(name).region         = [1 5];
PHZ.lib.plots.(name).feature        = 'mean';
PHZ.lib.plots.(name).summary        = 'group';
PHZ.lib.plots.(name).pretty         = true;
PHZ.lib.plots.(name).title          = false;
PHZ.lib.plots.(name).simpleytitle   = true;
PHZ.lib.plots.(name).fontsize       = fontsize;
PHZ.lib.plots.(name).filename       = fullfile(folder, ['Figure 7 ', name, ext]);
% PHZ.lib.plots.(name).sigstar        = { {{'normal', 'impaired'}, ...
%                                          {'impaired', 'aided'}, ...
%                                          {'normal', 'aided'}}, ...
%                                         [0.5184 0.7274 0.619], 1, fontsize };

name = 'accByEmo';
PHZ.lib.plots.(name)                = PHZ.lib.plots.acc;
PHZ.lib.plots.(name).summary        = {'group', 'trials'};
PHZ.lib.plots.(name).fontsize       = fontsize + 4;
PHZ.lib.plots.(name).filename       = fullfile(folder, ['Figure 4 ', name, ext]);
PHZ.lib.plots.(name).sigstar        = [];

name = 'rtByEmo';
PHZ.lib.plots.(name)                = PHZ.lib.plots.rt;
PHZ.lib.plots.(name).summary        = {'group', 'trials'};
PHZ.lib.plots.(name).fontsize       = fontsize + 4;
PHZ.lib.plots.(name).filename       = fullfile(folder, ['Figure 6 ', name, ext]);
PHZ.lib.plots.(name).sigstar        = [];

name = 'sclMeanByEmo';
PHZ.lib.plots.(name)                = PHZ.lib.plots.sclMean;
PHZ.lib.plots.(name).summary        = {'group','trials'};
PHZ.lib.plots.(name).fontsize       = fontsize + 4;
PHZ.lib.plots.(name).filename       = fullfile(folder, ['Figure 8 ', name, ext]);
PHZ.lib.plots.(name).sigstar        = [];

name = 'sclByEmo';
PHZ.lib.plots.(name)                = PHZ.lib.plots.sclMean;
PHZ.lib.plots.(name).feature        = '';
PHZ.lib.plots.(name).smooth         = true;
PHZ.lib.plots.(name).fontsize       = fontsize + 4;
PHZ.lib.plots.(name).filename       = fullfile(folder, ['Figure 12 ', name, ext]);
PHZ.lib.plots.(name).sigstar        = [];

end
