%STE Standard error.
function y = ste(x, dim, do_nan)
if nargin < 2 || isempty(dim), dim = 1; end
if nargin < 3, do_nan = false; end
if do_nan
    y = nanstd(x,0,dim) / sqrt(size(x,dim));
else
    y = std(x,0,dim) / sqrt(size(x,dim));
end
end
