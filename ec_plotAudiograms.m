function ec_plotAudiograms

fname = '~/Dropbox/research/archive/2014/ec/ec_audiograms.csv';
sname = '~/Dropbox/research/archive/2014/ec/plots/audiograms.png';
d = readtable(fname);
d = d(d.included_in_study == 1, :);

freqs = [250 500 1000 2000 3000 4000 6000 8000];
m = length(freqs);
freqsLabels = cellstr(cellfun(@num2str, num2cell(freqs), 'UniformOutput', false));
prefixL = 'Audio_Left_';
prefixR = 'Audio_Right_';
freqsL = cellfun(@(f)[prefixL,f], freqsLabels, 'UniformOutput', false);
freqsR = cellfun(@(f)[prefixR,f], freqsLabels, 'UniformOutput', false);

% aud = [d(:,{'id','group'}), d(:,freqsL), d(:,freqsR)];

nhL = d{contains(d.group,'NH'),freqsL};
nhR = d{contains(d.group,'NH'),freqsR};
hiL = d{contains(d.group,'HI'),freqsL};
hiR = d{contains(d.group,'HI'),freqsR};
data = {nhL, nhR, hiL, hiR};
dataLabels = {'NH: LE', 'NH: RE', 'HI: LE', 'HI: RE'};
plotSpec = {'kx-', 'ko-', 'kx:', 'ko:'};

close all
figure('OuterPosition', [70 200 800 620]);
ax1 = axes;
set(ax1,        'YDir',             'reverse'       )
hold on

for i = 1:length(data)
    % ebar = errorbar(ax1,1:m, nanmean(data{i}), ste(data{i},[],true), '.');
    ebar = errorbar(ax1,1:m, nanmean(data{i}), nanstd(data{i}), '.');
    ebar.Color = [1 1 1] * 0.5;
end

h = zeros(1,4);
for i = 1:length(data)
    h(i) = plot(ax1, 1:m, nanmean(data{i}), plotSpec{i});
end

set(h, 'MarkerSize', 10);
set(h, 'LineWidth', 1.5);
legend(h, dataLabels, 'Location', 'southwest')

yl = get(ax1, 'YLim');
set(ax1,        'YLim',             [-5 yl(2)]       )
set(ax1,        'XLim',             [0 m] + 0.5     )
set(ax1,        'XTick',            (0:1:m) + 0.5   )
set(ax1,        'XTickLabel',       []              )
set(ax1,        'TickDir',          'out'           )
set(ax1,        'YGrid',            'on'            )
set(ax1,        'Box',              'on'            )
ax2 = axes;
set(ax2,        'Color',            'none'          )
set([ax1,ax2],  'XAxisLocation',    'top'           )
set(ax2,        'XLim',             get(ax1,'Xlim') )
set(ax2,        'XTickLabel',       freqsLabels     )
set(ax2,        'TickLength',       [0 0]           )
set(ax2,        'YTick',            []              )
xlabel(ax2,     'Frequency (Hz)')
ylabel(ax1,     'Audiometric Threshold (dB HL)')
set([ax1,ax2],  'FontSize', 14)
set(gcf,        'Color',            'w'             )

savefig(sname)

end
