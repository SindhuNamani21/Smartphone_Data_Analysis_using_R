# Smartphone_Data_Analysis_using_R-
End-to-end smartphone data analysis using Python and R — data cleaning, EDA, and regression modeling on 1,020 smartphone models scraped from SmartPrix.

## 📌 Project Overview

This project performs end-to-end data analytics on a real-world smartphone dataset scraped from SmartPrikes using **Selenium** and **Beautiful Soup**. The raw dataset contains **1,020 smartphone models** across various brands, covering technical specifications, pricing, battery life, camera details, and user ratings.

The project spans the full analytics pipeline — from raw messy data to statistical modeling — using both **Python** and **R**. The goals are to uncover patterns in smartphone pricing and features, understand the relationship between user ratings and technical specifications, and identify what features customers value most across different price ranges.

---

## 📊 Dataset Description

### Raw Dataset (`smartphone-uncleaned`)

The raw dataset has **1,020 rows and 11 columns**, all in unstructured string format with mixed units, currency symbols, and compound fields that need to be parsed and separated:

| Column | Description | Example Value |
|--------|-------------|---------------|
| `model` | Smartphone model name | Samsung Galaxy S21 |
| `sim` | SIM type, network bands, connectivity flags | Dual SIM, 5G, NFC, IR Blaster |
| `price` | Price as a string with Indian Rupee symbol | ₹54,999 |
| `display` | Screen size, resolution, and refresh rate combined | 6.2 inches, 1080x2400, 120Hz |
| `rating` | User rating out of 100 | 87 |
| `os` | Operating system and version | Android 11 |
| `processor` | Processor brand, model, cores, and speed | Snapdragon 888, Octa-core, 2.84GHz |
| `ram` | RAM and internal storage combined | 8GB RAM, 128GB Storage |
| `battery` | Battery capacity and fast charging combined | 4000mAh, 25W Fast Charging |
| `camera` | Rear and front camera specs combined | Triple 64MP+12MP+5MP & 10MP Front |
| `card` | External memory card support | MicroSD up to 1TB |

### Cleaned Dataset (`smartphone-cleaned`)

After the full cleaning pipeline, the dataset was expanded to **25 structured columns** with correct data types, making it ready for statistical analysis and visualization:

`brand_name`, `model`, `price`, `rating`, `has_5g`, `has_nfc`, `has_ir_blaster`, `processor_brand`, `num_cores`, `processor_speed`, `battery_capacity`, `fast_charging_available`, `fast_charging`, `ram_capacity`, `internal_memory`, `screen_size`, `refresh_rate`, `resolution`, `num_rear_cameras`, `num_front_cameras`, `os`, `primary_camera_rear`, `primary_camera_front`, `extended_memory_available`, `extended_upto`

---

## 🔧 Data Quality Issues Identified

The raw data had a large number of documented quality and tidiness issues that required systematic resolution.

### Quality Issues (20 identified)
- **Price:** Contained `₹` currency symbols and commas (e.g., `₹54,999`) — needed symbol stripping and conversion to integer
- **Price accuracy:** One phone (Namotel) had a price of ₹99, which was an obvious outlier and was removed
- **Ratings:** Missing values across multiple rows in the `rating` column
- **Processor:** Incorrect or placeholder values for ~17 Samsung rows (rows 642, 647, 649, 659, 667, 701, 750, 759, 819, 859, 883, 884, 919, 927, 929, 932, 1002)
- **Memory/RAM:** Invalid values in ~24 rows with misaligned or corrupted data
- **Battery:** Corrupt entries in ~33 rows caused by column-shifted scraping errors
- **Display:** Missing refresh rate for some models; invalid values in ~27 rows
- **Camera:** Inconsistent labeling — words like "Dual", "Triple", "Quad" used instead of numbers; front and rear cameras separated by `&`; corrupt data in ~65 rows
- **Card column:** Sometimes contained OS or camera data due to scraping misalignment
- **OS column:** Sometimes contained unrelated info like Bluetooth or FM radio; version names like "Lollipop" instead of "Android 5"
- **Brand name consistency:** Same brand written differently across rows (e.g., OPPO vs oppo)
- **Non-phone entry:** An iPod appeared in row 756 and was removed
- **Incorrect data types:** `price` and `rating` stored as strings instead of numeric types

