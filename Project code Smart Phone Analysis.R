##R code snippet used for this initial analysis
# 1. Descriptive Statistics Before Data Cleansing
cat("\nDescriptive Statistics Before Data Cleansing\n")

cat("--------------------------------------------------\n")
summary(smartphone_cleaned)
print(paste("Total Missing Values Before:", sum(is.na(smartphone_cleaned))))

print(paste("Total Duplicate Rows Before:", sum(duplicated(smartphone_cleaned))))


##R code snippet for the data cleansing process
# Data Cleansing
smartphone_cleaned <- smartphone_cleaned[!duplicated(smartphone_cleaned), ]
smartphone_cleaned <- na.omit(smartphone_cleaned) # Assuming NA handling is by omission

# Descriptive Statistics After Data Cleansing
cat("\nDescriptive Statistics After Data Cleansing\n")
cat("--------------------------------------------------\n")

summary(smartphone_cleaned)

print(paste("Total Missing Values After:", sum(is.na(smartphone_cleaned))))
print(paste("Total Duplicate Rows After:", sum(duplicated(smartphone_cleaned))))


#smartphone_cleaned <- gsub("â‚¹", "", smartphone_cleaned)
#smartphone_cleaned

##Histograms for Each Numerical Column
#List of numerical columns

numerical_columns <- c("price", "rating","num_cores","battery_capacity","fast_charging_available","fast_charging","ram_capacity","internal_memory","screen_size","num_rear_cameras","primary_camera_rear","primary_camera_front","extended_memory_available")
library(moments)
# Loop through each numerical column for analysis
for (column in numerical_columns) {
  par(mar = c(4, 4, 2, 1) + 0.1)
  hist(smartphone_cleaned[[column]], main=paste("Histogram of", column),xlab=column, col="red", border="black")
  # Adjusting margins again for boxplot
  par(mar = c(4, 4, 2, 1) + 0.1)
  # Pause for visualization and continue with next column
  readline(prompt="Press [Enter] to continue to the next column analysis...")
}

# Checking if the column is numeric
if (is.numeric(smartphone_cleaned$num_cores)) {
  
  mean_val <- mean(smartphone_cleaned$num_cores, na.rm = TRUE)
  median_val <- median(smartphone_cleaned$num_cores, na.rm = TRUE)
  mode_val <- as.numeric(names(sort(table(smartphone_cleaned$num_cores), decreasing = TRUE)[1]))
  range_val <- range(smartphone_cleaned$num_cores, na.rm = TRUE)
  variance_val <- var(smartphone_cleaned$num_cores, na.rm = TRUE)
  sd_val <- sd(smartphone_cleaned$num_cores, na.rm = TRUE)
  skewness_val <- moments::skewness(smartphone_cleaned$num_cores, na.rm = TRUE)
  kurtosis_val <- moments::kurtosis(smartphone_cleaned$num_cores, na.rm = TRUE)

  # Assume we are calculating the mean of a numeric vector, e.g., 'price'
  mean_val <- mean(smartphone_cleaned$price, na.rm = TRUE)  # Replace 'price' with your column name
  cat("Mean:", mean_val, "\n")
  
  cat("\nDescriptive Statistics for: num_cores\n")
  cat("--------------------------------------------------\n")
  cat("Mean:", mean_val, "\n")
  cat("Median:", median_val, "\n")
  cat("Mode:", mode_val, "\n")
  cat("Range:", range_val[1], "-", range_val[2], "\n")
  cat("Variance:", variance_val, "\n")
  cat("Standard Deviation:", sd_val, "\n")
  cat("Skewness:", skewness_val, "\n")
  cat("Kurtosis:", kurtosis_val, "\n")
} else {
  cat("The column 'num_cores' is not numeric.")
}

