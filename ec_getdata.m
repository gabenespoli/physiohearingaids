
% load data
PHZ = phz_load(fullfile('~','local','ec','data','phzfiles','scl.phz'));

% processing
% PHZ = phz_subset(PHZ,PHZ.resp.q1_rt < 7);
PHZ = phz_blsub(PHZ,'baseline');
PHZ = phz_rej(PHZ,0.05);

% change trial order for easy repeated measures in spss
PHZ.trials = {'sad','calm','angry','happy'};
PHZ = phz_check(PHZ);


% feature = {'acc','rt'};
% keepVars = {'participant','group'};
% unstackVars = [];
feature = 'mean';
keepVars = {'participant','group','trials'};
unstackVars = 'trials';

phz_writetable(PHZ,...
    'summary',keepVars,...
    'feature',feature,...
    'region',[1 5],...
    'unstack',unstackVars,...
    'save',fullfile('~','projects','archive','2014','ec','stats','scl mean (rej 0.05).csv'))
