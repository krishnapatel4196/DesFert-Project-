library(readxl)
library(dplyr)

# Specify the file path of your Excel file
file_path <- "path/to/your/excel_file.xlsx"

# Get all sheet names from the Excel file
sheet_names <- excel_sheets(file_path)

# Read and combine data from all sheets

combined_data <- sheet_names %>%
  lapply(function(sheet) {
    
    data <- read_excel(file_path, sheet = sheet, skip= 3)  #Edit skip = to be the number of rows without data
    
    data <- data %>%
      filter(!if_any(everything(), ~ grepl("Total", .))) #Removes “total row” - fix to be exact wording! 
    
    data$Month <- sheet  # Add a new column for the sheet name (month)
    return(data)
  }) %>%
  bind_rows()

# View the combined data with month information
head(combined_data)
###############################################################################################

# Load required libraries
library(readxl)
library(writexl)

# File path to your Excel file
file_path <- "/Users/kishupatel/Desktop/DesFert/CodeHelp/ADOT/2020-AADT-PUBLICATION.xlsx"

# Define a data frame with multiple filtering criteria
filter_criteria <- data.frame(
  Loc_ID = c(100348, 100117, 100677, 100678, 100679, 101385, 101890, 101891),  # Replace with desired Loc IDs
  Route = c("I 17", "I 10", "SR 51", "SR 51", "SR 51", "SR 202", "US 60", "US 60")  # Replace with Start values
)

# Get all sheet names in the Excel file
sheet_names <- excel_sheets(file_path)

# Create an empty list to store filtered data
filtered_data <- list()

# Loop through each sheet
for (sheet in sheet_names) {
  # Read the sheet into a data frame
  df <- read_excel(file_path, sheet = sheet)
  
  # Loop through each set of criteria
  for (i in 1:nrow(filter_criteria)) {
    loc_id <- filter_criteria$"Loc ID"[i]
    route <- filter_criteria$Route[i]
    
    # Filter rows based on the current criteria
    filtered <- df[df$`Loc ID` == loc_id & 
                     df$Route == route, c("Loc ID","Route", "AADT 2019")]
    
    # Add the filtered data to the list, including sheet name and criteria as columns
    if (nrow(filtered) > 0) {
      filtered$Sheet <- sheet
      filtered$Criteria <- paste(loc_id, route, sep = "_")
      filtered_data[[paste(sheet, i, sep = "_")]] <- filtered
    }
  }
}

# Combine all filtered data into one data frame
final_data <- do.call(rbind, filtered_data)

# Write the final data into a new Excel file
output_file <- "filtered_aadt_data.xlsx"
write_xlsx(final_data, output_file)

cat("Filtered data saved to:", output_file, "\n")
