library(tidyverse)

# Function to check and list missing dates in a weather file using tryCatch
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
#   2. missing_dates: Dates (formatted as MM-DD-YYYY) that are missing in the sequence.
# - Returns NULL if no missing dates are found or if an error occurs.


find_missing_dates <- function(weather_file, ncol) {

  result <- tryCatch({
    # Define column names based on the number of columns
    if (ncol == 7) {
      column_names <- c("day", "month", "year", "dayofyr", "min", "max", "percp")
    } else if (ncol == 10) {
      column_names <- c("day", "month", "year", "dayofyr", "min", "max", "percp", "solrad", "rh", "wind_speed")
    }
    
    weather_data <- read.table(weather_file, header = FALSE, col.names = column_names, sep = "", 
                               stringsAsFactors = FALSE, fill = TRUE, comment.char = "")
    
    # Create a date column in MM-DD-YYYY format
    weather_data <- weather_data %>%
      mutate(date = as.Date(paste(year, month, day, sep = "-"), format = "%Y-%m-%d"))
    
    date_range <- seq(from = min(weather_data$date), to = max(weather_data$date), by = "days")
    missing_dates <- date_range[!date_range %in% weather_data$date]
    
    if (length(missing_dates) > 0) {
      result_df <- data.frame(
        file_name = basename(weather_file),
        missing_dates = format(missing_dates, "%m-%d-%Y")  
      )
      return(result_df)
    } else {
      return(NULL)  
    }
    
  }, error = function(e) {
    message(paste("Error processing file:", weather_file))
    message("Error message:", e$message)
    return(NULL)
  })
  
  return(result)
}




#Example
weather_folder <- "" #path of the weather files
weather_files <- list.files(weather_folder, pattern = "\\.wth$", full.names = TRUE)
col_numbers = 07 #number of columns in the weather folder
missing_dates_info <- do.call(rbind, Filter(Negate(is.null), lapply(weather_files, find_missing_dates, ncol = col_numbers)))
print(missing_dates_info)
