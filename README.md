# Dam Risk Assessment Using Combined Actuarial Approaches

## 1. Introduction

Accurate risk assessment of dam infrastructure is crucial for insurance pricing and public safety management. This study employs statistical modeling and actuarial techniques to evaluate dam failure risks across three regions (Navaldia, Lyndrassia, and Flumevale) based on structural characteristics and environmental factors.

## 2. Data Description

### 2.1 Dataset Overview
The dataset contains 20,806 dam records from the Tarrodan Dam Authority (TDA) with comprehensive structural, operational, and risk assessment characteristics. Data was collected through regular inspections and assessments conducted by TDA engineers.

### 2.2 Feature Dictionary

| Feature Name                  | Type        | Description                                                                 | Values/Range               | Notes                          |
|-------------------------------|-------------|-----------------------------------------------------------------------------|----------------------------|--------------------------------|
| **ID**                        | Categorical | Unique TDA identification code                                             | SOA00072-SOA99999          | Primary key                    |
| **Region**                    | Categorical | Geographical location                                                       | Flumevale, Lyndrassia, Navaldia |                                |
| **Regulated Dam**             | Binary      | Regulatory status                                                          | Yes/No                     |                                |
| **Primary Purpose**           | Categorical | Dominant usage                                                             | 12 categories (Recreation, Irrigation, etc.) |                                |
| **Primary Type**              | Categorical | Construction type                                                          | 12 types (Earth, Concrete, etc.) |                                |
| **Height (m)**                | Numerical   | Vertical structure height                                                   | Mean: 11.3m                | Foundation to top              |
| **Length (km)**               | Numerical   | Crest length                                                               | Mean: 0.4km                |                                |
| **Volume (m³)**               | Numerical   | Construction material volume                                               | Mean: 211,241m³            |                                |
| **Year Completed**            | Numerical   | Initial construction year                                                  | 1748-2023                  |                                |
| **Years Modified**            | Categorical | Major modification years                                                   | Alphanumeric (1987, 2012H) | S=Structural, H=Hydraulic      |
| **Surface (km²)**             | Numerical   | Reservoir surface area                                                     | Mean: 2.4km²               | Normal retention level         |
| **Drainage (km²)**            | Numerical   | Watershed area                                                             | Mean: 1,976km²             |                                |
| **Spillway**                  | Categorical | Flood control system                                                       | Controlled/Uncontrolled     |                                |
| **Last Inspection Date**      | Date        | Most recent safety inspection                                              | DD-MM-YYYY                 |                                |
| **Inspection Frequency**      | Numerical   | Scheduled inspection interval                                              | Mean: 2.12 years           |                                |
| **Distance to Nearest City**  | Numerical   | Proximity to urban areas                                                   | Mean: 19.7km               | From spillway                  |
| **Hazard**                    | Categorical | Failure consequence classification                                         | Low/High/Significant/Undetermined |                                |
| **Assessment**                | Categorical | Structural condition rating                                                | 6 levels (Satisfactory to Unsatisfactory) |                                |
| **Assessment Date**           | Date        | Most recent condition evaluation                                           | DD-MM-YYYY                 |                                |
| **Probability of Failure**    | Numerical   | 10-year failure risk                                                       | Mean: 0.47                 |                                |
| **Loss given failure - prop** | Numerical   | Structural repair costs (millions Qalkoons)                                | Mean: 132                  | Property damage                |
| **Loss given failure - liab** | Numerical   | Third-party liability costs (millions Qalkoons)                            | Mean: 185                  | Environmental/social impact    |
| **Loss given failure - BI**   | Numerical   | Annual business interruption costs (millions Qalkoons)                     | Mean: 4.5                  | Economic impact                |

### 2.3 Key Data Characteristics

1. **Temporal Coverage**:
   - Construction years span 275 years (1748-2023)
   - Includes both historical and modern dam engineering

2. **Structural Diversity**:
   - 12 distinct construction types
   - Wide range of sizes (0.4km to 12.8km length)

3. **Risk Metrics**:
   - Three distinct loss quantifications
   - Combined probability-impact assessment framework

4. **Geospatial Factors**:
   - Detailed proximity measurements
   - Regional hazard profiles

### 2.4 Data Quality Notes

