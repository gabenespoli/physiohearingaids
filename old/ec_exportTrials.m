function ec_exportTrials

folderout=getfolder('ec','data','/txt2');
chans={'zyg','cor','rsp','gsr','ppg','stim'};

[datafiles,id]=ec_datafiles('all','processed');
group=ec_group(id);

w=waitbar(0,'Exporting EC files to .txt');
for p=1:length(datafiles)
    
    w=waitbar(p/length(datafiles));
    load(datafiles{p},'data','stiminfo');
    
    if size(data,3)~=6
        warning(['Skipping file due to incorrect number of channels : ''',datafiles{p},''''])
        continue
    end
    
%     for chan=1:6
        for trial=1:size(data,2)
            
            % id-block-group-trial-emotion
            filename=[id{p},'-',num2str(trial),'-',group{p},'-',stiminfo{trial,3},'.txt'];
            
%             dlmwrite([folderout,filename],squeeze(data(:,trial,:)),'\t');
            
            fid=fopen([folderout,filename],'w');
            for row=1:size(data,1)
                fprintf(fid,'%f\t%f\t%f\t%f\t%f\t%f\t\n',squeeze(data(row,trial,:)));
            end
%             fprintf(fid,'%f\t\n',squeeze(data(:,trial,:)));
            fclose(fid);
            
        end
%     end
end
close(w)