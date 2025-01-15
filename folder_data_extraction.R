# Install and Load the necessary libraries to convert pdf files to excel
install.packages("pdftools") 
install.packages("openxlsx")
library(pdftools)
library(writexl)

# Provide path of the folder containing PDF files and also provide the path for the output files where you want to store excel files
folder_path <- "/Users/kishupatel/Desktop/DesFert/PrecipFiles/precipitation_data/Precepitation"
out_folder_path <- "/Users/kishupatel/Downloads/k"

# List all the PDF files in the folder
pdf_files <- list.files(folder_path, pattern = "\\.pdf$", full.names = TRUE)

# Loop through each PDF file
for (pdf_file in pdf_files) {
  #Convert pdf file into text
  pdf_text_content <- pdf_text(pdf_file)
  
  #Loop through each page
  for (i in seq_along(pdf_text_content)) {
    #Split each page text into lines
    data_lines <- unlist(strsplit(pdf_text_content[i], "\n"))
    
    #Remove empty and unwanted lines
    data_lines <- data_lines[nchar(data_lines) > 0]
    data_lines <- data_lines[!grepl("Daily", data_lines)] # each page of PDF has "Daily Precipitation Values in Inches" this line, This will remove the line
    
    #Find the start and end line indexes and grep the list of lines
    # Files have different name for the ID, names are from this three ("Gage ID", "DeviceID" OR "PointID"). 
    #Grep will find and collect the ID name as starting name for file and take TOTAL as the end of the file
    
    matchGageId <- grep("Gage ID",data_lines) #start of the file page
    if(length(matchGageId) > 0) {
      start_index <- min(matchGageId)
    } else {
      matchDeviceId <- grep("DeviceID",data_lines)
      if(length(matchDeviceId) > 0) {
        start_index <- min(matchDeviceId)
      } else {
        start_index <- min(grep("PointID",data_lines))
      }
    }
    
    matchEndIndex <- grep("TOTALS:",data_lines) #end of the file page
    if(length(matchEndIndex) > 0) {
      end_index <- max(matchEndIndex)
    } else {
      next
    }
    
    data_lines <- data_lines[start_index:end_index]
    
    #Update header for Gage ID for spliting into right number of columns
    if(length(grep("Gage ID",data_lines)) > 0) {
      data_lines[1] <- gsub("Gage ID", "GageID", data_lines[1])
    }
    
    #Split the columns and convert into data frame
    data <- strsplit(data_lines, "\\s+")
    df <- as.data.frame(data, stringsAsFactors = FALSE)
    
    #Remove the first column from 2nd page onwards (which is date column so that we could not get duplicate column for date for every page)
    if(i != 1) {
      df<- df[-1,]
    }
    
    #Transpose rows into columns and vice versa
    df_transposed <- t(df)
    
    #Add the columns for each page 
    if(i == 1) {
      dfNew = df_transposed
    } else {
      dfNew <- cbind(dfNew, df_transposed)
    }
  }
  excel_file <- file.path(out_folder_path, paste0(tools::file_path_sans_ext(basename(pdf_file)), ".xlsx")) #creates excel file
  write_xlsx(as.data.frame(dfNew), path = excel_file)
}