# ##Descriptive Statistics for Each Numerical Column
# #List of numerical columns
# numerical_columns <- c("price", "rating","num_cores","pr","battery_capacity","fast_charging_available","fast_charging","ram_capacity","internal_memory","screen_size","num_rear_cameras","primary_camera_rear","primary_camera_front","extended_memory_available")
# library(moments)
# # Loop through each numerical column for analysis
# for (column in numerical_columns) {
#   
#   # Measures of Central Tendency
#   mean_value <- mean(smartphone_cleaned[[column]], na.rm = TRUE)
#   median_value <- median(smartphone_cleaned[[column]], na.rm = TRUE)
#   mode_value <- as.numeric(names(sort(table(smartphone_cleaned[[column]]),decreasing=TRUE)[1]))
#   
#   # Measures of Dispersion
#   range_value <- range(smartphone_cleaned[[column]], na.rm = TRUE)
#   variance_value <- var(smartphone_cleaned[[column]], na.rm = TRUE)
#   sd_value <- sd(smartphone_cleaned[[column]], na.rm = TRUE)
#   
#   # Measures of Shape
#   skewness_value <- skewness(smartphone_cleaned[[column]], na.rm = TRUE)
#   kurtosis_value <- kurtosis(smartphone_cleaned[[column]], na.rm = TRUE)
#   
#   # Print results
#   cat("\nDescriptive Statistics for:", column, "\n")
#   cat("--------------------------------------------------\n")
#   cat("Mean:", round(mean_value, 2), "\n")
#   cat("Median:", round(median_value, 2), "\n")
#   cat("Mode:", mode_value, "\n")
#   cat("Range:", paste0(range_value[1], "-", range_value[2]), "\n")
#   cat("Variance:", round(variance_value, 2), "\n")
#   cat("Standard Deviation:", round(sd_value, 2), "\n")
#   cat("Skewness:", round(skewness_value, 2), "\n")
#   cat("Kurtosis:", round(kurtosis_value, 2), "\n")
# }

##Bar Charts for Each Categorical Column
# List of categorical columns
categorical_columns <- c("brand_name","model","has_5g","has_nfc","has_ir_blaster","processor_brand","os")
# Loop through each categorical column for analysis
for (column in categorical_columns) {
  # Compute frequency counts for the current column
  freq_counts <- table(smartphone_cleaned[[column]])
  # Graphical Representation - Bar Chart
  barplot(freq_counts, main=paste("Bar Chart of", column), xlab=column,
          ylab="Frequency", col="lightgreen", border="black", las=1)
  # Pause for visualization and continue with next column
  readline(prompt="Press [Enter] to continue to the next column analysis...")
}


##Frequency Counts and Proportions
# List of categorical columns
categorical_columns <- c("sim","processor","ram","battery","display","camera","card", "os")
Q# Loop through each categorical column for analysis
for (column in categorical_columns) {
  # Compute frequency counts for the current column
  freq_counts <- table(smartphone_cleaned[[column]])
  # Frequency Counts
  freq_counts <- table(smartphone_cleaned[[column]])
  # Proportions
  proportions <- prop.table(freq_counts)
  # Print results
  cat("\nFrequency Counts for:", column, "\n")
  cat("--------------------------------------------------\n")
  print(freq_counts)
  cat("\nProportions for:", column, "\n")
  cat("--------------------------------------------------\n")
  print(proportions)
}

# Identify columns with zero variance
zero_variance_columns <- sapply(smartphone_cleaned[, numerical_columns], function(x) sd(x) == 0)

# Remove columns with zero variance
numerical_columns_non_zero_variance <- numerical_columns[!zero_variance_columns]

# Perform correlation again on columns with non-zero variance
correlation_matrix <- cor(smartphone_cleaned[, numerical_columns_non_zero_variance], use = "complete.obs")

