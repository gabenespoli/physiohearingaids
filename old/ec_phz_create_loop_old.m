function probs = ec_phz_create_loop_old

participants = [12 14 20 30];
sessions = 1:2;
% datatypes = {'zyg','cor','rsp','ppg','scl'};
datatypes = {'scl','zyg','cor'};

probs = {};

w = waitbar(0,'Looping EC and creating PHZfiles...');

for p = 1:length(participants)
    for s = 1:length(sessions)
        waitbar((p * s + s) / (length(participants) * length(sessions)),w)
        
        
        try
            splitfile = fullfile('~','local','ec','data','split',...
                [num2str(participants(p)),'-',num2str(sessions(s)),'.mat']); 
            
            if exist(splitfile,'file')
                disp(' ')
                for i = 1:length(datatypes)
                    ec_phz_create_old(participants(p),sessions(s),datatypes{i});
                end
            end
            
        catch err
            probs{end+1,1} = [num2str(participants(p)),'-',num2str(sessions(s))];
            probs{end,2} = err;
            
        end
    end
end
close(w)

disp('Problem Files:')
disp(probs)

end
