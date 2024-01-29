library(readxl)
library(purrr)
library(dplyr)
library(ggplot2)
library(ggfortify)
library(factoextra)

# Path to your Excel file
#### Paths
in.path <- 'C:/Users/axi313/Desktop/Analysis/Sheldon/Ageing 11292023/Input/'
out.path <- 'C:/Users/axi313/Desktop/Analysis/Sheldon/Ageing 11292023/Output/'
excel_path_1 <- paste0(in.path,"Aging Isotype.xlsx")
excel_path_2 <- paste0(in.path,"Aging Titre.xlsx")

# Get names of all sheets
sheet_names_1 <- excel_sheets(excel_path_1)
sheet_names_2 <- excel_sheets(excel_path_2)

# Read each sheet into a list of data frames
list_of_dataframes_1 <- setNames(lapply(sheet_names_1, function(name) read_excel(excel_path_1, sheet = name)), sheet_names_1)
list_of_dataframes_2 <- setNames(lapply(sheet_names_2, function(name) read_excel(excel_path_2, sheet = name)), sheet_names_2)

# Filter if all rows are NA for each PID
list_of_dataframes_1 <- lapply(list_of_dataframes_1, function(df) {
  df %>% filter(!if_all(-PID, is.na))
})
list_of_dataframes_2 <- lapply(list_of_dataframes_2, function(df) {
  df %>% filter(!if_all(-PID, is.na))
})


# Remove the first data frame from the list
list_of_dataframes_1 <- list_of_dataframes_1[-1]

list_of_dataframes_1[[17]]
# Standardize Column Names for Standard Dose and High Dose dataframes
# Loop through databases 2 to 17 to standardize column names
for (i in 2:17) {
  # Assuming each dataframe has the same structure with PID and three timepoints
  colnames(list_of_dataframes_1[[i]]) <- c("PID", "T0", "T3", "T4")
}

##### PCA #########
# Assuming your list of databases is stored in list_of_dataframes_1
# Clean the Demographics Dataframe
demographics <- list_of_dataframes_1[[1]][, !(names(list_of_dataframes_1[[1]]) %in% c("Season SD", "Season HD"))]

# Function to calculate mode
getMode <- function(v) {
  uniqv <- unique(na.omit(v))
  uniqv[which.max(tabulate(match(v, uniqv)))]
}

# Function to create PCA plot and save it
create_pca_plot <- function(data, title) {

  pca_plot <- ggplot(plot_data, aes(x = PC1, y = PC2, color = `HIV status`, shape = `dose_type`)) +
    geom_point(alpha = 0.6) +
    scale_color_manual(values = c("Positive" = "red", "Negative" = "blue"),
                       name = "HIV Status",
                       breaks = c("Positive", "Negative")) +
    scale_shape_manual(values = c("High" = 17, "Standard" = 16),
                       name = "Dose Type",
                       breaks = c("High", "Standard")) +
    geom_vline(xintercept = 0, linetype = "dashed") +
    geom_hline(yintercept = 0, linetype = "dashed") +
    theme_minimal() +
    ggtitle(title) +
    stat_ellipse(data = plot_data, aes(x = PC1, y = PC2, fill = dose_type, group = dose_type), 
                 geom = "polygon", level = 0.95, alpha = 0.2) +
    scale_fill_manual(values = c("Standard" = "lightblue", "High" = "lightgreen"),
                      name = "Dose Type",
                      breaks = c("High", "Standard"))
}

# Function to create PCA plot
create_pca_subplot <- function(data, title) {
  ggplot(data, aes(x = PC1, y = PC2, color = `Age Group`, shape = `dose_type`)) +
    geom_point(alpha = 0.6) +
    scale_color_manual(values = c("Old" = "orange", "Young" = "purple")) +
    scale_shape_manual(values = c("Standard" = 16, "High" = 17)) +
    stat_ellipse(aes(fill = dose_type, group = dose_type), geom = "polygon", level = 0.95, alpha = 0.2) +
    scale_fill_manual(values = c("Standard" = "lightblue", "High" = "lightgreen")) +
    geom_vline(xintercept = 0, linetype = "dashed") +
    geom_hline(yintercept = 0, linetype = "dashed") +
    theme_minimal() +
    ggtitle(title)
}

