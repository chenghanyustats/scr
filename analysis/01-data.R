## /analysis/01-data.R

## load packages
library(tidyverse)
library(tidyselect)
library(haven)
library(here)
library(hablar)
# remotes::install_github("Tazinho/snakecase")
library(snakecase)

## load data (make sure the two are identical)
data_sav <- haven::read_sav("./data/raw/2024-07-16_FSARS_EDA_Long_V2_101-269.sav")
data_xlsx <- readxl::read_xlsx("./data/raw/2024-07-16_FSARS_EDA_Long_V2_101-269.xlsx")


## colname to snake_case
colnames(data_xlsx) <- snakecase::to_snake_case(colnames(data_xlsx))
length(unique(data_xlsx[["id"]]))


## convert condition to factor?? or rename values?
# fear = 5, reward = 4, fear + neutral = 3, reward + neutral = 2, and neutral = 1.
# level = c()
# "Fear" "Fear.Safety" "Reward" "Reward.Safety" "Safety"
# convert trial to integer

## change condition values to snake case
cond_vec <- data_xlsx$condition

for (ch in unique(cond_vec)) {
    cond_vec[cond_vec == ch] <- to_snake_case(ch)
}

data_xlsx$condition <- cond_vec



# change variable type
data_change_type <- data_xlsx |> 
    hablar::convert(chr(id),
                    int(trial),
                    fct(condition, 
                        .args = list(levels = c("safety", "reward_safety", 
                                              "fear_safety", "reward", "fear"))))


not_160_trial_id <- names(which(table(data_change_type[["id"]]) != 160))

data_not_160 <- data_change_type |> 
    filter(id %in% not_160_trial_id)

table(data_not_160$id)
idx <- 1:8

data_no_repeat <- tibble()

for (i in seq_along(not_160_trial_id)) {
    data_id <- data_not_160 |> filter(id == not_160_trial_id[i])
    for (j in seq_along(unique(data_id$run))) {
        data_id_run <- data_id |> filter(run == unique(data_id$run)[j])
        for (k in seq_along(unique(data_id_run$condition))) {
            data_id_run_cond <- data_id_run |> 
                filter(condition == unique(data_id_run$condition)[k])
            repeated <- idx[table(data_id_run_cond$trial) > 1]
            data_repeated <- data_id_run_cond |> 
                filter(trial %in% repeated) |> 
                filter(if_all(1:11, complete.cases))
            data_nonrepeated <- data_id_run_cond |> 
                filter(trial %in% setdiff(idx, repeated))
            data_clean <- bind_rows(data_repeated, data_nonrepeated) |> 
                arrange(trial)
            data_no_repeat <- bind_rows(data_no_repeat, data_clean)
        }
    }
}

`%!in%` = Negate(`%in%`)

data_160 <- data_change_type |> 
    filter(id %!in% not_160_trial_id)

data_no_repeat_all <- bind_rows(data_160, data_no_repeat) |> arrange(id)

data_combine_ext <- data_no_repeat_all |> 
    mutate(run = recode(run,
                        "Learning" = "learn",
                        "Run1" = "run1",
                        "Run2" = "run2",
                        "Run3" = "run3",
                        "Extincti" = "run3"))

table(data_combine_ext[["run"]])

## data without missing values
data_no_missing <- data_combine_ext[complete.cases(data_combine_ext), ]

length(unique(data_no_missing$id))

## id 238 and 239 have no physiological response, and have no CS-related measurements
setdiff(unique(data_xlsx$id), unique(data_no_missing$id))


save(data_xlsx, file = here("data", "clean", "data_xlsx.RData"))
# save(data_change_type, file = here("data", "clean", "data_change_type.RData"))
save(data_no_repeat_all, file = here("data", "clean", "data_1_no_repeat_all.RData"))
save(data_combine_ext, file = here("data", "clean", "data_2_combine_ext.RData"))
save(data_no_missing, file = here("data", "clean", "data_3_no_missing.RData"))

# Trial effects are particularly interesting to me – 
# changes in the responses over trial numbers. But open to other ways to visualize the data.