### Tidiness Issues (7 structural problems)
All compound columns were split into atomic columns:
- `sim` → `has_5g`, `has_nfc`, `has_ir_blaster`
- `ram` → `ram_capacity`, `internal_memory`
- `processor` → `processor_brand`, `num_cores`, `processor_speed`
- `battery` → `battery_capacity`, `fast_charging_available`, `fast_charging`
- `display` → `screen_size`, `resolution`, `refresh_rate`
- `camera` → `num_rear_cameras`, `primary_camera_rear`, `num_front_cameras`, `primary_camera_front`
- `card` → `extended_memory_available`, `extended_upto`

---

## 🧹 Data Cleaning Process

The cleaning was performed in **two rounds** across Python notebooks, with every step carefully documented and traced back to original row numbers.

### Round 1 — `data_cleaning_smartphone_data.ipynb`
- Created a working copy of the raw dataframe before any modifications
- Stripped `₹` and `,` from the price column and cast to integer
- Re-indexed rows to match original CSV row numbers for full traceability
- Identified all problematic rows per column using Python sets, then reviewed them individually
- Dropped rows with irrecoverable multi-column corruption (rows 645, 857, 882, 925, 376, 754, 582)
- Fixed column-shifted rows where battery data had shifted one position right — corrected using a NumPy shift operation across the affected rows
- Removed the Namotel ₹99 price outlier and the iPod entry
- Parsed and split all compound columns (sim, ram, processor, battery, display, camera, card) using string operations and regex
- Standardized brand names to lowercase and fixed spelling inconsistencies

### Round 2 — `data_cleaning_round_2_smartphones.ipynb`
- Further standardized the `processor_brand` column — unified "qualcomm" → "snapdragon", "apple" → "bionic", "samsung" → "exynos", and corrected typos like "sanpdragon"
- Reviewed remaining null counts across all columns using `.isnull().sum()`
- Generated distribution plots (histograms + KDE) and boxplots during cleaning to visually verify each column after transformation
- Produced intermediate exploratory checks on price, rating, 5G, NFC, IR Blaster, processor brand, and core count to confirm cleaning quality before finalizing

---

## 📈 Exploratory Data Analysis

### `eda_on_smartphone_data.ipynb`

The EDA notebook performs a comprehensive univariate and bivariate analysis on the final cleaned dataset.

**Univariate Analysis — for every major column:**
- Bar charts and pie charts for categorical columns: brand, OS, processor brand, core count, refresh rate, connectivity features (5G, NFC, IR Blaster)
- KDE histograms and boxplots for numerical columns: price, rating, battery capacity, RAM, screen size, internal memory
- Skewness computed for price and rating — price showed significant right skew, indicating most phones are budget/mid-range with a long tail of expensive flagships

**Bivariate & Multivariate Analysis:**
- Bar chart of average price by brand, filtered to brands with more than 10 models for statistical reliability
- Scatter plot of `rating` vs `price` — showed weak linear correlation, meaning expensive phones are not necessarily rated higher
- Median price comparison by `has_5g`, `has_nfc`, `has_ir_blaster` — 5G and NFC phones show clear price premiums
- Median price by `processor_brand` and `num_cores` — Snapdragon and Bionic dominate the high price tier
- Scatter plots of `processor_speed` vs `price` and `screen_size` vs `price`
- Cross-tabulation of `num_cores` vs `os` to understand platform-architecture relationships

