function filtdata=RMS50(data,win)

% Set filter coefficients
b=ones(win,1)/win;
a=1;

% Filter data
% filtdata=sqrt(filter(b,a,data.^2));
filtdata=sqrt(filtfilt(b,a,data.^2));

% Correct for time shift
filtdata=filtdata(ceil(win/2):end-floor(win/2)-1,:);