- **Years Modified** field contains alphanumeric codes indicating modification type
- **Assessment** field includes "Not Rated" (12.4%) and "Not Available" (8.7%) values
- **Hazard** classification missing for 3.2% of records ("Undetermined")
- All monetary values in Qalkoons (Tarrodan currency)

## 3. Descriptive Statistics

### 3.1 Categorical Variables

| Variable              | Type        | Count   | Levels/Notes                          |
|-----------------------|-------------|---------|---------------------------------------|
| **id**                | Character   | 20,806  | Unique identifier (SOA00072-SOA99999) |
| **region**            | Character   | 20,806  | 3 regions: Flumevale, Lyndrassia, Navaldia |
| **regulated_dam**     | Character   | 20,806  | Binary (Yes/No)                       |
| **primary_purpose**   | Character   | 20,806  | 12 categories                         |
| **primary_type**      | Character   | 20,806  | 12 construction types                 |
| **spillway**          | Character   | 20,806  | Controlled/Uncontrolled               |
| **hazard**            | Character   | 20,806  | 4 levels: Low, High, Significant, Undetermined |
| **assessment**        | Character   | 20,806  | 6 condition ratings                  |

### 3.2 Numerical Variables

| Variable                      | Min      | 1st Qu.  | Median   | Mean     | 3rd Qu.  | Max        | NA's   |
|-------------------------------|----------|----------|----------|----------|----------|------------|--------|
| **height_m**                  | 0.000    | 6.545    | 9.015    | 11.263   | 11.923   | 278.646    | 0      |
| **length_km**                 | 0.000    | 0.125    | 0.207    | 0.401    | 0.395    | 156.870    | 2,671  |
| **volume_m3**                 | 0        | 0        | 17,337   | 211,241  | 61,538   | 125,628,000| 9,678  |
| **year_completed**            | 1,748    | 1,952    | 1,964    | 1,961    | 1,974    | 2,023      | 1,384  |
| **surface_km2**               | 0.000    | 0.041    | 0.097    | 2.455    | 0.242    | 3,143.663  | 2,798  |
| **drainage_km2**              | 0.0      | 0.0      | 16.0     | 1,976.3  | 367.5    | 1,899,088.2| 2,463  |
| **inspection_frequency**      | 0.000    | 0.000    | 1.000    | 2.096    | 5.000    | 10.000     | 8,116  |
| **distance_to_nearest_city_km**| 0.00    | 1.63     | 10.14    | 19.80    | 27.98    | 231.60     | 10,229 |
| **probability_of_failure**    | 0.0027   | 0.0759   | 0.0933   | 0.0939   | 0.1108   | 0.1966     | 0      |
| **loss_given_failure_prop_qm**| 4.8      | 16.4     | 30.0     | 123.1    | 46.3     | 952.7      | 7      |
| **loss_given_failure_liab_qm**| 4.8      | 18.0     | 167.6    | 253.7    | 409.1    | 953.9      | 12     |
| **loss_given_failure_bi_qm**  | 1.00     | 6.10     | 9.30     | 21.07    | 33.50    | 95.40      | 10,730 |

### 3.3 Date Variables

| Variable                 | Type      | Count   | Format     | NA's |
|--------------------------|-----------|---------|------------|------|
| **last_inspection_date** | Character | 20,806  | DD-MM-YYYY | 0    |
| **assessment_date**      | Character | 20,806  | DD-MM-YYYY | 0    |

### 3.4 Key Observations

Based on the descriptive statistics above, several important patterns and data quality issues emerge that could influence risk modeling and actuarial analysis:

#### A. Missing Data Patterns

- **Significant missing values**: Several critical variables show high levels of missingness. For example, `length_km` (12.8%), `volume_m3` (46.5%), `surface_km2` (13.4%), and `drainage_km2` (11.8%) all have substantial gaps. Notably, `inspection_frequency` is missing in nearly 39% of records, and `loss_given_failure_bi_qm` has over 50% missing entries. These missing values must be carefully addressed using methods such as *multiple imputation*, exclusion of incomplete records, or incorporating models that can handle missingness natively.

- **Alphanumeric formatting**: The `years_modified` field includes both numeric and character components (e.g., "2012H", "1987S"), which should be split into separate variables: modification year and modification type (Structural vs. Hydraulic) for proper analysis.

