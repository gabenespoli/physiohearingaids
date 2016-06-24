function ec(varargin)
switch varargin{1}
    case 'load',                ec_load(varargin{2:end});
    otherwise, return
end
end