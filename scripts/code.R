# Load required libraries
library(tidyr)
library(dplyr)
library(janitor)
library(ggforce)
library(ggplot2)
library(tidyverse)
library(rpart)
library(rpart.plot)
library(lubridate)
library(patchwork)


# Preview and clean column names
dam_data <- read_csv("PROJECTS/PREDICT_PREMIUM/CASE_STUDY/data/raw/dam_data.csv")
summary(dam_data)
names(dam_data) <- make_clean_names(names(dam_data))

# Convert dates and calculate intervals
dam_data <- dam_data %>%
  mutate(
    last_inspection_date = dmy(last_inspection_date),
    assessment_date = dmy(assessment_date),
    months_since_last_inspection = interval(last_inspection_date, ymd("2024-01-01")) %/% months(1),
    months_since_assessment = interval(assessment_date, ymd("2024-01-01")) %/% months(1)
  ) %>%
  select(-last_inspection_date, -assessment_date)

# Clean 'years_modified' column
dam_data$years_modified_clean <- substr(dam_data$years_modified, 1, 4)
is_year <- grepl("^\\d{4}$", dam_data$years_modified_clean)

if (mean(is_year, na.rm = TRUE) > 0.8) {
  dam_data$years_modified <- as.integer(dam_data$years_modified_clean)
} else {
  dam_data$years_modified <- NULL
}
dam_data$years_modified_clean <- NULL

# Split dataset by region
navaldia <- dam_data %>% filter(region == "Navaldia")
lyndrassia <- dam_data %>% filter(region == "Lyndrassia")
lumevale  <- dam_data %>% filter(region == "Flumevale")
make_hist = function (df) {
  df %>% 
    ggplot(aes(x = loss_given_failure_prop_qm + 
                 loss_given_failure_liab_qm + 
                 loss_given_failure_bi_qm)) +
    geom_histogram(binwidth = 10, fill = "lightsteelblue") +
    labs(
      title = deparse(substitute(df)),
      x = "Total Loss Given Failure (in QM units)",
      y = "Count"
    ) +
    theme_minimal() +
    theme(
      text = element_text(family = "serif")
    )
}

make_hist(lumevale)
make_hist(lyndrassia)
make_hist(navaldia)

design <- "
                  ABC
                "

layout_plot <- make_hist(lumevale) +
  make_hist(lyndrassia) +
  make_hist(navaldia) +
  plot_layout(design = design)

#chia cụm
# Hàm vẽ và lưu cây quyết định
plot_and_save_tree <- function(data, target, region, output_dir) {
  # Xác định tên file
  filename <- paste0(output_dir, "/", region, "_", target, "_tree.png")
  
  # Tạo công thức loại trừ các biến không cần thiết
  exclude_vars <- c("loss_given_failure_bi_qm", 
                    "loss_given_failure_prop_qm", 
                    "loss_given_failure_liab_qm", 
                    "probability_of_failure", 
                    "id")
  exclude_vars <- setdiff(exclude_vars, target)
  formula <- as.formula(
    paste(target, "~ . -", paste(exclude_vars, collapse = " - "))
  )
  
  # Huấn luyện model
  model <- rpart(formula, data = data, method = "anova")
  
  # Xuất file ảnh
  png(filename, width = 1000, height = 800)
  rpart.plot(model, type = 2, extra = 100, fallen.leaves = TRUE, cex = 0.7)
  dev.off()
}

# Áp dụng cho tất cả vùng và target
regions <- list(lumevale = lumevale, lyndrassia = lyndrassia, navaldia = navaldia)
targets <- c("loss_given_failure_bi_qm", 
             "loss_given_failure_prop_qm", 
             "loss_given_failure_liab_qm")
output_dir <- "C:/Users/ADMIN/OneDrive/Tài liệu/PROJECTS/PREDICT_PREMIUM/CASE_STUDY/output/figures"

for (region_name in names(regions)) {
  for (target in targets) {
    plot_and_save_tree(regions[[region_name]], target, region_name, output_dir)
  }
}

# Add risk group indicators for each region
add_loss_groups <- function(data, region_name) {
  data %>%
    mutate(
      group_loss_bi = ifelse(primary_purpose %in% switch(region_name,
                                                         "lumevale" = c("Irrigation", "Recreation", "Water Supply"),
                                                         "lyndrassia" = c("Recreation"),
                                                         "navaldia" = c("Recreation")), 0, 1),
      group_loss_prop = ifelse(surface_km2 >= 0.24, 0, 1),
      group_loss_liab = ifelse(switch(region_name,
                                      "lumevale" = distance_to_nearest_city_km >= 5,
                                      "lyndrassia" = distance_to_nearest_city_km >= 5,
                                      "navaldia" = hazard %in% c("Significant", "Low")), 0, 1)
    )
}

group_stats <- function(data) {
  stat_summary <- function(var, group_var) {
    data %>%
      group_by(across(all_of(group_var))) %>%
      select(id, !!sym(var), !!sym(group_var)) %>%
      drop_na() %>%
      summarise(
        mean = mean(!!sym(var)),
        sd = sd(!!sym(var)),
        n = n(),
        .groups = "drop"
      )
  }
  
  list(
    bi = stat_summary("loss_given_failure_bi_qm", "group_loss_bi"),
    prop = stat_summary("loss_given_failure_prop_qm", "group_loss_prop"),
    liab = stat_summary("loss_given_failure_liab_qm", "group_loss_liab")
  )
}

# Apply grouping and compute stats
lumevale <- add_loss_groups(lumevale, "lumevale")
lyndrassia <- add_loss_groups(lyndrassia, "lyndrassia")
navaldia <- add_loss_groups(navaldia, "navaldia")

lumevale_stats <- group_stats(lumevale)
lyndrassia_stats <- group_stats(lyndrassia)
navaldia_stats <- group_stats(navaldia)

# Premium calculation with hypothetical risk-reduction policies
stat <- function(df, stats, region_name) {
  df %>%
    replace_na(list(
      group_loss_bi = 0,
      group_loss_prop = 0,
      group_loss_liab = 0
    )) %>%
    group_by(across(starts_with("group_loss"))) %>%
    summarise(n = n(), .groups = "drop") %>%
    mutate(
      mean_bi = stats$bi$mean[group_loss_bi + 1],
      sd_bi = stats$bi$sd[group_loss_bi + 1],
      mean_prop = stats$prop$mean[group_loss_prop + 1],
      sd_prop = stats$prop$sd[group_loss_prop + 1],
      mean_liab = stats$liab$mean[group_loss_liab + 1],
      sd_liab = stats$liab$sd[group_loss_liab + 1]
    ) %>%
    mutate(
      mean_loss = rowSums(across(starts_with("mean_"))),
      var_loss = rowSums(across(starts_with("sd_"))^2),
      mean_loss_square = mean_loss^2 + var_loss,
      prob = case_when(
        region_name == "lumevale" ~ 0.06,
        region_name == "lyndrassia" ~ 0.069,
        region_name == "navaldia" ~ 0.091,
        TRUE ~ NA_real_
      )
    ) %>%
    select(starts_with("group_loss"), n, mean_loss, mean_loss_square, prob) %>%
    mutate(P = (1.645 * (sqrt(n * (prob * mean_loss_square - (prob * mean_loss)^2)) + n * prob * mean_loss)) / n)
}

# Calculate regional premiums
lumevale_premium   <- stat(lumevale, lumevale_stats, "lumevale")
lyndrassia_premium <- stat(lyndrassia, lyndrassia_stats, "lyndrassia")
navaldia_premium   <- stat(navaldia, navaldia_stats, "navaldia")