##Correlation and Hypothesis Testing
# Correlation Analysis for Numerical Columns
#correlation_matrix <- cor(smartphone_cleaned[, numerical_columns],use="complete.obs")
# Print the correlation matrix
print(correlation_matrix)
# Visualize the correlation matrix using a heatmap (optional)
library(ggplot2)
library(reshape2) # for melt function
melted_correlation_matrix <- melt(correlation_matrix) 
ggplot(data = melted_correlation_matrix, aes(x=Var1, y=Var2, fill=value)) +
  geom_tile() +
  scale_fill_gradient2(low="blue", high="red", mid="white", midpoint=0,limit=c(-1,1), space="Lab", name="Pearson\nCorrelation") +
  theme_minimal() +
  labs(title="Correlation Heatmap of Numerical Variables") +
  theme(axis.text.x = element_text(angle=45, vjust=1, hjust=1))
labs(title="Correlation Heatmap of Numerical Variables")
theme(axis.text.x = element_text(angle=45, vjust=1, hjust=1))


# Load necessary libraries
library(ggplot2)
library(reshape2)

# Assuming the correct numerical columns exist in the dataset
numerical_columns <- c("price", "rating", "num_cores", "battery_capacity", 
                       "fast_charging_available", "ram_capacity", 
                       "internal_memory", "screen_size", "num_rear_cameras", 
                       "primary_camera_rear", "primary_camera_front", 
                       "extended_memory_available")

# Check the column names in your dataset to verify that all columns exist
print(colnames(smartphone_cleaned))

# Check for columns with zero variance
zero_variance_columns <- sapply(smartphone_cleaned[, numerical_columns], function(x) sd(x) == 0)

# Get the column names that have zero variance
zero_variance_columns_names <- names(zero_variance_columns[zero_variance_columns])

# Remove columns with zero variance from the numerical columns list
numerical_columns_non_zero_variance <- numerical_columns[!zero_variance_columns]

# Perform correlation analysis on columns with non-zero variance
correlation_matrix <- cor(smartphone_cleaned[, numerical_columns_non_zero_variance], use = "complete.obs")

# Optionally, print the names of columns with zero variance for review
print(zero_variance_columns_names)

# Correlation Analysis for Numerical Columns
#correlation_matrix <- cor(smartphone_cleaned[, numerical_columns], use = "complete.obs")

# Print the correlation matrix
print(correlation_matrix)

# Visualize the correlation matrix using a heatmap
melted_correlation_matrix <- melt(correlation_matrix)

# Generate the heatmap using ggplot2
ggplot(data = melted_correlation_matrix, aes(x = Var1, y = Var2, fill = value)) +
  geom_tile() +
  scale_fill_gradient2(low = "blue", high = "red", mid = "white", 
                       midpoint = 0, limit = c(-1, 1), space = "Lab", 
                       name = "Pearson\nCorrelation") +
  theme_minimal() +
  labs(title = "Correlation Heatmap of Numerical Variables") +
  theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust = 1))


install.packages("readxl")
library(readxl)

# Load the dataset
file_path <- c("C:\\Users\\Sindhu\\Downloads\\smartphone-cleaned.xlsx")  # Replace with your actual file path
df <- read_excel("C:\\Users\\Sindhu\\Downloads\\smartphone-cleaned.xlsx")

# Perform the Pearson correlation test between Battery and Rating
cor_test_result <- cor.test(df$battery_capacity, df$rating, method = "pearson")

# Extract and print the Pearson correlation coefficient and p-value
pearson_r <- cor_test_result$estimate
p_value <- cor_test_result$p.value


print(paste("Pearson correlation coefficient (r):", pearson_r))
print(paste("p-value:", p_value))


# Ensure data is loaded
library(readxl)
data <- read_excel("C:\\Users\\Sindhu\\Downloads\\smartphone-cleaned.xlsx")





# t-test for prices of phones with and without 5G
price_with_5g <- data$price[data$has_5g == TRUE]
price_without_5g <- data$price[data$has_5g == FALSE]
t_test_result <- t.test(price_with_5g, price_without_5g, na.rm = TRUE)
print(t_test_result)

