function addWhiteNoise

whichfiles='stimuli';

% id={'03-01-02-01-02-01-12.wav'};
id=getStimFiles({[whichfiles,'/original']});

% inputFiles={'/Users/gmac/Dropbox/Research/Projects/EmoCom/task/stimuli/original/'};
inputFolder=['/Users/gmac/Dropbox/Research/Projects/EmoCom/task/',whichfiles,'/original/'];
outputFolder=['/Users/gmac/Dropbox/Research/Projects/EmoCom/task/',whichfiles,'/'];

for i=1:length(id)
    disp(num2str(i))
    [y,Fs]=audioread([inputFolder,id{i}]);
    noise=wgn(length(y),1,-16);
    audiowrite([outputFolder,id{i}],[y(:,1),noise],Fs)
    if size(y,2)>2, warning(['File ',id{i},' has more than 2 channels.']), end
end