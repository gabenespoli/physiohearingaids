source("~/projects/archive/2014/ec/stats/ec_functions.r")

# read and prepare data -------------------------------------------------------
# acc = accuracy; rt = reaction time; scl = mean skin conductance level
# NI = normal vs impaired; IA = impaired vs aided; NA = normal vs aided

folder <- "~/projects/archive/2014/ec/stats/"
suffix <- ""
ext    <- ".csv"

rmsFile <- paste(folder, "rms_praat",        ext, sep="")
accFile <- paste(folder, "acc",      suffix, ext, sep="")
rtFile  <- paste(folder, "rt",       suffix, ext, sep="")
sclFile <- paste(folder, "mean_1-5", suffix, ext, sep="")

rms    <- read.csv(rmsFile, header=TRUE)
acc    <- ec.read.csv(accFile, rms)
rt     <- ec.read.csv(rtFile,  rms)
scl    <- ec.read.csv(sclFile, rms)

acc    <- ec.aggregate(acc, "acc")
rt     <- ec.aggregate(rt,  "rt")
scl    <- ec.aggregate(scl, "sclMean")

ACC.NI <- filter(acc, group %in% c("normal", "impaired"))
RT.NI  <- filter(rt,  group %in% c("normal", "impaired"))
SCL.NI <- filter(scl, group %in% c("normal", "impaired"))
ACC.IA <- filter(acc, group %in% c("impaired", "aided"))
RT.IA  <- filter(rt,  group %in% c("impaired", "aided"))
SCL.IA <- filter(scl, group %in% c("impaired", "aided"))
ACC.IA <- ec.rm.unpaired(ACC.IA)
RT.IA  <- ec.rm.unpaired(RT.IA)
SCL.IA <- ec.rm.unpaired(SCL.IA)
ACC.NA <- filter(acc, group %in% c("normal", "aided"))
RT.NA  <- filter(rt,  group %in% c("normal", "aided"))
SCL.NA <- filter(scl, group %in% c("normal", "aided"))


# Effects of hearing impairment.-----------------------------------------------
t.test(ACC.NI$mean ~ ACC.NI$group, paired=FALSE)
t.test(RT.NI$mean  ~ RT.NI$group,  paired=FALSE)
t.test(SCL.NI$mean ~ SCL.NI$group, paired=FALSE)


# Effects of emotion dimensions on hearing impairment.-------------------------
ezANOVA(ACC.NI, dv=.(mean), wid=.(participant), within=.(arousal, valence),
        between=.(group), detailed=FALSE, type="III")
ddply(ACC.NI, c("group"), summarise, mean=mean(mean))
ddply(ACC.NI, c("valence"), summarise, mean=mean(mean))
ddply(ACC.NI, c("arousal", "valence"), summarise, mean=mean(mean))

ezANOVA(RT.NI, dv=.(mean), wid=.(participant), within=.(arousal, valence),
        between=.(group), detailed=FALSE, type="III")
ddply(RT.NI, c("group"), summarise, mean=mean(mean))
ddply(RT.NI, c("valence"), summarise, mean=mean(mean))
ddply(RT.NI, c("arousal"), summarise, mean=mean(mean))
ddply(RT.NI, c("arousal", "valence"), summarise, mean=mean(mean))

ezANOVA(temp, dv=.(mean), wid=.(participant), within=.(arousal, valence),
        between=.(group), detailed=FALSE, type="III")
ddply(SCL.NI, c("group"), summarise, mean=mean(mean))
ddply(SCL.NI, c("arousal", "valence"), summarise, mean=mean(mean))
ddply(SCL.NI, c("group", "arousal"), summarise, mean=mean(mean))


# Effects of hearing aids.-----------------------------------------------------
t.test(ACC.IA$mean ~ ACC.IA$group, paired=FALSE)
t.test(RT.IA$mean  ~ RT.IA$group,  paired=FALSE)
t.test(SCL.IA$mean ~ SCL.IA$group, paired=FALSE)


# Effects of emotion dimsions on the use of hearing aids.----------------------
# ddply summaries are to view means for interpreting interactions
ezANOVA(ACC.IA, dv=.(mean), wid=.(participant), within=.(arousal, valence),
        between=.(group), detailed=FALSE, type="III")
ddply(ACC.IA, c("valence"), summarise, mean=mean(mean))
ddply(ACC.IA, c("arousal", "valence"), summarise, mean=mean(mean))

ezANOVA(RT.IA, dv=.(mean), wid=.(participant), within=.(arousal, valence),
        between=.(group), detailed=FALSE, type="III")

ezANOVA(SCL.IA, dv=.(mean), wid=.(participant), within=.(arousal, valence),
        between=.(group), detailed=FALSE, type="III")
ddply(SCL.IA, c("group"), summarise, mean=mean(mean))


# Similarity of normal hearing and hearing-aided groups------------------------
t.test(ACC.NA$mean ~ ACC.NA$group, paired=FALSE)
t.test(RT.NA$mean  ~ RT.NA$group,  paired=FALSE)
t.test(SCL.NA$mean ~ SCL.NA$group, paired=FALSE)


# Confusion matrices-----------------------------------------------------------
df <- read.csv("~/Dropbox/research/archive/2014/ec/stats/confusion.csv")

# df.subset <- filter(df, group %in% c("impaired", "normal", "aided"))
df.subset <- filter(df, group %in% c("aided", "impaired"))
cm <- confusionMatrix(df.subset$response, df.subset$actual)
pct <- cm$table
for(i in 1:4) {
    total <-= sum(pct[, i])
    pct[, i] <- pct[, i] / total
}
pct


# RMS of stimuli---------------------------------------------------------------
rms <- read.csv("/Users/gmac/Dropbox/research/archive/2014/ec/stimuli_rms.csv")
rms$arousal[rms$emotion == "happy"] <- 1
rms$arousal[rms$emotion == "angry"] <- 1
rms$arousal[rms$emotion == "sad"] <- 0
rms$arousal[rms$emotion == "calm"] <- 0
rms$arousal <- as.factor(rms$arousal)
rms$valence[rms$emotion == "happy"] <- 1
rms$valence[rms$emotion == "angry"] <- 0
rms$valence[rms$emotion == "sad"] <- 0
rms$valence[rms$emotion == "calm"] <- 1
rms$valence <- as.factor(rms$valence)

ezANOVA(rms, dv=.(rms), wid=.(filename), between=.(set, emotion), detailed=FALSE, type="III")

ezANOVA(rms, dv=.(rms), wid=.(filename), between=.(arousal,valence), detailed=FALSE, type="III")

ddply(rms, c("arousal","valence"), summarise, mean=mean(rms))
ddply(rms, c("arousal","valence"), summarise, mean=mean(rms))