# Load necessary library
library(readxl)

# Load data
data <- read_excel("C:\\Users\\Sindhu\\Downloads\\smartphone-cleaned.xlsx")

# Convert the categorical variable to factor if not already
data$processor_brand <- as.factor(data$processor_brand)

# One-way ANOVA: Comparing prices across different processor brands
one_way_anova <- aov(price ~ processor_brand, data = data)
summary(one_way_anova)

# Convert categorical variables to factors if not already
data$processor_brand <- as.factor(data$processor_brand)
data$has_5g <- as.factor(data$has_5g)

# Two-way ANOVA: Checking the effect of processor_brand and has_5g on price
two_way_anova <- aov(price ~ processor_brand * has_5g, data = data)
summary(two_way_anova)


# Conduct a chi-squared test for association between 5G and NFC capability
# Ensure both variables are factors for the test
data$has_5g <- as.factor(data$has_5g)
data$has_nfc <- as.factor(data$has_nfc)

# Create a contingency table
contingency_table <- table(data$has_5g, data$has_nfc)

# Perform the chi-squared test
chi_squared_result <- chisq.test(contingency_table)
print(chi_squared_result)

# Convert categorical variable to factor
data$has_5g <- as.factor(data$has_5g)

# Check for missing values in each column
colSums(is.na(smartphone_cleaned[categorical_columns]))
smartphone_cleaned <- smartphone_cleaned[complete.cases(smartphone_cleaned[categorical_columns]), ]
# Fisher's Exact Test for 2x2 tables
fisher.test(contingency_table)

for (i in 1:(length(categorical_columns) - 1)) {
  for (j in (i + 1):length(categorical_columns)) {
    var1 <- categorical_columns[i]
    var2 <- categorical_columns[j]
    
    # Filter for complete cases in the two columns
    subset_data <- smartphone_cleaned[complete.cases(smartphone_cleaned[c(var1, var2)]), ]
    
    # Create contingency table
    contingency_table <- table(subset_data[[var1]], subset_data[[var2]])
    
    # Check if the table is valid
    if (any(dim(contingency_table) == 0)) {
      cat("Skipping Chi-Square test for", var1, "and", var2, ": no valid data.\n")
      next
    }
    
    # Perform Chi-Square test
    chi_square_result <- chisq.test(contingency_table)
    
    # Display results
    cat("Chi-Square Test for", var1, "and", var2, ":\n")
    print(chi_square_result)
    cat("\n--------------------------------------------\n")
    
    # Check significance
    if (chi_square_result$p.value < 0.05) {
      cat("Significant association between", var1, "and", var2, "\n\n")
    } else {
      cat("No significant association between", var1, "and", var2, "\n\n")
    }
  }
}


# Perform linear regression
# Predicting 'price' based on 'screen_size' and 'has_5g'
linear_model <- lm(price ~ screen_size + has_5g, data = data)

# Display the summary of the model to see coefficients and their significance
summary(linear_model)

# Plot diagnostic plots
par(mfrow = c(2, 2))  # Arrange plots in a 2x2 layout
plot(linear_model, col ='red')

# Load ggplot2
library(ggplot2)

# Scatter plot with regression line for continuous predictor
ggplot(data, aes(x = screen_size, y = price)) +
  geom_point() +
  geom_smooth(method = "lm", se = TRUE, color = "blue") +
  labs(title = "Price vs Screen Size with Regression Line", x = "Screen Size", y = "Price")

# Boxplot for categorical predictor (e.g., has_5g)
ggplot(data, aes(x = has_5g, y = price)) +
  geom_boxplot() +
  labs(title = "Price by 5G Capability", x = "5G Capability", y = "Price")

# Boxplot for another categorical variable (e.g., processor_brand)
ggplot(data, aes(x = processor_brand, y = price)) +
  geom_boxplot() +
  labs(title = "Price by Processor Brand", x = "Processor Brand", y = "Price") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# Predicted values from the linear regression model
