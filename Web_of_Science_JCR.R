#############

rm(list = ls()) #清除變數


## Files name setting
# Main file
setwd(getwd()) ## Set current working directory
PathName <- getwd() ## Set output directroy
#PathName = "path/to/your/file"
 


RVersion = "20210406V2"
dir.create(paste0(PathName,"/",RVersion))

## Load files

dataJCR <- read.table(paste0(PathName,"/JournalHomeGrid_2019V2.csv"),  # 資料檔名 
                   header=T,          # 資料中的第一列，作為欄位名稱
                   sep=",")           # 將逗號視為分隔符號來讀取資料
library(readxl)
dataWS <- read_excel(paste0(PathName,"/savedrecs_Test2.xls"))           # 將逗號視為分隔符號來讀取資料
dataWS2 <- dataWS

colnames(dataJCR)[3] <-colnames(dataWS)[42]

DeletColNum <- c(3:5,7:8,11:12,15:19,30,48:53,56:57,65:66)

dataWS2 <- dataWS2[,-DeletColNum]

NewTable <- dataWS2
library(dplyr)
NewTable2 <- left_join(NewTable,dataJCR,by=colnames(dataWS)[42])
NewTable3 <- as.data.frame(NewTable2)
  
write.table(NewTable3,file=paste0(PathName,"/",RVersion,"/",RVersion,"_Candidate_Author.txt"),
            row.names = F,col.names = TRUE, sep = '\t')


# Corresponding_Author_List
Corresponding_Author_List <- as.data.frame(NewTable3[,3])
colnames(Corresponding_Author_List) <- c("Corresponding_Author")

Corresponding_Author_List2 <- list()
for(i in 1:length(Corresponding_Author_List[,1])){
  Corresponding_Author_List2[[i]] <- as.matrix(Corresponding_Author_List[i,1])
}


Corresponding_Author_List3 <- strsplit(as.character(Corresponding_Author_List2), ";")


Corresponding_Author_List4 <- list()
for(i in 1:length(Corresponding_Author_List3)){
  Corresponding_Author_List4[[i]] <- Corresponding_Author_List3[[i]][length(Corresponding_Author_List3[[i]])]
} 






# #Separate word
# library(tidyr)
# 
# #Corresponding_Author_List2 <- as.list.data.frame(Corresponding_Author_List)
# Corresponding_Author_List2 <- separate(Corresponding_Author_List, Corresponding_Author, 
#                                        as.character(1:100), ";")
# Corresponding_Author_List2 <-strsplit(Corresponding_Author_List, ";", fixed = TRUE)
# 
# new.dataC3 <- separate(dataC3, samples, c( "SampleType","SampleBarcode"), "_")
# dataC2[,3:4] <- new.dataC3[,1:2]
