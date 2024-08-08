## /analysis/02-data_summary.R
library(purrr)
library(skimr)

load(here("data", "clean", "data_xlsx.RData"), verbose = TRUE)
load(here("data", "clean", "data_1_no_repeat_all.RData"), verbose = TRUE)
load(here("data", "clean", "data_2_combine_ext.RData"), verbose = TRUE)
load(here("data", "clean", "data_3_no_missing.RData"), verbose = TRUE)   

length(unique(data_xlsx[["id"]]))
length(unique(data_no_repeat_all[["id"]]))
## 122 participants having responses
length(unique(data_no_missing[["id"]]))

# ==========
## Raw data
# ==========
data_xlsx |> 
    filter(run == "Extincti") |> 
    select(id) |> 
    unique()

data_xlsx |> 
    filter(run == "Run1") |> 
    select(id) |> 
    unique()

data_xlsx |> 
    filter(run == "Run2") |> 
    select(id) |> 
    unique()

data_xlsx |> 
    filter(run == "Run3") |> 
    select(id) |> 
    unique()

data_xlsx |> 
    filter(id == "129") |> 
    select(run) |> 
    table()


# ==========
## clean data
# ==========
data_combine_ext |> 
    filter(run == "run1") |> 
    select(id) |> 
    unique()

data_combine_ext |> 
    filter(run == "run2") |> 
    select(id) |> 
    unique()

data_combine_ext |> 
    filter(run == "run3") |> 
    select(id) |> 
    unique()

data_combine_ext |> 
    filter(id == "129") |> 
    select(run) |> 
    table()


# ==========
## clean data no missing
# ======================

data <- data_no_missing

## --------------------------------
## learning round has more reactions, 
## and frequency of reaction decays with time passed, 
## especially for fear and reward
## fear has more reactions than others
## --------------------------------

freq_react_run <- data |> select(run) |> table() 


freq_react_run_cond <- data |> group_by(run) |> select(run, condition) |> 
    table()


freq_react_run_cond <- cbind(freq_react_run_cond, freq_react_run)

freq_react_run_cond <- rbind(freq_react_run_cond, apply(freq_react_run_cond, 2, sum))


# freq_react_run_cond <- matrix(freq_react_run_cond, ncol = ncol(freq_react_run_cond), 
#        dimnames = dimnames(freq_react_run_cond))

# freq_react_run_cond


# rel_freq_react_run_cond <- apply(freq_react_run_cond, 1, function(x) x/sum(x))

round(freq_react_run_cond / max(freq_react_run_cond), 2)


## --------------------------------
## tend to have reaction in the first trial, especially "fear" condition
## the number of reactions decreasing with trials
## the number increases a little bit in 7th and 8th trial (not significant)
## --------------------------------

data_cond_trial <- data |> group_by(condition) |> select(trial) |> table()

par(mfrow = c(2, 3), mar = c(4, 4, 2, 1))
for (i in seq_along(rownames(data_cond_trial))) {
    barplot(data_cond_trial[i, ], 
            main = paste(rownames(data_cond_trial)[i], "w/ learn"), las = 1,
            xlab = "trial", ylab = "number of reactions", ylim = c(0, 120))
}

## remove learn run
data_cond_trial_no_learn <- data |> group_by(condition) |> 
    filter(run != "learn") |> 
    select(trial) |> 
    table()

par(mfrow = c(2, 3), mar = c(4, 4, 2, 1))
for (i in seq_along(rownames(data_cond_trial_no_learn))) {
    barplot(data_cond_trial_no_learn[i, ], 
            main = paste(rownames(data_cond_trial)[i], "w/o learn"), las = 1,
            xlab = "trial", ylab = "number of reactions", ylim = c(0, 85))
}


par(mfrow = c(1, 2), mar = c(4, 4, 2, 1))
data_cond_trial |> 
    barplot(legend.text = levels(data$condition), 
            ylim = c(0, 360), las = 1,
            args.legend = list(x = "topright", bty = "n"))
data_cond_trial_no_learn |> 
    barplot(legend.text = levels(data$condition), 
            ylim = c(0, 360), las = 1,
            args.legend = list(x = "topright", bty = "n"))

## --------------------------------

## --------------------------------
# data_cond_no_learn <- data |> group_by(condition) |> 
#     filter(run != "learn") |> 
#     select(-cs_stim_time)

# data_split_cond <- data |> 
#     filter(run != "learn") |> 
#     select(id, starts_with("cs") | condition) %>% 
#     select(-cs_stim_time) %>% 
#     split(.$condition) |> 
#     lapply(function(x) select(x, -condition))

data_split_cond <- data |> 
    filter(run != "learn") %>%
    split(.$condition)

