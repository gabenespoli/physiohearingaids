function d = ec_recodeTrials2D(d)

% create containers
arousal = categorical;
valence = categorical;

% fill with values
arousal(d.trials == 'angry' | d.trials == 'happy') = 'high';
arousal(d.trials == 'sad' | d.trials == 'calm') = 'low';

valence(d.trials == 'angry' | d.trials == 'sad') = 'negative';
valence(d.trials == 'happy' | d.trials == 'calm') = 'positive';

% make column vectors
arousal = arousal';
valence = valence';

% add to table
d = [d table(arousal) table(valence)];

end