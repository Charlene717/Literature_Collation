#############

rm(list = ls()) #清除變數


## Files name setting
# Main file
setwd(getwd()) ## Set current working directory
PathName <- getwd() ## Set output directroy
#PathName = "path/to/your/file"
 


RVersion = "20210406V1"
dir.create(paste0(PathName,"/",RVersion))

## Load files

dataJCR <- read.table(paste0(PathName,"/JournalHomeGrid_2019V2.csv"),  # 資料檔名 
                   header=T,          # 資料中的第一列，作為欄位名稱
                   sep=",")           # 將逗號視為分隔符號來讀取資料
library(readxl)
dataWS <- read_excel(paste0(PathName,"/savedrecs_Test2.xls"))           # 將逗號視為分隔符號來讀取資料
dataWS2 <- dataWS

colnames(dataJCR)[3] <-colnames(dataWS)[42]

DeletColNum <- c(3:5,7:8,11:12,15:19,30,48:52,55:68)

dataWS2 <- dataWS2[,-DeletColNum]

NewTable <- dataWS2
library(dplyr)
NewTable2 <- left_join(NewTable,dataJCR,by=colnames(dataWS)[42])
NewTable3 <- as.data.frame(NewTable2)
  
write.table(NewTable3,file=paste0(PathName,"/",RVersion,"/",RVersion,"_Candidate_Author.txt"),
            row.names = F,col.names = TRUE, sep = '\t')

