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

for i = 1:length(names), field = names{i};
    data.(field) = cellfun(@(f)[data.(field),f], freqsLabels, 'UniformOutput', false);
    data.(field) = d{contains(d.group,'HI'), data.(field)};
end

close all
fig = figure('OuterPosition', [70 200 800 620]);
axL = axes;
set(axL, 'YDir', 'reverse')
hold on

for i = 1:length(names), field = names{i};
    % ebar = errorbar(axL,1:m, nanmean(data.(field)), ste(data.(field),[],true), '.');
    ebar = errorbar(axL,1:m, nanmean(data.(field)), nanstd(data.(field)), '.');
    ebar.Color = [1 1 1] * 0.5;
end

h = zeros(1,length(names));
for i = 1:length(names), field = names{i};
    i = find(ismember(names, field));
    h(i) = plot(axL, 1:m, nanmean(data.(field)), plotSpec{i});
end

set(h, 'MarkerSize', 10);
set(h, 'LineWidth', 1.5);
legend(h, dataLabels, 'Location', 'southwest')

yl = get(axL, 'YLim');
set(axL,        'YLim',             [-5 yl(2)]      )
set(axL,        'XLim',             [0 m] + 0.5     )
set(axL,        'XTick',            0:1:m + 0.5     )
set(axL,        'XTickLabel',       []              )
set(axL,        'TickDir',          'out'           )
set(axL,        'YGrid',            'on'            )
set(axL,        'Box',              'on'            )
axX = axes;
set(axX,        'Color',            'none'          )
set([axL,axX],  'XAxisLocation',    'top'           )
set(axX,        'XLim',             get(axL,'Xlim') )
set(axX,        'XTickLabel',       freqsLabels     )
set(axX,        'TickLength',       [0 0]           )
set(axX,        'YTick',            []              )
xlabel(axX,     'Frequency (Hz)'                    )
ylabel(axL,     'Audiometric Threshold (dB HL)'     )
set([axL,axX],  'FontSize', 14                      )
set(gcf,        'Color',            'w'             )

savefig(sname)

end
