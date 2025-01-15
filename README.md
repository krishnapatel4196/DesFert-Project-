Precipitation data file

1.	Convert PDF files to Excel files (October 2010- September 2021)
•	Download the PDF files from https://www.maricopa.gov/625/Rainfall-Data
•	Store the PDF files in a dedicated folder (this will serve as the input folder for the R script).
•	Install R and R Studio, then open the provided script.
•	Run the folder_data_extraction.R script to convert the data from PDF to Excel for further processing.
Note: The files for January 2020 and November 2019 (named pcp0120 and pcp1119) are not processed using this code. The data from these files has been extracted manually.

2.	Extract Data from Excel files
•	I have created two separate Python files for data extraction using the Pandas library.
•	To use Pandas, you will need to download Jupyter Notebook and install Pandas.
•	The files exceldataextraction_precipitation.ipynb and precipitation.ipynb will be used to extract the data from the precipitation Excel files.
