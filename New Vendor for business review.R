setwd("G:/SOURCING-CENTRAL/1 - Teams/Analytics/Reporting R Scripts")
source("Functionsforspendcube.R")

read_csv_allcolumns_as_character <- function(filename, skiplines = 0, delimiter = ",", max_rows = Inf) {
  colstr1 <- na.omit(as.character(read_delim(filename, skip = skiplines, delim = delimiter, n_max = max_rows, col_names = FALSE)))
  columnTypes <- paste0(paste0(rep("c", length(colstr1)), collapse = ""))
  file <- read_delim(filename, col_types = columnTypes, delim = delimiter, skip = skiplines, n_max = max_rows)
}
comb_all <- read_csv_allcolumns_as_character("G:/SOURCING-CENTRAL/1 - Teams/Analytics/Outputs/comb_all_fy18_19.csv")

      comb_all1 <- comb_all %>% filter(!is.na(aravo_vendor_id)) %>% filter(invoice_date>"2018-06-30") %>% 
        
       select(aravo_vendor_id, normalized_supplier, unit_name,funds_center, product_category_name,
                                                                           total_amount,invoice_num,invoice_date, source_system, transaction_id)
                                                                           
                                                                     

aravo <- read_csv_allcolumns_as_character("G:/SOURCING-CENTRAL/1 - Teams/Analytics/Outputs/tf_AravoPLBRegistration.csv")
aravo1 <- aravo %>% 
    filter(process_completed > "2018-06-30") %>% filter(!is.na(aravo_vendor_id)) %>% 
  select(aravo_vendor_id, process_completed)

merged <-  inner_join(aravo1,comb_all1, by = c("aravo_vendor_id","aravo_vendor_id"))

write_csv(merged, path = "G:/SOURCING-CENTRAL/1 - Teams/Analytics/Outputs/New_vendors_catalog.csv")