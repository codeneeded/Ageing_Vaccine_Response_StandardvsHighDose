library(readxl)
library(purrr)
library(dplyr)

# Path to your Excel file
#### Paths
in.path <- 'C:/Users/axi313/Desktop/Analysis/Sheldon/Ageing 11292023/Input/'
out.path <- 'C:/Users/axi313/Desktop/Analysis/Sheldon/Ageing 11292023/Output/'
excel_path <- paste0(in.path,"Aging Databases Final.xlsx")

# Get names of all sheets
sheet_names <- excel_sheets(excel_path)

# Read each sheet into a list of data frames
list_of_dataframes <- setNames(lapply(sheet_names, function(name) read_excel(excel_path, sheet = name)), sheet_names)

# Filter if all rows are NA for each PID
list_of_dataframes <- lapply(list_of_dataframes, function(df) {
  df %>% filter(!if_all(-PID, is.na))
})
# Remove the first data frame from the list
list_of_dataframes <- list_of_dataframes[-1]
# Remove the last 8 data frames from the list
#list_of_dataframes <- list_of_dataframes[1:(length(list_of_dataframes) - 8)]

#Remove Vaccine Scores
list_of_dataframes <- list_of_dataframes[!names(list_of_dataframes) %in% c("Vaccine Score SD", "Vaccine Score HD")]
