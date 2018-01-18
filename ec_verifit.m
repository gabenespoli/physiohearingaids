function [fit,id] = ec_verifit(freqs,presLevel)

if nargin < 1, freqs = [500 1000 2000 4000]; end
if nargin < 2, presLevel = 2; end % 1 = 55; 2 = 65; 3 = 75
if isnumeric(presLevel), presLevel = num2str(presLevel); end

data = xls2table('ec_verifit.xlsx');
ears = {'Left','Right'};
fit = nan(size(data,1),length(freqs),2); % id X freq X ear

for k = 1:length(ears)
    ear = ears{k};
    
    for j = 1:length(freqs)
        freq = num2str(freqs(j));
        
        for i = 1:size(data,1)
        
            fit(i,j,k) = ...
                data.([ear,'_','Target',presLevel,'_',freq])(i) - ...
                data.([ear,'_','Test',presLevel,'_',freq])(i);
        end
    end
end

fit = nanmean(fit,3); % collapse ears
fit = nanmean(fit,2); % collapse freqs

end

function d = xls2table(filename)
%XLS2TABLE  Load an Excel file as a MATLAB table. If there is a column
%   header "id", it sorts the table by this column.

[~,~,d] = xlsread(filename);

% cleanup headers
rminds = [];
illegalHeaderChars = {' ','-'};
for i = 1:size(d,2)
    
    % check for nan headers
    if isnan(d{1,i}), rminds = [rminds i]; end
    
    % check for illegal characters
    for j = 1:length(illegalHeaderChars)
        d{1,i} = strrep(d{1,i},illegalHeaderChars{j},'_');
    end
    
end
d(:,rminds) = [];

d = cell2table(d(2:end,:),'VariableNames',d(1,:));

% sort based on id
if ismember('id',d.Properties.VariableNames)
    [~,ind] = sort(d.id);
    d = d(ind,:);
end
end