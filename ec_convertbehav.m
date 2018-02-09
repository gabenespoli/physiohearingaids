function s = ec_convertbehav(id)

rawFolder = fullfile('~','local','ec','data','raw');
stimfolder = fullfile('~','local','ec','stimuli_all');
suffix = '-logfile';

d = load(fullfile(rawFolder, [id, suffix, '.mat']));

s.resp          = [d.nResp(:,1);        d.nResp(:,2)];
s.rt            = [d.respTime(:,1);     d.respTime(:,2)];
s.respString    = [d.sResp(:,1);        d.sResp(:,2)];
s.stimFiles     = [d.stimFiles(:,1);    d.stimFiles(:,2)];
s.stimOrder     = [d.stimOrder(:,1);    d.stimOrder(:,2)];

s.stimFiles     = s.stimFiles(s.stimOrder);
RAVDESSfilenames = strcat(stimfolder, '/', s.stimFiles);
stimInfo = getRAVDESSinfo(RAVDESSfilenames, false);
s.answerString=stimInfo{:,'emotion'};

s.happy = find(strcmp(s.answerString,'happy'));
s.sad   = find(strcmp(s.answerString,'sad'));
s.angry = find(strcmp(s.answerString,'angry'));
s.calm  = find(strcmp(s.answerString,'calm'));

s.answer(s.happy) = 1;
s.answer(s.sad)   = 2;
s.answer(s.angry) = 3;
s.answer(s.calm)  = 4;
s.answer=s.answer';

for i=1:length(s.resp)
    if s.answer(i)==s.resp(i)
        s.acc(i)=1;
    else 
        s.acc(i)=0;
    end
end
s.acc = s.acc';