#### B. Skewed Distributions and Outliers

- **Financial loss variables** (`loss_given_failure_prop_qm`, `loss_given_failure_liab_qm`, and especially `loss_given_failure_bi_qm`) exhibit highly right-skewed distributions. The significant difference between means and medians suggests the presence of *extreme outliers*, likely representing rare but catastrophic dam failures. These heavy-tailed distributions should be modeled with appropriate techniques (e.g., log-transformation, Pareto models, or sub-exponential distributions in actuarial contexts).

- **Surface area and volume** also show extreme values (e.g., max surface area = 3,143.7 km²), implying the presence of a few very large dams. These may distort average-based metrics and should be treated with caution.

#### C. Structural Diversity and Range

- **Wide engineering heterogeneity**: Dams vary greatly in size and age, with construction years ranging from *1748 to 2023*. This indicates that both historical and modern engineering standards are represented, which may influence failure probability or loss severity. It also justifies incorporating *year completed* or *dam age* into risk models.

- **Diverse construction types and purposes**: With 12 different dam types and 12 primary purposes, this dataset reflects rich structural and functional variability. This supports the use of *segmented modeling* or interaction terms in predictive models.

#### D. Regional and Geospatial Relevance

- **Three distinct regions** (Flumevale, Lyndrassia, Navaldia) allow for geographic segmentation. These may differ in environmental exposure (e.g., rainfall, seismicity), inspection practices, or dam standards, and region should be considered as a key stratifying variable.

- **Proximity to urban centers** (`distance_to_nearest_city_km`) ranges widely (0–231.6 km). This could be an important proxy for potential third-party liability or social impact in case of failure.

#### Summary of Key Patterns

1. **Missing Data**:
   - Volume measurements missing for 46.5% of dams
   - Business interruption loss data missing for 51.6% of records
   - Distance to nearest city missing for 49.2% of cases

2. **Distributions**:
   - Dam heights show right-skewed distribution (mean > median)
   - Surface areas have extreme outliers (max = 3,143 km²)
   - Failure probabilities cluster around 9–11% range

3. **Temporal Patterns**:
   - Construction peaked in 1960s (median year = 1964)
   - Most dams (75%) built between 1952–1974

4. **Risk Metrics**:
   - Liability losses show widest variation (4.8–953.9M Qalkoons)
   - Property damage losses average higher than business interruption

---

## 3.5 Data Type Conversion and Temporal Feature Engineering

\`\`\` {r my-code, echo = TRUE}

``` 
# Convert dates and calculate intervals

# The variables `last_inspection_date` and `assessment_date` were originally stored as strings in the "DD-MM-YYYY" format. 
# To enable temporal calculations, we first convert them to proper Date objects using the `dmy()` function.
# This is crucial for accurately computing durations between dates, such as time since the last inspection.

dam_data <- dam_data %>%
  mutate(
    last_inspection_date = dmy(last_inspection_date),
    assessment_date = dmy(assessment_date),

    # After conversion, we calculate how many months have passed since these dates,
    # using a fixed reference point (2024-01-01).
    months_since_last_inspection = interval(last_inspection_date, ymd("2024-01-01")) %/% months(1),
    months_since_assessment = interval(assessment_date, ymd("2024-01-01")) %/% months(1)
  ) %>%
  # The original date columns are no longer needed after computing the intervals, so we remove them.
  select(-last_inspection_date, -assessment_date)

# Clean 'years_modified' column

# The 'years_modified' column includes mixed formats, such as "1987S" or "2012H", where suffix letters indicate modification type.
# To extract usable year data, we isolate the first four characters.
dam_data$years_modified_clean <- substr(dam_data$years_modified, 1, 4)

# We check whether these extracted values match the pattern of a valid 4-digit year.
is_year <- grepl("^\\d{4}$", dam_data$years_modified_clean)

# If more than 80% of the values are valid years, we convert the column to integer format for numerical analysis.
# Otherwise, we discard the field entirely to avoid including noisy or inconsistent data.
if (mean(is_year, na.rm = TRUE) > 0.8) {
  dam_data$years_modified <- as.integer(dam_data$years_modified_clean)
} else {
  dam_data$years_modified <- NULL
}

