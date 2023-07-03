source("R/functions.R")

# The data set is from https://data.world/hxchua/covid-19-singapore
# https://docs.google.com/spreadsheets/d/1gFTNs_GtnTIyyVWXmsQxwdZpGbyicZM2HJcXvCf4b3k/edit#gid=0

dt_covid <- fread("data/Covid-19 SG - Sheet1.csv") %>% clean_names

# dt_covid$date %>% class
dt_covid %>%
  melt(id = "date") %>% .[variable %in% c(
    "daily_confirmed",
    "daily_local_transmission",
    "local_cases_residing_in_dorms_moh_report",
    "local_cases_not_residing_in_doms_moh_report"
  )] %>%
ggplot() + geom_line(aes(date, as.numeric(value), color = variable))

# melt(id.vars = "date", measure.vars = c("daily_confirmed", 
#                                         "daily_local_transmission", 
#                                         "local_cases_residing_in_dorms_moh_report",
#                                         "local_cases_not_residing_in_doms_moh_report",
# )

dt_covid[date > ymd("2021-06-15") & date < ymd("2021-08-20")] %>%
  .[, c(
    "date",
    "daily_confirmed",
    "daily_local_transmission",
    "local_cases_residing_in_dorms_moh_report",
    "local_cases_not_residing_in_doms_moh_report",
    "daily_imported"
  )] %>%
  melt(id = "date",
       variable.name = "case_type",
       value.name = "case_num") %>%
  ggplot() + geom_line(aes(date, case_num, color = case_type)) +
  geom_vline(xintercept = ymd("2021-07-16"), linetype ="dashed")+
  ylab("Daily cases")

# dt_covid_2 <- copy(dt_covid)[date > ymd("2021-06-15") & date < ymd("2021-08-20")]

copy(dt_covid) %>% #[date > ymd("2021-06-15") & date < ymd("2021-06-15")] %>%
  .[, c(
    "date",
    # "daily_confirmed",
    # "daily_local_transmission",
    "local_cases_residing_in_dorms_moh_report",
    "local_cases_not_residing_in_doms_moh_report",
    "daily_imported"
  )] %>%
  melt(id = "date",
       variable.name = "case_type",
       value.name = "case_num") %>%
  .[case_type == "local_cases_residing_in_dorms_moh_report", case_type := "Dorm"] %>%
  .[case_type == "local_cases_not_residing_in_doms_moh_report", case_type := "Community"] %>%
  .[case_type == "daily_imported", case_type := "Imported"] %>%
  ggplot() + 
  geom_area(aes(date, case_num, fill = case_type), position = "stack") +
  # geom_line(data = dt_covid, aes(date, daily_confirmed)) +
  geom_vline(xintercept = ymd("2021-07-16"), linetype ="dashed") +
  scale_fill_manual("Case type", values = nea_color) +
  coord_cartesian(xlim = ymd(c("2021-06-15", "2021-08-18")), ylim = c(0,200)) +
  ylab("Daily cases") +
  xlab("Date in 2021") +
  LJYtheme_basic
