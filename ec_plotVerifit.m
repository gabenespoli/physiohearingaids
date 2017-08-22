function ec_plotVerifit

fname = '~/Dropbox/research/archive/2014/ec/ec_verifit.csv';
sname = '~/Dropbox/research/archive/2014/ec/plots/verifit.png';
d = readtable(fname);
d = d(d.included_in_study == 1, :);
d = d(strcmp(d.group,'HI'), :);
freqs = [250 500 1000 1500 2000 3000 4000 6000];
m = length(freqs);
freqsLabels = cellstr(cellfun(@num2str, num2cell(freqs), 'UniformOutput', false));
dataLabels = { ...
    'LE: Audiometric Threshold', ...
    'RE: Audiometric Threshold', ...
    'LE: NAL-NL2', ...
    'RE: NAL-NL2', ...
    'LE: HA Output', ...
    'RE: HA Output'};
plotSpec = {'kx-', 'ko-', 'kx--', 'ko--', 'kx:', 'ko:'};
data.audL = 'Left_EnteredHL_';
data.audR = 'Right_EnteredHL_';
data.nalL = 'Left_Target'; % there are three levels that will be averaged
data.nalR = 'Right_Target';
data.outL = 'Left_Test';
data.outR = 'Right_Test';
names = fieldnames(data);
h = zeros(1,length(names)); % container for plot handles

for i = 1:length(names), field = names{i};
    if ismember(i, [3,4,5,6])
        % average across all presentation levels for targets/tests
        temp1 = cellfun(@(f)[data.(field),'1_',f], freqsLabels, 'UniformOutput', false);
        temp2 = cellfun(@(f)[data.(field),'2_',f], freqsLabels, 'UniformOutput', false);
        temp3 = cellfun(@(f)[data.(field),'3_',f], freqsLabels, 'UniformOutput', false);
        temp1 = d{contains(d.group,'HI'), temp1};
        temp2 = d{contains(d.group,'HI'), temp2};
        temp3 = d{contains(d.group,'HI'), temp3};
        data.(field) = nanmean(cat(3,temp1,temp2,temp3), 3);
    else
        % plain audiogram, no multiple levels to average across
        data.(field) = cellfun(@(f)[data.(field),f], freqsLabels, 'UniformOutput', false);
        data.(field) = d{contains(d.group,'HI'), data.(field)};
    end
end

close all
figure('OuterPosition', [70 200 800 620]);

%% plot left y-axis
axL = axes;
set(axL, 'YDir', 'reverse')
hold on
for i = 1:2, field = names{i};
    ebar = errorbar(axL,1:m, nanmean(data.(field)), nanstd(data.(field)), '.');
    ebar.Color = [1 1 1] * 0.5;
end
for i = 1:2, field = names{i};
    ind = ismember(names, field);
    h(i) = plot(axL, 1:m, nanmean(data.(field)), plotSpec{ind});
end
set(axL,            'Color',            'none'          )
set(axL,            'YGrid',            'on'            )
set(axL,            'Box',              'on'            )

%% plot right y-axis
axR = axes;
hold on
for i = 3:6, field = names{i};
    ind = ismember(names, field);
    h(i) = plot(axR, 1:m, nanmean(data.(field)), plotSpec{ind});
end
set(axR,            'Color',            'none'          )
set(axR,            'YAxisLocation',    'right'         )

%% set plot options
yl = getmaxyl(get(axL,'YLim'), get(axR,'YLim'));
set([axL,axR],      'YLim',             yl              )
set([axL,axR],      'XLim',             [0 m] + 0.5     )
set([axL,axR],      'XTick',            (0:1:m) + 0.5   )
set([axL,axR],      'XTickLabel',       []              )
set([axL,axR],      'TickDir',          'out'           )

set(h, 'MarkerSize', 10);
set(h, 'LineWidth', 1.5);
lgnd = legend(h, dataLabels, 'Location', 'southwest');
set(lgnd,           'Color',            'none'          )

axX = axes;
set(axX,            'Color',            'none'          )
set([axL,axR,axX],  'XAxisLocation',    'top'           )
set(axX,            'XLim',             get(axL,'Xlim') )
set(axX,            'XTickLabel',       freqsLabels     )
set(axX,            'TickLength',       [0 0]           )
set(axX,            'YTick',            []              )
xlabel(axX,         'Frequency (Hz)'                    )
ylabel(axL,         'dB HL'                             )
ylabel(axR,         'dB SPL'                            )
set([axL,axR,axX],  'FontSize', 14                      )
set(gcf,            'Color',            'w'             )

savefig(sname)

end

function yl = getmaxyl(yl1,yl2)
ylmin = min([yl1(1), yl2(1)]);
ylmax = max([yl1(2), yl2(2)]);
yl = [ylmin, ylmax];
end
