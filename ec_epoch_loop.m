function probs = ec_epoch_loop

participants = [12 14 20 30];
sessions = 1:2;
probs = {};

for p = 1:length(participants)
    for s = 1:length(sessions)
        
        filename = fullfile(gf('data','ec','raw'),...
                [num2str(participants(p)),'-',num2str(sessions(s)),...
                '.mat']);
        
        if exist(filename,'file')
            
            disp(' ')
            disp(['Epoching file ',num2str(participants(p)),'-',...
                num2str(sessions(s)),'.mat...'])
            try numEpochs = ec_epoch(participants(p),sessions(s));
            catch err,
                probs{end+1,1} = filename;
                probs{end,2} = err;
                continue
            end
            
            if numEpochs ~= 64,
                probs{end+1,1} = filename;
                probs{end,2} = ['Only ',num2str(numEpochs),' epochs.'];
            end 
        end     
    end
end

disp('Problem files:')
disp(probs)

end