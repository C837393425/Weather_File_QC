README: Weather File Analysis Functions

Overview

This document provides an overview of three R functions designed to analyze weather data files (.wth format). The functions assist in extracting metadata, identifying missing values, and detecting missing dates within the dataset.

Prerequisites

Ensure you have the following dependencies installed in your R environment:

install.packages("tidyverse")








Functions:

1. extract_weather_file_info

Description

Extracts key details from a weather file, including file name, start and end years, and data frequency (daily or hourly).

Inputs

weather_file: A string representing the path to the weather data file.

ncol: An integer specifying the number of columns in the file. Use:

7 for columns: day, month, year, dayofyr, min, max, percp

10 for columns: day, month, year, dayofyr, min, max, percp, solrad, rh, wind_speed

Output

A data frame containing:

file_name: The name of the weather file.

start_year: The first year in the data.

end_year: The last year in the data.

data_frequency: "Daily" or "Hourly" based on date uniqueness.







2. filter_missing_cols

Description

Identifies dates and columns with missing values in the weather file.

Inputs

weather_file: A string representing the path to the weather data file.

ncol: An integer specifying the number of columns in the file (7 or 10 as described above).

Output

A data frame containing:

file_name: The weather file name.

missing_date: The date (MM-DD-YYYY) where missing values occur.

missing_columns: A comma-separated list of columns with missing values.

Returns NULL if no missing values are found.







3. find_missing_dates

Description

Checks for missing dates in the weather file and returns the missing dates.

Inputs

weather_file: A string representing the path to the weather data file.

ncol: An integer specifying the number of columns in the file (7 or 10 as described above).

Output

A data frame containing:

file_name: The weather file name.

missing_dates: Dates (MM-DD-YYYY) that are missing in sequence.

Returns NULL if no missing dates are found or if an error occurs.





Usage Example:

# Example usage of the functions
weather_file <- "105_306.wth"
ncol <- 7

# Extract file info
info <- extract_weather_file_info(weather_file, ncol)

# Find missing values
missing_values <- filter_missing_cols(weather_file, ncol)

# Find missing dates
missing_dates <- find_missing_dates(weather_file, ncol)




