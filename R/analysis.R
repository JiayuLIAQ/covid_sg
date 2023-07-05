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

dt_jfp_cases <- fread("documents/JFP cluster/JFP_cases_development.csv")

dt_jfp_cases[, date := dmy(date)]
dt_jfp_cases[, id := seq.int(1:.N), by = date]
dt_jfp_cases <- dt_jfp_cases[id == 1]
dt_jfp_cases[, cases_jfp := cases - shift(cases)]
dt_jfp_cases[1, cases_jfp := 7]

dt_jfp_cases[dt_covid, on = "date"] %>% 
  .[is.na(cases_jfp), cases_jfp := 0] %>%
  .[, non_jfp_cases := local_cases_not_residing_in_doms_moh_report- cases_jfp] %>% #[date > ymd("2021-06-15") & date < ymd("2021-06-15")] %>%
  .[, c(
    "date",
    "cases_jfp",
    "non_jfp_cases",
    "local_cases_residing_in_dorms_moh_report",
    # "local_cases_not_residing_in_doms_moh_report",
    "daily_imported"
  )] %>%
  melt(id = "date",
       variable.name = "case_type",
       value.name = "case_num") %>%
  .[case_type == "local_cases_residing_in_dorms_moh_report", case_type := "Dormitory"] %>%
  .[case_type == "non_jfp_cases", case_type := "Community (not JFP cluster)"] %>%
  .[case_type == "cases_jfp", case_type := "Community (JFP cluster)"] %>%
  .[case_type == "daily_imported", case_type := "Imported"] %>%
  .[, case_type := factor(case_type, levels = c("Dormitory",
                                                "Imported",
                                                "Community (not JFP cluster)",
                                                "Community (JFP cluster)"
                                                ) )] %>%
  ggplot() + 
  geom_col(aes(date, case_num, fill = case_type), position = "stack") +
  # geom_line(data = dt_covid, aes(date, daily_confirmed)) +
  geom_vline(xintercept = ymd(c("2021-07-16", "2021-07-02", "2021-08-14") ), linetype ="dashed") +
  scale_fill_manual("Case type", values = c( "#bdbdbd", "#58B6DC","#BED73B", "#F58A06")) +
  coord_cartesian(xlim = ymd(c("2021-06-25", "2021-08-19")), ylim = c(0,200)) +
  # ylab("Daily cases") +
  # xlab("Date in 2021") +
  scale_y_continuous("Daily cases", expand = c(0,0)) +
  scale_x_date("Date in 2021", breaks = ymd(c("2021-07-16", "2021-07-02", "2021-07-31", "2021-08-14")), date_labels = "%b %d") +
  LJYtheme_basic +
  guides(fill=guide_legend(nrow=2,byrow=TRUE)) +
  theme(legend.position = "top")

ggsave("plots/JFP_clusters.pdf", height = 5, width = 8)
ggsave("plots/JFP_clusters.png", height = 5, width = 6)