# Main loop for processing each SD and HD pair
for (i in seq(2, 17, by = 2)) {
  # Prepare Standard and High Dose Dataframes
  standard_dose <- list_of_dataframes_1[[i]]
  standard_dose$dose_type <- 'Standard'
  
  high_dose <- list_of_dataframes_1[[i + 1]]
  high_dose$dose_type <- 'High'
  
  # Combine Standard Dose and High Dose dataframes
  combined_doses <- rbind(standard_dose, high_dose)
  
  # Merge with Demographics
  demographics <- list_of_dataframes_1[[1]]
  final_data <- merge(demographics, combined_doses, by = "PID", all.x = TRUE)
  
  # Filter out rows with all NA in specific columns
  rows_with_all_na <- rowSums(is.na(final_data[c("T0", "T3")])) == 2
  final_data_clean <- final_data[!rows_with_all_na, ]
  final_data_clean <- subset(final_data_clean, select = -T4)
  final_data_clean <- subset(final_data_clean, select = -Age)
  
  # Impute Missing Data
  # Mode Imputation for Categorical Variables
  final_data_clean$Ethnicity[is.na(final_data_clean$Ethnicity)] <- getMode(final_data_clean$Ethnicity)
  final_data_clean$Race[is.na(final_data_clean$Race)] <- getMode(final_data_clean$Race)
  
  # Median imputation for numeric variables
  for (col in names(final_data_clean)) {
    if (is.numeric(final_data_clean[[col]])) {
      final_data_clean[[col]][is.na(final_data_clean[[col]])] <- median(final_data_clean[[col]], na.rm = TRUE)
    }
  }
  final_data_clean$`HIV status`[final_data_clean$`HIV status` == "Control"] <- "Negative"
  
  # Perform PCA
  final_data_pca <- prcomp(final_data_clean[, sapply(final_data_clean, is.numeric)], center = TRUE, scale. = TRUE)
  
  # Extract PCA scores
  pca_scores <- as.data.frame(final_data_pca$x)
  plot_data <- cbind(pca_scores, final_data_clean[, c("HIV status", "Age Group", "dose_type")])
  
  # Create PCA plot
  pair_name <- gsub(" ", "_", names(list_of_dataframes_1)[i])
  pair_name <- gsub("_SD_", "_", pair_name)
  # Create and save PCA plot
  overall_pca_plot <- create_pca_plot(plot_data, paste0("Overall ",pair_name," PCA"))
  ggsave(paste0("Overall_PCA_", pair_name, ".png"), overall_pca_plot, width = 10, height = 8, path=out.path, bg = "white")
  
  # Create and Save PCA subplot
  # Subset data for HIV Positive and Negative
  hiv_positive_data <- subset(plot_data, `HIV status` == "Positive")
  hiv_negative_data <- subset(plot_data, `HIV status` == "Negative")
  # Create and display plots for HIV Positive and HIV Negative
  pca_plot_hiv_positive <- create_pca_subplot(hiv_positive_data, paste("HIV Positive - ", pair_name))
  pca_plot_hiv_negative <- create_pca_subplot(hiv_negative_data, paste("HIV Negative - ", pair_name))
  
  # Save the HIV status specific plots
  ggsave(paste0("HIV_Positive_PCA_", pair_name, ".png"), pca_plot_hiv_positive, width = 10, height = 8, path=out.path, bg = "white")
  ggsave(paste0("HIV_Negative_PCA_", pair_name, ".png"), pca_plot_hiv_negative, width = 10, height = 8, path=out.path, bg = "white")
}

