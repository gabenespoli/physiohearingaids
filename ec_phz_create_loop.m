function PHZ = ec_phz_create_loop(ids, datatype)

if nargin < 2, datatype = 'scl'; end

saveFolder = fullfile('~','local','ec','data','phzfiles',datatype);
force = 2;
verbose = true;

if nargin < 1
    ids = ec_datafiles;
else
    ids = cellstr(ids);
end

for i = 1:length(ids)
    id = ids{i};
    fprintf('Processing ec id %i/%i: ''%s''\n', i, length(ids), id)

    PHZ = ec_phz_create(id, datatype, false);

    fname = fullfile(saveFolder, [id, '.phz']);
    phz_save(PHZ, fname, verbose, force);

end

PHZ = phz_combine(saveFolder);

end

