#!/usr/bin/env r

# load libraries --------------------------------------------------------------
library(dplyr)
library(plyr)
library(ez)
library(reshape)
library(ggplot2)
library(caret)
library(lme4)

# ec.read.csv function --------------------------------------------------------
ec.read.csv <- function(fname, rms){
  d <- read.csv(fname, header=TRUE)

  # recode emotions into arousal and valence
  d$arousal[d$trials == "happy"] <- 1
  d$arousal[d$trials == "angry"] <- 1
  d$arousal[d$trials == "sad"]   <- 0
  d$arousal[d$trials == "calm"]  <- 0
  d$valence[d$trials == "happy"] <- 1
  d$valence[d$trials == "angry"] <- 0
  d$valence[d$trials == "sad"]   <- 0
  d$valence[d$trials == "calm"]  <- 1

  d$participant <- as.factor(d$participant)
  d$arousal     <- as.factor(d$arousal)
  d$valence     <- as.factor(d$valence)

  names(d)[names(d) == "condition"] <- "stimulus"
  names(d)[names(d) == "trials"]    <- "emotion"
  names(d)[names(d) == "acc1"]      <- "acc"
  names(d)[names(d) == "rt1"]       <- "rt"
  names(d)[names(d) == "mean"]      <- "sclMean"

  rms <- rms[c("filename", "rms")]
  names(rms)[names(rms) == "filename"] <- "stimulus"
  d   <- merge(d, rms, by="stimulus")

  return(d)
}

# ec.aggregate function -------------------------------------------------------
ec.aggregate <- function(d, varname){
  # stimulus and RMS cause problems here for some reason
  d <- subset(d, select=-c(stimulus, rms))
  d <- aggregate(d[, c(varname)],
                 by=list(d$participant, d$group, d$session, d$emotion,
                         d$arousal, d$valence),
                 mean)
  names(d)[1:7] <- c("participant", "group", "session", "emotion", "arousal",
                     "valence", "mean")
  return(d)
}

# ec.aggregate.wins function --------------------------------------------------
ec.aggregate.wins <- function(d){
  d <- melt(d, id=c("participant", "group", "session", "emotion", "arousal",
                    "valence"))
  d <- aggregate(d[, c("value")],
                 by=list(d$participant, d$group, d$session, d$emotion,
                         d$arousal, d$valence, d$variable),
                 mean)
  names(d)[1:8] <- c("participant", "group", "session", "emotion", "arousal",
                     "valence", "window", "mean")
  return(d)
}

# ec.rm.unpaired function -----------------------------------------------------
ec.rm.unpaired <- function(d){

  # for v1 of the tih submission, these Ss were unpaired:
  # 11, 12, 13, 17, 19
  # for v2 (after collecting more data), these Ss were unpaired:
  # 11, 17, 19
  d <- d[!(d$participant == 11), ]
  d <- d[!(d$participant == 17), ]
  d <- d[!(d$participant == 19), ]
  return(d)
}
