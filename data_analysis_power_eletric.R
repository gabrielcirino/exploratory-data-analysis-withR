# Install and load necessary libraries
install.packages(c("dplyr", "lubridate", "ggplot2", "tseries", "hms"))
library(dplyr)
library(lubridate)
library(ggplot2)
library(tseries)
library(hms)


# Load the dataset
# Ensure that the dataset is in the same directory as your R script, or provide the full path to the file
file_path <- "household_power_consumption.txt"
data <- read.delim(file_path, sep = ";", header = TRUE, stringsAsFactors = FALSE, na.strings = "?")

# Convert the 'Date' column to Date format
data$Date <- as.Date(data$Date, format = "%d/%m/%Y")

# Convert the 'Time' column to time format
data$Time <- parse_hms(data$Time)


# Convert various power and sub-metering columns to numeric type
# NAs are introduced for non-convertible values
numeric_vars <- c("Global_active_power", "Global_reactive_power", "Voltage", 
                  "Global_intensity", "Sub_metering_1", "Sub_metering_2", "Sub_metering_3")
data[numeric_vars] <- lapply(data[numeric_vars], as.numeric)

# View the structure of the dataset to confirm changes
str(data)

# View the first few rows of the dataset to understand its structure and contents
head(data)

# Calculate and display summary statistics for each variable
# This provides insights into the distribution and central tendencies of each variable
summary(data)

# Check and display the number of missing values in the dataset
num_missing_values <- sum(is.na(data))
cat("Number of missing values in the dataset:", num_missing_values, "\n")

# Clean Data
data_clean <- na.omit(data)

# Calculate the total power consumption with the cleaned data
total_power_consumption <- sum(data_clean$Global_active_power) / 60
cat("Total Electric Power Consumption:", total_power_consumption, "kWh\n")

#A line plot showing the Global Active Power over time.
ggplot(data_clean, aes(x = Date, y = Global_active_power)) +
  geom_line(color = "blue", alpha = 0.5) +
  labs(title = "Global Active Power Over Time",
       x = "Date",
       y = "Global Active Power (kW)") +
  theme_minimal()

#A box plot to visualize the distribution of Global Active Power.
ggplot(data_clean, aes(y = Global_active_power)) +
  geom_boxplot(fill = "lightblue", outlier.colour = "red", outlier.shape = 8, outlier.size = 4) +
  labs(title = "Box Plot of Global Active Power",
       y = "Global Active Power (kW)") +
  theme_minimal()

#A histogram to visualize the distribution of Global Active Power.
ggplot(data_clean, aes(x = Global_active_power)) +
  geom_histogram(binwidth = 0.1, fill = "lightgreen", color = "black") +
  labs(title = "Histogram of Global Active Power",
       x = "Global Active Power (kW)",
       y = "Frequency") +
  theme_minimal()





