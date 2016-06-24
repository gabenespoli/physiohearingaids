function group=ec_group(id)
% give me a participant id, I'll give you the name of the group they're in.

allgroups=ec_groupinfo;

group = allgroups{ismember(allgroups(:,1),id),2};
    
end

function allgroups=ec_groupinfo
allgroups={'1-1'      'normal';
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
         '30-1'     'impaired';
         '30-2'     'aided';
         };
end