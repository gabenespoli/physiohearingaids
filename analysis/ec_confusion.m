function d = ec_confusion(asTables, asPercent)
% cats = categories
% d is a struct containing confusion matrices
%   rows are actual category of stimulus
%   cols are selected category (participant response)
% asPercent (boolean) = as a percentage of all responses for each 'actual' category
%   i.e., a percentage of all responses in that row

if nargin < 1, asTables = true; end
if nargin < 1, asPercent = true; end

addpath('~/bin/matlab/phzlab')
fname = '~/local/data/ec/phzfiles/scl.phz';

phz = phz_load(fname);

lt7 = phz.resp.q1_rt < 7; % get trials with rt less than 7 seconds
group = phz.meta.tags.group(lt7);
trials = phz.meta.tags.trials(lt7); % correct answers
cats = categories(trials);
resp = categorical(phz.resp.q1(lt7), cats, 'Ordinal', true); % participants' responses

for g = {'normal', 'impaired', 'aided'}
    ind = group == g{1};
    tempTrials = trials(ind);
    tempResp = resp(ind);
    data = getConfusion(tempTrials, tempResp, cats);
    switch g{1}
        case 'normal',      nh = data;
        case 'impaired',    hi = data;
        case 'aided',       ha = data;
    end
end

d.nh = nh;
d.hi = hi;
d.ha = ha;
d.nhhi = nh + hi;
d.hiha = hi + ha;
d.nhha = nh + ha;

if asTables || asPercent
    names = fieldnames(d);
    for i = 1:length(names)
        name = names{i};

        if asPercent
            for j = 1:size(d.(name),1) % loop rows
                total = sum(d.(name)(j,:));

                for k = 1:size(d.(name)) % loop columns
                    d.(name)(j,k) = (d.(name)(j,k) / total) * 100;

                end
            end
        end

        if asTables
            d.(name) = array2table(d.(name), 'VariableNames', cats, 'RowNames', cats);
        end
    end
end


d.cats = cats;

end

function d = getConfusion(actual, resp, cats)
% actual category in rows; selected category in columns
d = nan(length(cats));
for j = 1:length(cats)
    temp = resp(actual == cats(j));
    for i = 1:length(cats)
        d(i,j) = sum(temp == cats(i));
    end
end
end
