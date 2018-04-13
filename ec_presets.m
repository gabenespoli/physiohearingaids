function PHZ = ec_presets(PHZ)

%% settings
plotFolder = fullfile('~','projects','ec','plots'); % where to save plots
tableFolder = fullfile('~','projects','ec','stats'); % where to save plots
ext = '.eps'; % filetype for plots
PHZ.group = {'normal', 'impaired', 'aided'}; % set order for plotting
PHZ.lib.spec.group = {'k-', 'k:', 'k--'};
tooSlowRT = 'PHZ.resp.q1_rt < 7';

% plots
plotDefaults.fontsize       = 18;
plotDefaults.simpleytitle   = true;
plotDefaults.pretty         = true;
plotDefaults.save           = false;

%% discard previous presets
fields = {'plots', 'tables'};
for i = 1:length(fields)
    field = fields{i};
    if ismember(field, fieldnames(PHZ.lib))
        PHZ.lib = rmfield(PHZ.lib, field);
    end
end

%% tables
name = 'acc';
PHZ.lib.tables.(name).feature       = 'acc';
PHZ.lib.tables.(name).filename      = fullfile(tableFolder, ['acc', '.csv']);
PHZ.lib.tables.(name).save          = false;
PHZ.lib.tables.(name).subset        = tooSlowRT;

name = 'rt';
PHZ.lib.tables.(name).feature       = 'rt';
PHZ.lib.tables.(name).filename      = fullfile(tableFolder, ['rt', '.csv']);
PHZ.lib.tables.(name).save          = false;
PHZ.lib.tables.(name).subset        = tooSlowRT;

name = 'sclMean';
PHZ.lib.tables.(name).feature       = 'mean';
PHZ.lib.tables.(name).region        = [1 5];
PHZ.lib.tables.(name).filename      = fullfile(tableFolder, ['mean_1-5', '.csv']);
PHZ.lib.tables.(name).save          = false;
PHZ.lib.tables.(name).reject        = 1;
PHZ.lib.tables.(name).blsub         = [0 1];

%% plots: acc
name = 'acc';
PHZ.lib.plots.(name).feature        = 'acc';
PHZ.lib.plots.(name)                = plotDefaults;
PHZ.lib.plots.(name).title          = false;
PHZ.lib.plots.(name).filename       = fullfile(plotFolder, ['Figure 3 ', name, ext]);
PHZ.lib.plots.(name).subset         = tooSlowRT;
PHZ.lib.plots.(name).summary        = 'group';
% PHZ.lib.plots.(name).sigstar        = { {{'normal', 'impaired'}, ...
%                                          {'impaired', 'aided'}, ...
%                                          {'normal', 'aided'}}, ...
%                                         [0.07991 0.2 0.001778], 1, fontsize };

name = 'accByEmo';
PHZ.lib.plots.(name)                = PHZ.lib.plots.acc;
PHZ.lib.plots.(name).filename       = fullfile(plotFolder, ['Figure 4 ', name, ext]);
PHZ.lib.plots.(name).fontsize       = plotDefaults.fontsize + 4;
PHZ.lib.plots.(name).summary        = {'group', 'trials'};
PHZ.lib.plots.(name).sigstar        = [];

%% plots: rt

name = 'rt';
PHZ.lib.plots.(name).feature        = 'rt';
PHZ.lib.plots.(name)                = PHZ.lib.plots.acc;
PHZ.lib.plots.(name).filename       = fullfile(plotFolder, ['Figure 5 ', name, ext]);
% PHZ.lib.plots.(name).sigstar        = { {{'normal', 'impaired'}, ...
%                                          {'impaired', 'aided'}, ...
%                                          {'normal', 'aided'}}, ...
%                                         [9.219e-6 0.7759 5.578e-6], 1, fontsize };

name = 'rtByEmo';
PHZ.lib.plots.(name)                = PHZ.lib.plots.rt;
PHZ.lib.plots.(name).filename       = fullfile(plotFolder, ['Figure 6 ', name, ext]);
PHZ.lib.plots.(name).summary        = {'group', 'trials'};
PHZ.lib.plots.(name).fontsize       = plotDefaults.fontsize + 4;
PHZ.lib.plots.(name).sigstar        = [];

%% plots: scl
name = 'sclMean';
PHZ.lib.plots.(name).feature        = 'mean';
PHZ.lib.plots.(name).region         = [1 5];
PHZ.lib.plots.(name).summary        = 'group';
PHZ.lib.plots.(name)                = plotDefaults;
PHZ.lib.plots.(name).title          = false;
PHZ.lib.plots.(name).filename       = fullfile(plotFolder, ['Figure 7 ', name, ext]);
PHZ.lib.plots.(name).blsub          = [0 1];
PHZ.lib.plots.(name).reject         = 1;
% PHZ.lib.plots.(name).sigstar        = { {{'normal', 'impaired'}, ...
%                                          {'impaired', 'aided'}, ...
%                                          {'normal', 'aided'}}, ...
%                                         [0.5184 0.7274 0.619], 1, fontsize };

name = 'sclMeanByEmo';
PHZ.lib.plots.(name)                = PHZ.lib.plots.sclMean;
PHZ.lib.plots.(name).filename       = fullfile(plotFolder, ['Figure 8 ', name, ext]);
PHZ.lib.plots.(name).fontsize       = plotDefaults.fontsize + 4;
PHZ.lib.plots.(name).summary        = {'group','trials'};
PHZ.lib.plots.(name).sigstar        = [];

name = 'sclByEmo';
PHZ.lib.plots.(name)                = PHZ.lib.plots.sclMean;
PHZ.lib.plots.(name).filename       = fullfile(plotFolder, ['Figure 12 ', name, ext]);
PHZ.lib.plots.(name).fontsize       = plotDefaults.fontsize + 4;
PHZ.lib.plots.(name).feature        = '';
PHZ.lib.plots.(name).smooth         = true;
PHZ.lib.plots.(name).sigstar        = [];

end
