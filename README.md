Precipitation data file

1.	Convert PDF files to Excel files (October 2010- September 2021)
•	Download files from https://www.maricopa.gov/625/Rainfall-Data
•	Store the PDF file in a folder (This would be an input folder for R script)
•	Install R and R studio and open the provided script
•	Run the R script folder_data_extraction.R  and convert the data from PDF to excel for further extraction.
	Note: Jan-2020 and Nov-2019 files named pcp0120 and pcp1119 are not processed with this code. So data was extracted from this files manually.

2.	Extract Data from Excel files
•	For this I created two separate files which is using python (Pandas) for the data extraction.
•	To use pandas, you have to download Jupiter notebook and pandas
• exceldataextraction_precipitation.ipynb and precipitation.ipynb files will extract data from the precipitation files.
