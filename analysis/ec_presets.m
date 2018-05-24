function PHZ = ec_presets(PHZ)

%% settings
plotFolder = fullfile('~','projects','ec','plots'); % where to save plots
tableFolder = fullfile('~','projects','ec','stats'); % where to save plots
ext = '.eps'; % filetype for plots

PHZ.group = {'normal', 'impaired', 'aided'}; % set order for plotting
PHZ.lib.spec.group = {'k-', 'k:', 'k--'};
tooSlowRT = 'PHZ.resp.q1_rt < 7';

% sclProcessing.norm          = 'participant';
% sclProcessing.blsub         = [0 1];
% sclProcessing.reject        = 0.05;
% sclProcessing.region        = [1 5];
sclProcessing.feature       = 'mean';

sclDefaults                 = sclProcessing;
sclDefaults.fontsize        = 18;
sclDefaults.title           = false;
sclDefaults.simpleytitle    = true;
sclDefaults.pretty          = true;
sclDefaults.save            = false;
sclDefaults.sigstar         = 'unpaired';

plotDefaults = rmfield(sclDefaults, fieldnames(sclProcessing));

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
PHZ.lib.tables.(name)               = sclProcessing;
PHZ.lib.tables.(name).filename      = fullfile(tableFolder, ['mean_1-5', '.csv']);
PHZ.lib.tables.(name).save          = false;

%% plots: acc
name = 'acc';
PHZ.lib.plots.(name)                = plotDefaults;
PHZ.lib.plots.(name).feature        = 'acc';
PHZ.lib.plots.(name).filename       = fullfile(plotFolder, ['Figure 3 ', name, ext]);
PHZ.lib.plots.(name).subset         = tooSlowRT;
PHZ.lib.plots.(name).summary        = 'group';

name = 'accByEmo';
PHZ.lib.plots.(name)                = PHZ.lib.plots.acc;
PHZ.lib.plots.(name).filename       = fullfile(plotFolder, ['Figure 4 ', name, ext]);
PHZ.lib.plots.(name).fontsize       = plotDefaults.fontsize + 4;
PHZ.lib.plots.(name).summary        = {'group', 'trials'};

%% plots: rt

name = 'rt';
PHZ.lib.plots.(name)                = PHZ.lib.plots.acc;
PHZ.lib.plots.(name).feature        = 'rt';
PHZ.lib.plots.(name).filename       = fullfile(plotFolder, ['Figure 5 ', name, ext]);

name = 'rtByEmo';
PHZ.lib.plots.(name)                = PHZ.lib.plots.accByEmo;
PHZ.lib.plots.(name).feature        = 'rt';
PHZ.lib.plots.(name).filename       = fullfile(plotFolder, ['Figure 6 ', name, ext]);

%% plots: scl
name = 'sclMean';
PHZ.lib.plots.(name)                = sclDefaults;
PHZ.lib.plots.(name).filename       = fullfile(plotFolder, ['Figure 7 ', name, ext]);
PHZ.lib.plots.(name).summary        = 'group';

name = 'sclMeanByEmo';
PHZ.lib.plots.(name)                = PHZ.lib.plots.sclMean;
PHZ.lib.plots.(name).filename       = fullfile(plotFolder, ['Figure 8 ', name, ext]);
PHZ.lib.plots.(name).summary        = {'group','trials'};
PHZ.lib.plots.(name).fontsize       = plotDefaults.fontsize + 4;

name = 'sclByEmo'; % time-series plot
PHZ.lib.plots.(name)                = PHZ.lib.plots.sclMeanByEmo;
PHZ.lib.plots.(name).filename       = fullfile(plotFolder, ['Figure 12 ', name, ext]);
PHZ.lib.plots.(name).feature        = '';
PHZ.lib.plots.(name).smooth         = true;

%% plots: scl testing
% HP filter, log transform, square root transform, z-score
name = 'sclMean_log';
PHZ.lib.plots.(name)                = sclDefaults;
PHZ.lib.plots.(name).filename       = fullfile(plotFolder, [name, ext]);
PHZ.lib.plots.title                 = true;
PHZ.lib.plots.(name).summary        = 'group';
PHZ.lib.plots.(name).transform      = 'log';

name = 'sclMeanByEmo_log';
PHZ.lib.plots.(name)                = PHZ.lib.plots.sclMean_log;
PHZ.lib.plots.(name).filename       = fullfile(plotFolder, [name, ext]);
PHZ.lib.plots.title                 = true;
PHZ.lib.plots.(name).summary        = {'group','trials'};
PHZ.lib.plots.(name).fontsize       = plotDefaults.fontsize + 4;

name = 'sclMean_sqrt';
PHZ.lib.plots.(name)                = sclDefaults;
PHZ.lib.plots.(name).filename       = fullfile(plotFolder, [name, ext]);
PHZ.lib.plots.title                 = true;
PHZ.lib.plots.(name).summary        = 'group';
PHZ.lib.plots.(name).transform      = 'sqrt';

name = 'sclMeanByEmo_sqrt';
PHZ.lib.plots.(name)                = PHZ.lib.plots.sclMean_log;
PHZ.lib.plots.(name).filename       = fullfile(plotFolder, [name, ext]);
PHZ.lib.plots.title                 = true;
PHZ.lib.plots.(name).summary        = {'group','trials'};
PHZ.lib.plots.(name).fontsize       = plotDefaults.fontsize + 4;

end
