function [datafiles,id,datafolder]=ec_datafiles(varargin)

% defaults
whichfiles='all';
type='';
folder='';

% user-defined
if nargin>0
    for i=1:length(varargin)
        
        switch class(varargin{i})
            case 'char'
                
                % WHICHFILES
                if ismember(varargin{i},{'all','test','test2','to_process','allinboth','allinboth-between','allinboth-within','session2'})
                    whichfiles=varargin{i};
                    
                    % FOLDER
                elseif ismember(varargin{i},{'physio','behav','behavioural','behavioral','processed'})
                    type=varargin{i};
                    
                else
                    folder=varargin{i};
                    
                end
        end
    end
end


% IDS
% ---
switch lower(whichfiles)
    
    case 'session2'
        id={
            '12-1'
            '12-2'
            '14-1'
            '14-2'
            '20-1'
            '20-2'
            '30-1'
            '30-2'
         
            };
    
    case 'allinboth-within'
        id={'5-1'
            '5-2'
            '6-1'
            '6-2'
            '7-1'
            '7-2'
            '9-1'
            '9-2'
            '10-1'
            '10-2'
%             '15-1'
%             '15-2'
            '16-1'
            '16-2'
            '18-1'
            '18-2'
            };
    
    case 'allinboth-between'
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
            '10-2'
            '11-1'
%             '15-1'
%             '15-2'
            '16-1'
            '16-2'
            '18-1'
            '18-2'
            '21-1'
%             '23-1'
%             '24-1'
            '25-1'
%             '26-1'
%             '27-1'
            '28-1'
            '29-1'
            };
    
    case 'allinboth'
        id={'1-1'
            '2-1'
            '3-1'
            %             '4-1'
            %             '4-2'
            '5-1'
            '5-2'
            '6-1'
            '6-2'
            '7-1'
            '7-2'
            '9-1'
            '9-2'
            '10-1'
            '10-2'
            '11-1'
%             '13-2'
%             '14-2'
            %             '15-1'
%             '15-2'
            '16-1'
            '16-2'
%             '17-2'
            '18-1'
            '18-2'
%             '19-1'
%             '20-1'
            '21-1'
            %             '23-1'
            %             '24-1'
            '25-1'
            %             '26-1'
            %             '27-1'
            '28-1'
            '29-1'
            };
    
    case 'all'
         id={'1-1'
            '2-1'
            '3-1'
            %             '4-1'
            %             '4-2'
            '5-1'
            '5-2'
            '6-1'
            '6-2'
            '7-1'
            '7-2'
            '9-1'
            '9-2'
            '10-1'
            '10-2'
            '11-1'
            '13-2'
            '14-2'
            %             '15-1'
            '15-2'
            '16-1'
            '16-2'
            '17-2'
            '18-1'
            '18-2'
            '19-1'
            '20-1'
            '21-1'
            %             '23-1'
            %             '24-1'
            '25-1'
            %             '26-1'
            %             '27-1'
            '28-1'
            '29-1'
            };
        
    case 'batch1'
        id={'1-1'
            '2-1'
            '3-1'
            %             '4-1'
            %             '4-2'
            '5-1'
            '5-2'
            '6-1'
            '6-2'
            '7-1'
            '7-2'
            '9-1'
            '9-2'
            '10-1'
            '10-2'
            '11-1'
            };
        
    case 'batch2'
        id={
            '13-2'
            '14-2'
            %             '15-1'
            '15-2'
            '16-1'
            '16-2'
            '17-2'
            '18-1'
            '18-2'
            '19-1'
            '20-1'
            '21-1'
            %             '23-1'
            %             '24-1'
            '25-1'
            %             '26-1'
            %             '27-1'
            '28-1'
            '29-1'
            };
        
    case 'test'
        id={
%             '4-1'
            '4-2'
            %             '3-1'
            };
        
    case 'to_process'
        id={
            '7-1'
            '7-2'
            '9-1'
            '9-2'
            '10-1'
            '10-2'
            };

    otherwise, error('Unknown file group (var WHICHFILES).')
end


% DATAFOLDER
% ----------
switch type
    case 'physio'
        datafolder=getfolder('ec','data',['/physio/',folder]);
        
    case {'behav','behavioural','behavioral'}
        datafolder=getfolder('ec','data',['/behav/',folder]);
        
    case 'processed'
        datafolder=getfolder('ec','data',['/processed/',folder]);
        
    otherwise, datafolder=[];
end


% DATAFILES
% ---------
if isempty(datafolder) % only return IDs
    datafiles=id;
    id=[];
    
else % combine ID with DATAFOLDER to create DATAFILES
    datafiles=cell(size(id));
    for i=1:length(id)
        datafiles{i}=[datafolder,id{i},'.mat'];
    end
    
end