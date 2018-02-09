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

    '5-1'
    '5-2'
    '6-1'
    '6-2'
    '7-1'
    '7-2'
    '9-1'
    '9-2'
    '10-1'
    '10-2' % got stim set 1 twice

    '11-1'
    '13-2'

    '14-1'
    '14-2'

    '15-1'
    '15-2'
    '16-1'
    '16-2'

    '17-2'

    '18-1'
    '18-2'

    '19-1'

    '20-1'
    '20-2'

    '21-1'

    '23-1'
    '24-1'
    '25-1'
    '26-1'
    '27-1'
    '28-1'
    '29-1'

    '31-1'
    '30-2'

    '32-1'

    '33-1'
    '33-2'
    '34-1'
    '34-2'
    '35-1'
    '35-2'
};
end