# Clean up the temporary column used for checking
dam_data$years_modified_clean <- NULL

```
## 3.6. Regional Distributions


Each region may have different economic conditions and risk tolerance.
In insurance pricing, it's important not only to assess technical risk but also to account for the population’s ability to pay.
Therefore, we split the dataset by regions for separate analysis and premium estimation.

Filter dataset into three regional subsets:

\`\`\` {r my-code, echo = TRUE}

```   
navaldia   <- dam_data %>% filter(region == "Navaldia")    # Region: Navaldia
lyndrassia <- dam_data %>% filter(region == "Lyndrassia")  # Region: Lyndrassia
lumevale   <- dam_data %>% filter(region == "Flumevale")   # Region: Flumevale

```

These subsets will later be analyzed separately to understand their specific risk characteristics and socio-economic context.
From the distribution plot of estimated total losses (calculated as the sum of `liab`, `bi`, and `prop`) by region, we can observe clear differences among the regions:

![Total Loss by Region]("C:/Users/ADMIN/OneDrive/Tài liệu/PROJECTS/PREDICT_PREMIUM/CASE_STUDY/output/figures/total_loss_distribution.png")

- **Lumevale** shows a more dispersed distribution compared to the other two regions, indicating greater variability in total losses. This may reflect uneven natural disaster risks or diverse geographical and economic conditions within the region.
- **Navaldia** exhibits a more concentrated distribution, suggesting that total losses are more stable and closer to the mean. This could facilitate easier estimation and pricing of insurance premiums.
- **Lyndrassia** lies in between, with a moderate level of dispersion, indicating an average level of risk — not highly volatile but not entirely stable either.

These differences provide a basis for considering region-specific pricing or the application of distinct risk models to better reflect the actual characteristics of each region.


## 4. Pricing Procedure

### 4.1. Risk Clustering by Region

Given the substantial amount of missing data in the `loss_given_failure_bi_qm` column — a crucial indicator for evaluating risk — it is not advisable to exclude this variable entirely from the analysis. Instead, we can explore alternative predictors that may correlate with or help estimate the missing values. A practical approach is to use a decision tree algorithm to model and predict these missing values based on other available features.

This method can also be applied to other important risk-related variables such as `loss_given_failure_prop_qm`, `loss_given_failure_liab_qm`, and `probability_of_failure`. By doing so, we can create more refined regional clusters of dams that share similar risk profiles. These clusters allow us to better understand the key factors that influence risk and to propose targeted strategies for risk reduction or premium adjustment within each sub-region.

```r
# Function to plot and save a decision tree
plot_and_save_tree <- function(data, target, region, output_dir) {
  filename <- paste0(output_dir, "/", region, "_", target, "_tree.png")
  
  # Define variables to exclude (except the current target)
  exclude_vars <- c("loss_given_failure_bi_qm", 
                    "loss_given_failure_prop_qm", 
                    "loss_given_failure_liab_qm", 
                    "probability_of_failure", 
                    "id")
  exclude_vars <- setdiff(exclude_vars, target)
  
  # Construct model formula
  formula <- as.formula(
    paste(target, "~ . -", paste(exclude_vars, collapse = " - "))
  )
  
  # Fit decision tree model
  model <- rpart(formula, data = data, method = "anova")
  
  # Save the tree as a PNG image
  png(filename, width = 1000, height = 800)
  rpart.plot(model, type = 2, extra = 100, fallen.leaves = TRUE, cex = 0.7)
  dev.off()
}

# Define regions and targets
regions <- list(lumevale = lumevale, lyndrassia = lyndrassia, navaldia = navaldia)
targets <- c("loss_given_failure_bi_qm", 
             "loss_given_failure_prop_qm", 
             "loss_given_failure_liab_qm")
output_dir <- "C:/Users/ADMIN/OneDrive/Tài liệu/PROJECTS/PREDICT_PREMIUM/CASE_STUDY/output/figures"

