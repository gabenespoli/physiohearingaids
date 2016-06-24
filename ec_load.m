function varargout = ec_load(participant,session,datatype)

if ischar(participant), participant = num2str(participant); end
if ischar(session), session = num2str(session); end
datatype = lower(datatype);

PHZ = phz_load(getfolder('ec','data',['/phzfiles/',...
    datatype,'/',participant,'-',session,'.mat']));

if nargout == 0, assignin('base','PHZ',PHZ);
else varargout{1} = PHZ; end

end