predictions_linear <- predict(linear_model, data)

# Actual values (observed)
actual_values <- data$price

# Calculate RMSE (Root Mean Squared Error)
RMSE <- sqrt(mean((predictions_linear - actual_values)^2))

# Calculate MAE (Mean Absolute Error)
MAE <- mean(abs(predictions_linear - actual_values))
# Display R-Squared and Adjusted R-Squared values for the linear regression model
cat("\nR-Squared:", summary(linear_model)$r.squared, "\n")
cat("Adjusted R-Squared:", summary(linear_model)$adj.r.squared, "\n")

cat("\nRMSE:", RMSE, "\n")
cat("MAE:", MAE, "\n")

# Plot Residuals vs Fitted values
plot(linear_model, which = 1, col = 'blue', main = "Residuals vs Fitted")

# Extract residuals
residuals_linear <- residuals(linear_model)

# Plot Histogram of residuals
hist(residuals_linear, breaks = 20, main = "Histogram of Residuals", xlab = "Residuals", col = "lightblue", border = "black")

# Assuming your linear model is already fitted
fitted_values <- fitted(linear_model)  # Predicted values from the model

# Assuming 'test_set' contains the actual values you're comparing to (e.g., 'price')
actual_values <- test_set$price  # Replace 'price' with the actual column name if different

# Plot Fitted vs Actual Values
plot(fitted_values, actual_values, 
     main = "Fitted vs Actual Values", 
     xlab = "Fitted Values", 
     ylab = "Actual Values",
     col = "blue", pch = 16)

# Add a diagonal line for perfect predictions
abline(a = 0, b = 1, col = "red")

install.packages("caTools")    # For Linear regression 
library(caTools)

install.packages('car')
library(car)

# Load the smartphone_cleaned dataset
library(readxl)
smartphone_cleaned <- read_excel("C:\\Users\\Sindhu\\Downloads\\smartphone-cleaned.xlsx")

# View the structure of the dataset
str(smartphone_cleaned)

# Define the variables for the analysis (replace with actual variables from your dataset)
# For example, let's assume these variables exist in your dataset
Smartphone_cleaned <- data.frame(
  smartphone_cleaned$price,  # Replace with the target variable (price or another variable)
  smartphone_cleaned$screen_size,  # Replace with the actual variable
  smartphone_cleaned$has_5g,  # Replace with the actual variable
  smartphone_cleaned$ram_capacity,  # Replace with the actual variable
  smartphone_cleaned$processor_speed  # Replace with the actual variable
)

# Renaming columns for clarity
colnames(Smartphone_cleaned)[1] = "price"
colnames(Smartphone_cleaned)[2] = "screen_size"
colnames(Smartphone_cleaned)[3] = "has_5g"
colnames(Smartphone_cleaned)[4] = "ram"
colnames(Smartphone_cleaned)[5] = "processor_speed"

# Check the summary of the dataset
summary(Smartphone_cleaned)

# Q.b) Data cleaning for missing values (impute with mean if necessary)
sum(!complete.cases(Smartphone_cleaned$price))  # Count missing values for 'price'
sum(!complete.cases(Smartphone_cleaned$screen_size))  # Count missing values for 'screen_size'
sum(!complete.cases(Smartphone_cleaned$has_5g))  # Count missing values for 'has_5g'
sum(!complete.cases(Smartphone_cleaned$ram))  # Count missing values for 'ram'
sum(!complete.cases(Smartphone_cleaned$processor_speed))  # Count missing values for 'processor_speed'

