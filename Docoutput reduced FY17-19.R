## set directory to import packages

setwd("G:/SOURCING-CENTRAL/1 - Teams/Analytics/Reporting R Scripts")
source("Functionsforspendcube.R")

## function for reading the docoutput file column values as characters 

read_csv_allcolumns_as_character <- function(filename, skiplines = 0, delimiter = ",", max_rows = Inf) {
  colstr1 <- na.omit(as.character(read_delim(filename, skip = skiplines, delim = delimiter, n_max = max_rows, col_names = FALSE)))
  columnTypes <- paste0(paste0(rep("c", length(colstr1)), collapse = ""))
  file <- read_delim(filename, col_types = columnTypes, delim = delimiter, skip = skiplines, n_max = max_rows)
}
## creates docoutput file

docoutput <- read_csv_allcolumns_as_character("G:/SOURCING-CENTRAL/1 - Teams/Analytics/Outputs/tf_docoutput_rversion_nv.csv")


## function for reading the po details file column value as characters

read_csv_allcolumns_as_character <- function(filename, skiplines = 0, delimiter = ",", max_rows = Inf) {
  colstr1 <- na.omit(as.character(read_delim("G:/SOURCING-CENTRAL/1 - Teams/Analytics/Outputs/tf_podetails.csv", skip = skiplines, delim = delimiter, n_max = max_rows, col_names = FALSE)))
  columnTypes <- paste0(paste0(rep("c", length(colstr1)), collapse = ""))
  file <- read_delim("G:/SOURCING-CENTRAL/1 - Teams/Analytics/Outputs/tf_podetails.csv", col_types = columnTypes, delim = delimiter, skip = skiplines, n_max = max_rows)
}

## creates podetails file 

podetails <- read_csv_allcolumns_as_character("G:/SOURCING-CENTRAL/1 - Teams/Analytics/Outputs/tf_podetails.csv")  

## filtering only requried columns and values from the docoutput file 

docoutput_new <-  docoutput %>% 
  select(document_number,po_created_by,po_creation_date.y,sc_date_dif, buyer_approval_date,sc_max_approval_date,
         po_created_by,SC_approverkey_list,po_date_dif,po_version, po_funds_center,sc_creation_date, created_on,
         senior_buyer_approval_date_dif,po_vendor_name,catalog)

docoutput_new1 <- docoutput_new %>%   
  
  mutate(po_creation_date.y = mdy(po_creation_date.y))  %>%
  filter(po_creation_date.y > "2016-06-30") %>% filter(po_created_by == "AHARE06" | po_created_by == "NKOONTZ" |
                                                         po_created_by == "TMOUNT" | po_created_by == "SHUKRIO" |
                                                         po_created_by == "DATREMBL" | po_created_by == "JPFIORE"| 
                                                         po_created_by == "JGWILKIE" | po_created_by == "MILYONS"| !is.na(SC_approverkey_list))

## filtering only requried columns and values from the po details file 

podetails1 <- podetails %>% select(purchase_order_number,po_valuenet)


## merging docoutput and podetails file using inner join 

merged_docouput_podetails <- inner_join(docoutput_new1, podetails1, by = c("document_number" = "purchase_order_number"))

write_csv(merged_docouput_podetails, path = "G:/SOURCING-CENTRAL/1 - Teams/Analytics/Outputs/Docoutput_ReducedFY17-19.csv")








