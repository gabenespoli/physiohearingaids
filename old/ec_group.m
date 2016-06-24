function [group,g]=ec_group(id)

% % defaults
% 
% 
% % user-defined
% if nargin>0
%     for i=1:length(varargin)
%         
%         switch class(varargin{i})
%             case 'char'
%                 
%         end
%     end
% end

allinfo=ec_datainfoVars;

% parse input & create containers
if ischar(id)
    id={id}; % convert input to cell if it's char
elseif iscell(id)
    group=cell(length(id),1);
end

NH=[];
HA=[];
HI=[];

for p=1:length(id)
    
    % put participant's group into output container
    group{p}=allinfo{ismember(allinfo(:,1),id{p}),2};
%     group{p}=allinfo{find(ismember(allinfo(:,1),id{p})),2};
    
    % create indices vars
    switch group{p}
        case 'normal',   NH=[NH p];
        case 'aided',    HA=[HA p];
        case 'impaired', HI=[HI p];
    end
    
end

% convert vars to single struct
g.group=group;
g.NH=NH;
g.HA=HA;
g.HI=HI;

if iscell(group) && length(group) == 1
    group = group{1};
end

end

function allinfo=ec_datainfoVars
allinfo={'1-1'      'normal';
         '2-1'      'normal';
         '3-1'      'normal';
         '4-1'      'impaired';
         '4-2'      'aided';
         '5-1'      'impaired';
         '5-2'      'aided';
         '6-1'      'impaired';
         '6-2'      'aided';
         '7-1'      'impaired';
         '7-2'      'aided';
         '9-1'      'impaired';
         '9-2'      'aided';
         '10-1'     'impaired';
         '10-2'     'aided';
         '11-1'     'normal';
         '12-1'     'impaired';
         '12-2'     'aided';
         '13-1'     'impaired';
         '13-2'     'aided';
         '14-1'     'impaired';
         '14-2'     'aided';
         '15-1'     'impaired';
         '15-2'     'aided';
         '16-1'     'impaired';
         '16-2'     'aided';
         '17-1'     'impaired';
         '17-2'     'aided';
         '18-1'     'impaired';
         '18-2'     'aided';
         '19-1'     'impaired';
         '19-2'     'aided';
         '20-1'     'impaired';
         '20-2'     'aided';
         '21-1'     'normal';
         '22-1'     'normal';
         '23-1'     'normal';
         '24-1'     'normal';
         '25-1'     'normal';
         '26-1'     'normal';
         '27-1'     'normal';
         '28-1'     'normal';
         '29-1'     'normal';
         };
end