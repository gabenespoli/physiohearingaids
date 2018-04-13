function PHZ = ec_phz_create_loop(ids, datatype, force, verbose)

if nargin < 1 || isempty(ids)
    ids = ec_datafiles;
else
    ids = cellstr(ids);
end
if nargin < 2 || isempty(datatype), datatype = 'scl'; end
if nargin < 3 || isempty(force),    force = 0; end
if nargin < 4 || isempty(verbose),  verbose = true; end

saveFolder = fullfile('~','local','ec','data','phzfiles',datatype);
filenames = cell(1,length(ids));
for i = 1:length(ids)
    id = ids{i};
    fprintf('Processing ec id %i/%i: ''%s''\n', i, length(ids), id)

    PHZ = ec_phz_create(id, datatype, false);

    fname = fullfile(saveFolder, [id, '.phz']);
    if isempty(fname), return, end
    PHZ = phz_save(PHZ, fname, verbose, force);

    filenames{i} = PHZ.lib.filename;
end

PHZ = phz_combine(filenames);

% set some plotting parameters
PHZ.group = {'normal', 'impaired', 'aided'};
PHZ.lib.spec.group = {'k-', 'k', 'k--'};

end
