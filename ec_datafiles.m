function id = ec_datafiles(folder, ext)
if nargin < 1, folder = ''; end
if nargin < 2, ext = ''; end
if ~isempty(ext) && ext(1) ~= '.', ext = ['.', ext]; end
id = getid;
for i = 1:length(id)
    id{i} = fullfile(folder, [id{i}, ext]);
end

end

function id = getid
id={'1-1'
    '2-1'
    '3-1'
    % '4-1'
    '5-1'
    '6-1'
    '7-1'
    '9-1'
    '10-1'
    '11-1'
    '15-1'
    '16-1'
    '18-1'
    '19-1'
    '20-1'
    '21-1'
    '23-1'
    '24-1'
    '25-1'
    '26-1'
    '27-1'
    '28-1'
    '29-1'

    % '4-2'
    '5-2'
    '6-2'
    '7-2'
    '9-2'
    % '10-2' % accidentally got stim set 1 twice
    '13-2'
    '14-2'
    '15-2'
    '16-2'
    '17-2'
    '18-2'
};
end