# Impute missing values with mean for each column (adjust column names as per dataset)
Smartphone_cleaned_clean_mean <- Smartphone_cleaned
Smartphone_cleaned_clean_mean$price <- ifelse(is.na(Smartphone_cleaned$price), mean(Smartphone_cleaned$price, na.rm = TRUE), Smartphone_cleaned$price)
Smartphone_cleaned_clean_mean$screen_size <- ifelse(is.na(Smartphone_cleaned$screen_size), mean(Smartphone_cleaned$screen_size, na.rm = TRUE), Smartphone_cleaned$screen_size)
Smartphone_cleaned_clean_mean$has_5g <- ifelse(is.na(Smartphone_cleaned$has_5g), mean(Smartphone_cleaned$has_5g, na.rm = TRUE), Smartphone_cleaned$has_5g)
Smartphone_cleaned_clean_mean$ram <- ifelse(is.na(Smartphone_cleaned$ram), mean(Smartphone_cleaned$ram, na.rm = TRUE), Smartphone_cleaned$ram)
Smartphone_cleaned_clean_mean$processor_speed <- ifelse(is.na(Smartphone_cleaned$processor_speed), mean(Smartphone_cleaned$processor_speed, na.rm = TRUE), Smartphone_cleaned$processor_speed)

# Check for missing values after imputation
sum(!complete.cases(Smartphone_cleaned_clean_mean$price))
sum(!complete.cases(Smartphone_cleaned_clean_mean$screen_size))
sum(!complete.cases(Smartphone_cleaned_clean_mean$has_5g))
sum(!complete.cases(Smartphone_cleaned_clean_mean$ram))
sum(!complete.cases(Smartphone_cleaned_clean_mean$processor_speed))

# Q.c) Test the significant relationship between variables
# 1. Price and Screen Size
linearmodel1 <- lm(price ~ screen_size, data = Smartphone_cleaned_clean_mean)
summary(linearmodel1)

# Removing blank values and recreating the linear model
Smartphone_cleaned<- na.omit(Smartphone_cleaned)
linearmodel1_clean <- lm(price ~ screen_size, data = Smartphone_cleaned)
summary(linearmodel1_clean)

# 2. Price and RAM
linearmodel2 <- lm(price ~ ram, data = Smartphone_cleaned_clean_mean)
summary(linearmodel2)

# Removing blank values and recreating the linear model
linearmodel2_clean <- lm(price ~ ram, data = Smartphone_cleaned)
summary(linearmodel2_clean)

# 3. Price and Processor Speed
linearmodel3 <- lm(price ~ processor_speed, data = Smartphone_cleaned_clean_mean)
summary(linearmodel3)

# Testing multilinear model (price ~ ram + processor_speed)
linearmodel3_multi <- lm(price ~ ram + processor_speed, data = Smartphone_cleaned_clean_mean)
summary(linearmodel3_multi)
vif(linearmodel3_multi)

linearmodel3_multi_2 <- lm(price ~ ram * processor_speed, data = Smartphone_cleaned_clean_mean)
summary(linearmodel3_multi_2)
vif(linearmodel3_multi_2)

# 4. Price and Has 5G
linearmodel4 <- lm(price ~ has_5g, data = Smartphone_cleaned)
summary(linearmodel4)

# Removing blank values and recreating the linear model
linearmodel4_clean <- lm(price ~ has_5g, data = Smartphone_cleaned)
summary(linearmodel4_clean)

# Save the final models
save(linearmodel1, file = "linearmodel1.RData")
save(linearmodel2, file = "linearmodel2.RData")
save(linearmodel3, file = "linearmodel3.RData")
save(linearmodel4, file = "linearmodel4.RData")

# Load the necessary library for plotting
install.packages("ggplot2")
library(ggplot2)
## Single Linear Regression
# 1. Plot for the model: price ~ screen_size
ggplot(Smartphone_cleaned_clean_mean, aes(x = screen_size, y = price)) +
  geom_point(color = "blue") + 
  geom_smooth(method = "lm", color = "red") + 
  ggtitle("Price vs Screen Size") +
  xlab("Screen Size") +
  ylab("Price") +
  theme_minimal()

