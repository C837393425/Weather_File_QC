library(tidyverse)

# Function to extract weather file details
#
# Inputs:
# - weather_file: A string representing the path to the weather data file (.wth format).
# - ncol: An integer specifying the number of columns in the weather file.
#         Set ncol = 7 for 7-column files ("day", "month", "year", "dayofyr", "min", "max", "percp"),
#         or ncol = 10 for 10-column files ("day", "month", "year", "dayofyr", "min", "max", "percp", "solrad", "rh", "wind_speed").
#
# Output:
# - A data frame containing:
#   1. file_name: The name of the weather file.
#   2. start_year: The first year found in the data.
#   3. end_year: The last year found in the data.
#   4. data_frequency: "Daily" or "Hourly" based on date uniqueness.

extract_weather_file_info <- function(weather_file, ncol) {
  # Define column names based on the number of columns
  if (ncol == 7) {
    column_names <- c("day", "month", "year", "dayofyr", "min", "max", "percp")
  } else if (ncol == 10) {
    column_names <- c("day", "month", "year", "dayofyr", "min", "max", "percp", "solrad", "rh", "wind_speed")
  }
  
  
  # Read the weather file into a data frame
  weather_data <- read.table(weather_file, header = FALSE, col.names = column_names, sep = "", 
                             stringsAsFactors = FALSE, fill = TRUE, comment.char = "")
  
  # Create a date column in MM-DD-YYYY format
  weather_data$date <- format(as.Date(
    paste(weather_data$month, weather_data$day, weather_data$year, sep = "-"),
    format = "%m-%d-%Y"
  ), "%m-%d-%Y")
  
  # Extract start and end year
  start_year <- min(weather_data$year, na.rm = TRUE)
  end_year <- max(weather_data$year, na.rm = TRUE)

  # Determine if data is daily or hourly based on duplicate dates
  if (length(unique(weather_data$date)) == nrow(weather_data)) {
    data_frequency <- "Daily"
  } else {
    data_frequency <- "Hourly"
  }
  
  # Create a summary data frame
  result <- data.frame(
    file_name = basename(weather_file),
    start_year = start_year,
    end_year = end_year,
    data_frequency = data_frequency,
    stringsAsFactors = FALSE
  )
  
  return(result)
}


#Example for Single File
weather_file <- "105_306.wth" 
ncol <- 7
info <- extract_weather_file_info(weather_file, ncol)


#Example for weather folder
weather_folder <- "" #path of the weather files
weather_files <- list.files(weather_folder, pattern = "\\.wth$", full.names = TRUE)
col_numbers = 07 #number of columns in the weather folder
weather_info <- do.call(rbind, lapply(weather_files, extract_weather_file_info, ncol = col_numbers))
print(weather_info)



