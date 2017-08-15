function ec_plotVerifit

fname = '~/Dropbox/research/archive/2014/ec/ec_verifit.csv';
sname = '~/Dropbox/research/archive/2014/ec/plots/verifit.png';
d = readtable(fname);
d = d(d.included_in_study == 1, :);
d = d(strcmp(d.group,'HI'), :);
freqs = [250 500 1000 1500 2000 3000 4000 6000];
m = length(freqs);
freqsLabels = cellstr(cellfun(@num2str, num2cell(freqs), 'UniformOutput', false));
dataLabels = {'LE: Audiometric Threshold', 'RE: Audiometric Threshold', ...
    'LE: NAL-NL2', 'RE: NAL-NL2', 'LE: HA Output', 'RE: HA Output'};
plotSpec = {'kx-', 'ko-', 'kx--', 'ko--', 'kx:', 'ko:'};
data.audL = 'Audio_Left_';
data.audR = 'Audio_Right_';
data.outL = 'Left_RESR_';
data.outR = 'Right_RESR_';
data.tarL = 'Left_Target1_';
data.tarR = 'Right_Target1_';
names = fieldnames(data);
h = zeros(1,length(names)); % container for plot handles
for i = 1:length(names), field = names{i};
    data.(field) = cellfun(@(f)[data.(field),f], freqsLabels, 'UniformOutput', false);
    data.(field) = d{contains(d.group,'HI'), data.(field)};
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
yl = get(axL, 'YLim');
set(axL,            'Color',            'none'          )
set(axL,            'YLim',             [-5 yl(2)]      )
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
% set(axR,           'YLim',             [-5 yl(2)]      )

%% set plot options
set([axL,axR],      'XLim',             [0 m] + 0.5     )
set([axL,axR],      'XTick',            0:1:m + 0.5     )
set([axL,axR],      'XTickLabel',       []              )
set([axL,axR],      'TickDir',          'out'           )

set(h, 'MarkerSize', 10);
set(h, 'LineWidth', 1.5);
legend(h, dataLabels, 'Location', 'southwest')

axX = axes;
set(axX,            'Color',            'none'          )
set([axL,axR,axX],'XAxisLocation',  'top'           )
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