# Apply tree plotting for each region and target variable
for (region_name in names(regions)) {
  for (target in targets) {
    plot_and_save_tree(regions[[region_name]], target, region_name, output_dir)
  }
}
```

After applying decision tree models to identify risk patterns, we developed a region-specific rule-based classification to group dams into different risk levels. The logic is implemented in the function `add_loss_groups`, which assigns binary risk indicators (`0 = low risk`, `1 = high risk`) for three loss types: bodily injury (BI), property (PROP), and liability (LIAB), based on features most relevant to each region.

### Table: Criteria for Risk Group Classification by Region

| **Region**    | **Risk Type**      | **Criteria for Group 0 (Low Risk)**                             | **Criteria for Group 1 (High Risk)**                        |
|---------------|--------------------|------------------------------------------------------------------|--------------------------------------------------------------|
| **Lumevale**  | Bodily Injury (BI) | `primary_purpose` in {"Irrigation", "Recreation", "Water Supply"} | All other `primary_purpose` values                          |
|               | Property (PROP)    | `surface_km2` >= 0.24                                            | `surface_km2` < 0.24                                        |
|               | Liability (LIAB)   | `distance_to_nearest_city_km` >= 5                              | `distance_to_nearest_city_km` < 5                           |
| **Lyndrassia**| Bodily Injury (BI) | `primary_purpose` == "Recreation"                                | Other `primary_purpose` values                              |
|               | Property (PROP)    | `surface_km2` >= 0.24                                            | `surface_km2` < 0.24                                        |
|               | Liability (LIAB)   | `distance_to_nearest_city_km` >= 5                              | `distance_to_nearest_city_km` < 5                           |
| **Navaldia**  | Bodily Injury (BI) | `primary_purpose` == "Recreation"                                | Other `primary_purpose` values                              |
|               | Property (PROP)    | `surface_km2` >= 0.24                                            | `surface_km2` < 0.24                                        |
|               | Liability (LIAB)   | `hazard` in {"Significant", "Low"}                              | `hazard` == "High" or other                                 |

---

### 4.2. Premium Calculation Process (continued)

Among risk-related variables, `probability_of_failure` appears to be highly sensitive to maintenance frequency — a factor that is under operator control. Therefore, we propose adjusting this probability based on a policy that incentivizes regular maintenance.

We assume that higher maintenance frequency leads to reduced failure probability. Based on this assumption, we adjust `probability_of_failure` by region under the policy scenario.

\`\`\` {r my-code, echo = TRUE}

``` 
# Function to compute premium with adjusted probability based on maintenance policy
stat_with_maintenance <- function(df, stats, region_name) {
  df %>%
    replace_na(list(
      group_loss_bi = 0,
      group_loss_prop = 0,
      group_loss_liab = 0,
      probability_of_failure = 0
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
      adjusted_prob = case_when(
        region_name == "lumevale" & df$maintenance_frequency > 0.8 ~ 0.05,
        region_name == "lyndrassia" & df$maintenance_frequency > 0.8 ~ 0.06,
        region_name == "navaldia" & df$maintenance_frequency > 0.8 ~ 0.08,
        TRUE ~ prob
      )
    ) %>%
    mutate(
      P = (1.645 * (sqrt(n * (adjusted_prob * mean_loss_square - (adjusted_prob * mean_loss)^2)) + n * adjusted_prob * mean_loss)) / n
    )
}
```


Recalculate regional premiums under the maintenance policy scenario:

\`\`\` {r my-code, echo = TRUE}

``` 
lumevale_premium_adjusted   <- stat_with_maintenance(lumevale, lumevale_stats, "lumevale")
lyndrassia_premium_adjusted <- stat_with_maintenance(lyndrassia, lyndrassia_stats, "lyndrassia")
navaldia_premium_adjusted   <- stat_with_maintenance(navaldia, navaldia_stats, "navaldia")
```


**Risk Grouping Table for Lumevale**

| **Group** | **group_loss_bi** | **group_loss_prop** | **group_loss_liab** | **n** | **mean_loss** | **mean_loss_square** | **prob** | **P**  |
|-----------|-------------------|---------------------|---------------------|-------|---------------|----------------------|----------|--------|
| 1         | 0                 | 0                   | 0                   | 702   | 741.6726      | 623735.4             | 0.06     | 84.89182 |
| 2         | 0                 | 0                   | 1                   | 314   | 1022.3408     | 1168702.8            | 0.06     | 124.81906 |
| 3         | 0                 | 1                   | 0                   | 840   | 302.7689      | 106755.6             | 0.06     | 34.30725 |
| 4         | 0                 | 1                   | 1                   | 392   | 583.4372      | 405350.4             | 0.06     | 70.21188 |
| 5         | 1                 | 0                   | 0                   | 450   | 790.7674      | 698773.8             | 0.06     | 93.49488 |
| 6         | 1                 | 0                   | 1                   | 176   | 1071.4357     | 1271299.9            | 0.06     | 139.05602 |
| 7         | 1                 | 1                   | 0                   | 405   | 351.8638      | 138698.2             | 0.06     | 41.98327 |
| 8         | 1                 | 1                   | 1                   | 243   | 632.5320      | 464851.7             | 0.06     | 79.59346 |

| **Group** | **group_loss_bi** | **group_loss_prop** | **group_loss_liab** | **n**  | **mean_loss** | **mean_loss_square** | **prob** | **P**    |
|-----------|-------------------|---------------------|---------------------|--------|---------------|----------------------|----------|----------|
| 1         | 0                 | 0                   | 0                   | 195    | 654.5453      | 495950.09            | 0.069    | 95.42648 |
| 2         | 0                 | 0                   | 1                   | 121    | 959.9743      | 1036926.69           | 0.069    | 147.71708 |
| 3         | 0                 | 1                   | 0                   | 797    | 250.6678      | 75760.90             | 0.069    | 32.54265 |
| 4         | 0                 | 1                   | 1                   | 805    | 556.0968      | 370025.73            | 0.069    | 72.11289 |
| 5         | 1                 | 0                   | 0                   | 2413   | 675.1312      | 523589.22            | 0.069    | 82.80177 |
| 6         | 1                 | 0                   | 1                   | 537    | 980.5601      | 1077140.84           | 0.069    | 130.04563 |
| 7         | 1                 | 1                   | 0                   | 2816   | 271.2537      | 86771.71             | 0.069    | 33.11605 |
| 8         | 1                 | 1                   | 1                   | 722    | 576.6826      | 393611.56            | 0.069    | 75.24703 |

| **Group** | **group_loss_bi** | **group_loss_prop** | **group_loss_liab** | **n**  | **mean_loss** | **mean_loss_square** | **prob** | **P**    |
|-----------|-------------------|---------------------|---------------------|--------|---------------|----------------------|----------|----------|
| 1         | 0                 | 0                   | 0                   | 332    | 502.6854      | 327743.4             | 0.091    | 90.28396 |
| 2         | 0                 | 0                   | 1                   | 316    | 1048.7612     | 1204659.9            | 0.091    | 186.33292 |
| 3         | 0                 | 1                   | 0                   | 1302   | 109.6181      | 32990.9              | 0.091    | 18.86546 |
| 4         | 0                 | 1                   | 1                   | 362    | 655.6940      | 480618.3             | 0.091    | 115.48396 |
| 5         | 1                 | 0                   | 0                   | 943    | 529.9389      | 356262.1             | 0.091    | 88.62212 |
| 6         | 1                 | 0                   | 1                   | 862    | 1076.0148     | 1262943.7            | 0.091    | 179.25886 |
| 7         | 1                 | 1                   | 0                   | 3911   | 136.8717      | 40084.7              | 0.091    | 22.04352 |
| 8         | 1                 | 1                   | 1                   | 850    | 682.9475      | 517477.2             | 0.091    | 113.96494 |

**Explanation of Table Columns**

- **group_loss_bi**: Classification based on bodily injury risk.
- **group_loss_prop**: Classification based on property damage risk.
- **group_loss_liab**: Classification based on liability risk.
- **n**: Number of records in each group.
- **mean_loss**: The average loss value for each group.
- **mean_loss_square**: The square of the average loss for each group.
- **prob**: Probability of occurrence for the region.
- **P**: Calculated premium for each group.

### Premium Calculation Formula

The premium **P** is calculated using the formula:

\[
P = \frac{1.645 \times \left( \sqrt{n \times \left( prob \times mean\_loss\_square - (prob \times mean\_loss)^2 \right)} + n \times prob \times mean\_loss \right)}{n}
\]

This formula takes into account the mean loss, mean loss squared, the number of records in each group, and the probability of failure for the region.

