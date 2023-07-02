library(tidyverse)
setwd("C:/Users/Tim/OneDrive - Technische Hochschule Deggendorf/MDH-13 FamHealthConnect/Data Analytics & AI/final_projects")

#Read and Format Data Set
medical_records_dataset <- read.csv("temporary_datasets/medical_records_dataset.csv", header = TRUE, sep = ",")
colnames(medical_records_dataset)[1] = "ID"


final_dataset_raw <- subset(medical_records_dataset, select = -c(sample_name, keywords))
write.csv2(final_dataset_raw, "C:/Users/Tim/OneDrive - Technische Hochschule Deggendorf/MDH-13 FamHealthConnect/Data Analytics & AI/final_projects/temporary_datasets//final_dataset_raw.csv",row.names=FALSE)

#--> Process "final_dataset_raw.csv" with Python: Extract SOAP format from transcription column (result saved as final_dataset.csv)
#[...]



#Clear dataset and keep important rows and columns

final_dataset_python <-  read.csv("temporary_datasets/final_dataset.csv", header = TRUE, sep = ",")


final_dataset_cleaned <- subset(final_dataset_python, select = -c(transcription, medical_specialty, Subjective, Objective, Plan))

final_dataset_cleaned  <- final_dataset_cleaned[!apply(final_dataset_cleaned == "NONE", 1, any), ]


#Creating unique IDs and apply
new_ids <- sample(sprintf("%05d", 10000:99999), length(final_dataset_cleaned$ID))
final_dataset_cleaned$ID <- new_ids

# Remove empty rows from the data frame
remove_empty_assessment <- final_dataset_cleaned$Assessment %in% c("ASSESSMENT AND ", "ASSESSMENT/ ", "ASSESSMENT / ","ASSESSMENT/", "ASSESSMENT & ")
final_dataset_cleaned <- final_dataset_cleaned[!remove_empty_assessment, ]

remove_empty_description <- final_dataset_cleaned$description %in% c(" ")
final_dataset_cleaned <- final_dataset_cleaned[!remove_empty_description, ]

#Add two more columns
final_dataset_cleaned$Simplified_Text <- NA
final_dataset_cleaned$Status <- NA


# Rename the 'description' column to 'Description'
colnames(final_dataset_cleaned)[colnames(final_dataset_cleaned) == "description"] <- "Description"



#Write dataset
write.csv2(final_dataset_cleaned, "C:/Users/Tim/OneDrive - Technische Hochschule Deggendorf/MDH-13 FamHealthConnect/Data Analytics & AI/final_projects/temporary_datasets\\final_dataset_cleaned.csv",row.names=FALSE)


#Add simplified and status rows

simplified_rows <- read.csv("temporary_datasets/final_dataset_cleaned_simplified.csv", header = TRUE, sep = ";")
simplified_rows <- simplified_rows[, 1:2]
simplified_rows <- na.omit(simplified_rows)

final_dataset_cleaned$Simplified_Text <- simplified_rows$Simplified_Text
write.csv2(final_dataset_cleaned, "C:/Users/Tim/OneDrive - Technische Hochschule Deggendorf/MDH-13 FamHealthConnect/Data Analytics & AI/final_projects/temporary_datasets\\final_dataset_cleaned.csv",row.names=FALSE)


### use final_dataset_cleaned.csv for preclassification, then continue

shakes_cakes <- read.csv("preclassification/status_updated.csv", header = TRUE, sep = ",")
write.csv2(shakes_cakes, "C:/Users/Tim/OneDrive - Technische Hochschule Deggendorf/MDH-13 FamHealthConnect/Data Analytics & AI/final_projects/dataset_shakes_cakes.csv",row.names=FALSE)