cs_sum_cond <- lapply(data_split_cond, function(x) apply(x[, -c(1:5)], 2, summary))
cs_sd_cond <- lapply(data_split_cond, function(x) apply(x[, -c(1:5)], 2, sd))
cs_summ_cond <- vector("list", 5)
for (i in 1:5) {
    cs_summ_cond[[i]] <- rbind(cs_sum_cond[[i]], cs_sd_cond[[i]])
    rownames(cs_summ_cond[[i]]) <-
        c("min", "1stQ", "med", "mean", "3rdQ", "max", "sd")
}
names(cs_summ_cond) <- levels(data$condition)
lapply(cs_summ_cond, function(x) round(x, digits = 3))
cs_var_name <- c("Base Level",
                 "Latency",
                 "Amplitude",
                 "Rise Time",
                 "Reaction Size",
                 "Onset")
for (k in seq_along(names(data_split_cond[[1]][-c(1:5)]))) {
    par(mfrow = c(2, 3), mar = c(4, 4, 2, 1))
    lapply(1:5, function(x) hist(data_split_cond[[x]][[k+5]],
                                 main = names(data_split_cond)[x],
                                 xlab = cs_var_name[k+5], las = 1, breaks = 15))
}

cs_summ_cond_var <- vector("list", length(names(data_split_cond[[1]][-c(1:5)])))

for (k in seq_along(names(data_split_cond[[1]][-c(1:5)]))) {
    cs_summ_cond_var[[k]] <- sapply(cs_summ_cond, function(x) x[, k])
}
names(cs_summ_cond_var) <- colnames(data_no_missing)[-c(1:5)]

lapply(data_split_cond, function(x) {
    if (length(which(x$cs_amplitude == 0)) > 0) {
        x[which(x$cs_amplitude == 0), ]
    }})

## No significant difference on Onset
## No significant difference on Reaction Size
## 

data_cond_no_learn |> 
    filter(condition == "fear") |> 
    group_by(trial)
table(data_cond_no_learn[data_cond_no_learn$condition == "fear", "trial"])

data_fear <- data |> 
    filter(condition == "fear") |> 
    filter(run != "learn") |> 
    select(-c(id, run, condition, cs_stim_time))

data_fear_trial <- data_fear %>% split(.$trial)
data_fear_trial <- lapply(data_fear_trial, function(x) select(x, -trial))


cs_sum_trial <- lapply(data_fear_trial, function(x) apply(x, 2, summary))
cs_sd_trial <- lapply(data_fear_trial, function(x) apply(x, 2, sd))
cs_summ_trial <- vector("list", 8)
for (i in 1:8) {
    cs_summ_trial[[i]] <- rbind(cs_sum_trial[[i]], cs_sd_trial[[i]])
    rownames(cs_summ_trial[[i]]) <-
        c("min", "1stQ", "med", "mean", "3rdQ", "max", "sd")
}

names(cs_summ_trial) <- paste("trial", 1:8, sep = "_")
names(data_fear_trial) <- paste("trial", 1:8, sep = "_")

cs_summ_trial
# cs_var_name_no_stim <- c("Base Level",
#                          "Latency",
#                          "Amplitude",
#                          "Rise Time",
#                          "Reaction Size",
#                          "Onset")

for (k in seq_along(names(data_fear_trial[[1]]))) {
    par(mfrow = c(2, 4), mar = c(4, 4, 2, 1))
    lapply(1:8, function(x) hist(data_fear_trial[[x]][[k]],
                                 main = names(data_fear_trial)[x],
                                 xlab = cs_var_name[k], las = 1))
}

cond_levels <- levels(data$condition)

cs_cond_trial_lst <- vector("list", length(cond_vec))

for (j in seq_along(cond_levels)) {
    data_cond <- data |> 
        filter(condition == cond_levels[j]) |> 
        filter(run != "learn") |> 
        select(-c(id, run, condition, cs_stim_time))
    
    data_cond_trial <- data_cond %>% split(.$trial)
    data_cond_trial <- lapply(data_cond_trial, function(x) select(x, -trial))
    
    
    cs_sum_trial <- lapply(data_fear_trial, function(x) apply(x, 2, summary))
    cs_sd_trial <- lapply(data_fear_trial, function(x) apply(x, 2, sd))
    cs_summ_trial <- vector("list", 8)
    for (i in 1:8) {
        cs_summ_trial[[i]] <- rbind(cs_sum_trial[[i]], cs_sd_trial[[i]])
        rownames(cs_summ_trial[[i]]) <-
            c("min", "1stQ", "med", "mean", "3rdQ", "max", "sd")
    }
    
    names(cs_summ_trial) <- paste("trial", 1:8, sep = "_")
    names(data_cond_trial) <- paste("trial", 1:8, sep = "_")
    
    cs_cond_trial_lst[[j]] <- cs_summ_trial
    par(mfrow = c(2, 4), mar = c(4, 4, 2, 1))
    for (k in seq_along(names(data_cond_trial[[1]]))) {
        lapply(1:8, function(x) hist(data_cond_trial[[x]][[k]],
                                     main = paste(names(data_cond_trial)[x], 
                                                  cond_levels[j]),
                                     xlab = cs_var_name_no_stim[k], las = 1,
                                     font.lab = 2))
    }
}



