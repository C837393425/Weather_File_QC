
# Function to identify dates and columns with missing values a in weather file's rows
# 
# Inputs:
# - weather_file: A string representing the path to the weather data file (.wth format).
# - ncol: An integer specifying the number of columns in the weather file.
#         Set ncol = 7 for 7-column files ("day", "month", "year", "dayofyr", "min", "max", "percp"),
#         or ncol = 10 for 10-column files ("day", "month", "year", "dayofyr", "min", "max", "percp", "solrad", "rh", "wind_speed").
#
# Output:
# - A data frame containing:
#   1. file_name: The name of the weather file where missing values were found.
#   2. missing_date: The date (formatted as MM-DD-YYYY) where missing values occur.
#   3. missing_columns: A comma-separated list of column names with missing values.
# - Returns NULL if no missing values are found.



library(tidyverse)

filter_missing_cols <- function(weather_file, ncol) {
  
  # Column names for the weather data
    if (ncol == 7) {
    column_names <- c("day", "month", "year", "dayofyr", "min", "max", "percp")
  } else if (ncol == 10) {
    column_names <- c("day", "month", "year", "dayofyr", "min", "max", "percp", "solrad", "rh", "wind_speed")
  }
  
  
  # Read the weather file
  weather_data <- read.table(weather_file, header = FALSE, col.names = column_names, sep = "", 
                             stringsAsFactors = FALSE, fill = TRUE, comment.char = "")
  
  # Create a date column in MM-DD-YYYY format
  weather_data$date <- format(as.Date(
    paste(weather_data$month, weather_data$day, weather_data$year, sep = "-"),
    format = "%m-%d-%Y"
  ), "%m-%d-%Y")
  
  # Identify rows with missing values in columns v1 to v6 (5th to 10th columns)
  incomplete_rows <- which(!complete.cases(weather_data[, 1:ncol(weather_data)]))
  
  if (length(incomplete_rows) > 0) {
    # Extract missing date and columns with missing values
    missing_info <- lapply(incomplete_rows, function(row) {
      missing_cols <- names(weather_data)[1:10][is.na(weather_data[row, 1:ncol(weather_data)])]
      data.frame(
        file_name = basename(weather_file),
        missing_date = weather_data$date[row],
        missing_columns = paste(missing_cols, collapse = ", ")
      )
    })
    
    # Combine all rows into a single data frame
    result <- do.call(rbind, missing_info)
    return(result)
  } else {
    return(NULL)  # Exclude files without missing data
  }
}









#Example
weather_folder <- "N:/Research/Ogle/LandCraft/NASA_Power/DayCent_wth/10col" #path of the weather files
weather_files <- list.files(weather_folder, pattern = "\\.wth$", full.names = TRUE)
col_numbers = 10 #number of columns in the weather folder
all_missing_data <- do.call(rbind, Filter(Negate(is.null), lapply(weather_files, filter_missing_cols, ncol = col_numbers)))
print(all_missing_data)