# 2. Plot for the model: price ~ ram
ggplot(Smartphone_cleaned_clean_mean, aes(x = ram, y = price)) +
  geom_point(color = "blue") + 
  geom_smooth(method = "lm", color = "red") + 
  ggtitle("Price vs RAM") +
  xlab("RAM Capacity") +
  ylab("Price") +
  theme_minimal()

# 3. Plot for the model: price ~ processor_speed
ggplot(Smartphone_cleaned_clean_mean, aes(x = processor_speed, y = price)) +
  geom_point(color = "blue") + 
  geom_smooth(method = "lm", color = "red") + 
  ggtitle("Price vs Processor Speed") +
  xlab("Processor Speed") +
  ylab("Price") +
  theme_minimal()

# 4. Plot for the model: price ~ has_5g
ggplot(Smartphone_cleaned_clean_mean, aes(x = has_5g, y = price)) +
  geom_point(color = "blue") + 
  geom_smooth(method = "lm", color = "red") + 
  ggtitle("Price vs 5G Availability") +
  xlab("Has 5G (1 = Yes, 0 = No)") +
  ylab("Price") +
  theme_minimal()

# 5. Plot for multiple linear regression: price ~ ram + processor_speed
# Create a new dataset with predicted values from the model
Smartphone_cleaned_clean_mean$predicted_price <- predict(linearmodel3_multi, Smartphone_cleaned_clean_mean)

# Scatter plot of actual vs predicted values
ggplot(Smartphone_cleaned_clean_mean, aes(x = predicted_price, y = price)) +
  geom_point(color = "blue") + 
  geom_abline(intercept = 0, slope = 1, color = "red") + 
  ggtitle("Actual vs Predicted Price (Multiple Regression)") +
  xlab("Predicted Price") +
  ylab("Actual Price") +
  theme_minimal()

# 6. Diagnostic plots for the linear regression model: price ~ ram + processor_speed
par(mfrow = c(2, 2))
plot(linearmodel3_multi)

# Reset to default plotting layout
par(mfrow = c(1, 1))

linearmodel3_multi <- lm(price ~ ram + processor_speed, data = Smartphone_cleaned_clean_mean)
summary(linearmodel3_multi)
vif(linearmodel3_multi)

# Load necessary libraries
library(Metrics) # For MAE and RMSE
library(car)     # For VIF (multicollinearity check)

# Single Linear Regression
single_lm <- lm(price ~ screen_size, data = Smartphone_cleaned)

# Multiple Linear Regression
multi_lm <- lm(price ~ screen_size + ram + processor_speed, data = Smartphone_cleaned)

# Summary of both models
summary(single_lm)
summary(multi_lm)

# Performance Metrics for Single Linear Regression
single_r2 <- summary(single_lm)$r.squared
single_adj_r2 <- summary(single_lm)$adj.r.squared
single_rmse <- sqrt(mean(residuals(single_lm)^2))
single_mae <- mae(Smartphone_cleaned$price, predict(single_lm))

# Performance Metrics for Multiple Linear Regression
multi_r2 <- summary(multi_lm)$r.squared
multi_adj_r2 <- summary(multi_lm)$adj.r.squared
multi_rmse <- sqrt(mean(residuals(multi_lm)^2))
multi_mae <- mae(Smartphone_cleaned$price, predict(multi_lm))

# Print Performance Metrics
cat("Performance Metrics for Single Linear Regression:\n")
cat("R-squared:", single_r2, "\n")
cat("Adjusted R-squared:", single_adj_r2, "\n")
cat("RMSE:", single_rmse, "\n")
cat("MAE:", single_mae, "\n\n")

cat("Performance Metrics for Multiple Linear Regression:\n")
cat("R-squared:", multi_r2, "\n")
cat("Adjusted R-squared:", multi_adj_r2, "\n")
cat("RMSE:", multi_rmse, "\n")
cat("MAE:", multi_mae, "\n")

