setwd("G:/SOURCING-CENTRAL/1 - Teams/Analytics/Reporting R Scripts")
source("Functionsforspendcube.R")

aravo_all <- read_csv("G:/SOURCING-CENTRAL/1 - Teams/Systems/2 - Aravo  QUALTRICS/Aravo All/All_locations.csv")
aravo_all1 <- aravo_all %>% select(supplierid,locationname,name,address1,address2,city,region,zip,country) %>% 
 filter(locationname == "Primary Location")

comb_all <- read_csv("G:/SOURCING-CENTRAL/1 - Teams/Analytics/Outputs/comb_all_fy18_19.csv")
comb_all1 <-  comb_all %>% filter(invoice_date > "2018-06-30" ) %>% filter(!is.na(aravo_vendor_id)) %>% 
  select(aravo_vendor_id,supplier,total_amount)

merged <- inner_join(aravo_all1,comb_all1, by = c("supplierid" ="aravo_vendor_id"))
merged1 <- merged %>% group_by(supplierid,name,address1,address2,city,region,zip,country) %>% 
  summarise(total = sum(total_amount))

write_csv(merged1,"G:/SOURCING-CENTRAL/1 - Teams/Analytics/Outputs/Supplierinfo_amount.csv"")