**Correlation Analysis:**
- Pearson correlation computed for all numeric columns against `price` and `rating`
- KNN Imputer (`n_neighbors=5`, via scikit-learn) applied to handle remaining missing numeric values before generating the full correlation matrix
- Before/after imputation correlation comparison generated to validate imputation impact
- One-hot encoding (`pd.get_dummies`) applied to brand, processor, and OS columns to include categorical variables in price correlation analysis

---

## 📐 Statistical Analysis in R

### `Project_code_Smart_Phone_Analysis.R`

The R script performs formal descriptive statistics and regression modeling on the cleaned dataset.

**Descriptive Statistics:**
- `summary()` run on both the raw and cleaned datasets for a before/after comparison
- Total missing values and duplicate row counts verified before and after cleaning
- For all numerical columns, the following statistics were computed: mean, median, mode, range, variance, standard deviation, skewness, and kurtosis (using the `moments` package)
- Histograms generated for all numerical columns using base R graphics

**Regression Modeling:**

Two models were built and compared to predict smartphone price:

*Single Linear Regression* — `price ~ screen_size` as the baseline single-predictor model

*Multiple Linear Regression* — `price ~ screen_size + ram + processor_speed` as the extended model

Both models were evaluated on four performance metrics:

| Metric | Description |
|--------|-------------|
| R² | Proportion of variance in price explained by the model |
| Adjusted R² | R² adjusted for number of predictors |
| RMSE | Root Mean Squared Error — average prediction error in rupees |
| MAE | Mean Absolute Error |
| VIF | Variance Inflation Factor to check multicollinearity (via `car` package) |

**Visualizations produced in R:**
- Scatter plots with linear regression lines for: price vs screen size, price vs RAM, price vs processor speed, price vs 5G availability
- Actual vs. predicted price scatter plot with a 45-degree reference line for the multiple regression model
- 4-panel diagnostic plots (residuals vs fitted, Q-Q normality plot, scale-location, residuals vs leverage)

---

## 🔑 Key Findings

- **5G is a strong price driver** — phones with 5G support carry a significantly higher median price than non-5G phones
- **RAM and processor speed** are the best numerical predictors of price in regression models
- **User ratings show weak correlation with price** — premium pricing does not guarantee higher satisfaction scores
- **Refresh rate correlates positively with price** — 120Hz+ displays are predominantly found in the premium segment
- **Snapdragon and Bionic (Apple)** processors dominate the high-price tier; MediaTek is far more prevalent in budget phones
- **IR Blaster is almost exclusive to Xiaomi/Redmi** phones in this dataset
- **Most phones run Android** — iOS represents a small but distinctly high-price segment
- **Extended memory support** is more common in budget phones; flagships rely on fixed internal storage

---

## 🚀 How to Run

### Python Notebooks

```bash
pip install pandas numpy matplotlib seaborn scikit-learn jupyter
jupyter notebook
```

Run the notebooks in this order:
1. `data_cleaning_smartphone_data.ipynb`
2. `data_cleaning_round_2_smartphones.ipynb`
3. `eda_on_smartphone_data.ipynb`

### R Script

```r
install.packages(c("ggplot2", "dplyr", "moments", "car", "Metrics"))
source("r_analysis/Project_code_Smart_Phone_Analysis.R")
```

Load `smartphone-cleaned.csv` into a dataframe named `smartphone_cleaned` before running, or update the file path at the top of the script to match your local environment.

---

## 🛠️ Tools & Technologies

| Tool | Purpose |
|------|---------|
| Python 3 | Data cleaning, transformation, EDA |
| Pandas & NumPy | Data manipulation and numerical operations |
| Matplotlib & Seaborn | Python visualizations |
| Scikit-learn (KNNImputer) | Imputing missing values for correlation analysis |
| R (base) | Descriptive statistics and regression modeling |
| ggplot2 | R visualizations |
| moments (R) | Skewness and kurtosis calculations |
| car (R) | VIF multicollinearity testing |
| Metrics (R) | MAE and RMSE calculation |
| Jupyter Notebook | Interactive Python environment |
| Microsoft Excel | Data review and inspection |

---
