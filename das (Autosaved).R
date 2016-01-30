library(repmis)
library(dplyr)

filenames <- list(pusa_filename = "ss13pusa.csv", pusb_filename = "ss13pusb.csv",husa_filename = "ss13husa.csv", husb_filename = "ss13husb.csv")
keys <- list(pusa_key = "2bag8q8jp61dsux", pusb_key = "dvvpzk7qj6r5nvb", 
             husa_key = "5uubarlztxpw947", husb_key = "xjzc0noi23zv20j")
pcolumns <- c("AGEP", "CIT", "ENG", "SCHL", "ST", "LANP") # change this to whatever columns we are using

pusa <- source_DropboxData(file = filenames$pusa_filename, key = keys$pusa_key, sep = ",", header = TRUE, cache = TRUE, select = pcolumns)
pusb <- source_DropboxData(file = filenames$pusb_filename, key = keys$pusb_key, sep = ",", header = TRUE, cache = TRUE, select = pcolumns)
