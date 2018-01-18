function d = ec_four_consecutive_windows
%% vars

feature = 'mean';
filename = 'ec_4wins_mean.csv';

win1 = [0 0.5];
win2 = [0.5 1];
win3 = [1 1.5];
win4 = [1.5 2];

%% code

setup('phz')
phz = phz_load(gf('data','ec','phzfiles','scr_all.phz'));

phz_plot(phz,'summary',{'group','trials'},'region',win1,'feature',feature)
phz_plot(phz,'summary',{'group','trials'},'region',win2,'feature',feature)
phz_plot(phz,'summary',{'group','trials'},'region',win3,'feature',feature)
phz_plot(phz,'summary',{'group','trials'},'region',win4,'feature',feature)

d1 = phz_writetable(phz,'summary',{'participant','group','trials'},'region',win1,'feature',feature);
d2 = phz_writetable(phz,'summary',{'participant','group','trials'},'region',win2,'feature',feature);
d3 = phz_writetable(phz,'summary',{'participant','group','trials'},'region',win3,'feature',feature);
d4 = phz_writetable(phz,'summary',{'participant','group','trials'},'region',win4,'feature',feature);

d = join(d1,d2,'Keys',{'participant','group','trials'});
d = join(d,d3,'Keys',{'participant','group','trials'});
d = join(d,d4,'Keys',{'participant','group','trials'});

writetable(d,filename)

end