#############

rm(list = ls()) #清除變數


## Files name setting
# Main file
setwd(getwd()) ## Set current working directory
PathName <- getwd() ## Set output directroy
#PathName = "path/to/your/file"
 


RVersion = "202104020V1"
dir.create(paste0(PathName,"/",RVersion))

## Load files

dataJCR <- read.table(paste0(PathName,"/JournalHomeGrid_2019V2.csv"),  # 資料檔名 
                   header=T,          # 資料中的第一列，作為欄位名稱
                   sep=",")           # 將逗號視為分隔符號來讀取資料
library(readxl)
# dataWS <- read_excel(paste0(PathName,"/20210410 Raw data_merge.xls"))           
dataWS <- read.table(paste0(PathName,"/20210420 Raw data_merge.txt"),  # 資料檔名 
                     header=T)        

dataWS2 <- dataWS

colnames(dataJCR)[3] <-colnames(dataWS)[42]

DeletColNum <- c(3:5,7:8,11:12,15:19,30,48:53,56:57,65:66)

dataWS2 <- dataWS2[,-DeletColNum]

NewTable <- dataWS2
library(dplyr)
NewTable2 <- left_join(NewTable,dataJCR,by=colnames(dataWS)[42])
NewTable3 <- as.data.frame(NewTable2)
  
write.table(NewTable2,file=paste0(PathName,"/",RVersion,"/",RVersion,"_Candidate_Author.txt"),
            row.names = F,col.names = TRUE, sep = '\t')


# Corresponding_Author_List
Corresponding_Author_List <- as.data.frame(NewTable3[,3])

Corresponding_Author_List2 <- list()
for(i in 1:length(Corresponding_Author_List[,1])){
  Corresponding_Author_List2[[i]] <- as.matrix(Corresponding_Author_List[i,1])
}


Corresponding_Author_List3 <- strsplit(as.character(Corresponding_Author_List2), ";")
Corresponding_Author_List4 <- list()
for(i in 1:length(Corresponding_Author_List3)){
  Corresponding_Author_List4[[i]] <- Corresponding_Author_List3[[i]][length(Corresponding_Author_List3[[i]])]
} 

Corresponding_Author_List5 <- t(as.data.frame(Corresponding_Author_List4))
row.names(Corresponding_Author_List5) <- c(1:length(Corresponding_Author_List5))
colnames(Corresponding_Author_List5) <- c("CA_Name")


# Corresponding_Author_Email_List
CorrAut_Email_List <- as.data.frame(NewTable3[,13])

CorrAut_Email_List2 <- list()
for(i in 1:length(CorrAut_Email_List[,1])){
  CorrAut_Email_List2[[i]] <- as.matrix(CorrAut_Email_List[i,1])
}

CorrAut_Email_List3 <- strsplit(as.character(CorrAut_Email_List2), ";")
CorrAut_Email_List4 <- list()
for(i in 1:length(CorrAut_Email_List3)){
  CorrAut_Email_List4[[i]] <- CorrAut_Email_List3[[i]][length(CorrAut_Email_List3[[i]])]
} 

CorrAut_Email_List5 <- t(as.data.frame(CorrAut_Email_List4))
row.names(CorrAut_Email_List5) <- c(1:length(CorrAut_Email_List5))
colnames(CorrAut_Email_List5) <- c("CA_Email")
#datainte_cyto2 <- datainte_cyto2[!grepl("mmu-miR-", datainte_cyto2[,2], ignore.case=TRUE),]
CorrAut_Email_List6  <- gsub(" ", "", CorrAut_Email_List5)

NewTable3 <-cbind(CorrAut_Email_List6,NewTable3)
NewTable3 <-cbind(Corresponding_Author_List5,NewTable3)
NewTable3_2 = unique(NewTable3, by = "CA_Email")

write.table(NewTable3_2,file=paste0(PathName,"/",RVersion,"/",RVersion,"_Candidate_AuthorV2.txt"),
            row.names = F,col.names = TRUE, sep = '\t')

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


#### Screening threshold 
NewTable4 <- NewTable3_2
# Turn to numeric   ## (Note!!) the factor to numeric
NewTable4$Journal.Impact.Factor <- as.numeric(as.character(NewTable4$Journal.Impact.Factor))

# Delet na
NewTable4 <- NewTable4[!is.na(NewTable4$Journal.Impact.Factor),]
NewTable4 <- NewTable4[!is.na(NewTable4$CA_Email),]
#NewTable4 <- NewTable4[!is.na(NewTable4$Journal.Publication.Year),]

#### Screening threshold (Impact.Factor)

  #R1
NewTable5_R1 <- NewTable4[NewTable4$Journal.Impact.Factor > 3 & NewTable4$Journal.Impact.Factor <= 5 ,]
write.table(NewTable5_R1,file=paste0(PathName,"/",RVersion,"/",RVersion,"_Candidate_AuthorV3_TIFR1.txt"),
            row.names = F,col.names = TRUE, sep = '\t')

  #R2
NewTable5_R2 <- NewTable4[NewTable4$Journal.Impact.Factor > 5 & NewTable4$Journal.Impact.Factor <= 7 ,]
write.table(NewTable5_R2,file=paste0(PathName,"/",RVersion,"/",RVersion,"_Candidate_AuthorV3_TIFR2.txt"),
            row.names = F,col.names = TRUE, sep = '\t')

  #R3
NewTable5_R3 <- NewTable4[NewTable4$Journal.Impact.Factor > 1 & NewTable4$Journal.Impact.Factor <= 3 ,]
write.table(NewTable5_R3,file=paste0(PathName,"/",RVersion,"/",RVersion,"_Candidate_AuthorV3_TIFR3.txt"),
            row.names = F,col.names = TRUE, sep = '\t')

#### Screening threshold (Years)
# Turn to numeric   ## (Note!!) the factor to numeric
NewTable4$Publication.Year <- as.numeric(as.character(NewTable4$Publication.Year))
# Delet na
NewTable4 <- NewTable4[!is.na(NewTable4$Publication.Year),]

  #R1
NewTable5_R1_Y1 <- NewTable4[NewTable4$Journal.Impact.Factor > 3 & NewTable4$Journal.Impact.Factor <= 5 & NewTable4$Publication.Year ==2019,]
write.table(NewTable5_R1_Y1,file=paste0(PathName,"/",RVersion,"/",RVersion,"_Candidate_AuthorV3_TIFR1_Y1_2019.txt"),
            row.names = F,col.names = TRUE, sep = '\t')
write.table(NewTable5_R1_Y1,file=paste0(PathName,"/",RVersion,"/",RVersion,"_Candidate_AuthorV3_TIFR1_Y1_2019.csv"),row.names = FALSE,sep = ',')

  #R2
NewTable5_R2_Y1 <- NewTable4[NewTable4$Journal.Impact.Factor > 5 & NewTable4$Journal.Impact.Factor <= 7 & NewTable4$Publication.Year ==2019,]
write.table(NewTable5_R2_Y1,file=paste0(PathName,"/",RVersion,"/",RVersion,"_Candidate_AuthorV3_TIFR2_Y1_2019.txt"),
            row.names = F,col.names = TRUE, sep = '\t')
write.table(NewTable5_R2_Y1,file=paste0(PathName,"/",RVersion,"/",RVersion,"_Candidate_AuthorV3_TIFR2_Y1_2019.csv"),row.names = FALSE,sep = ',')


# #R3
# NewTable5_R3_Y1 <- NewTable4[NewTable4$Journal.Impact.Factor <= 3 & NewTable4$Publication.Year ==2021,]
# write.table(NewTable5_R3_Y1,file=paste0(PathName,"/",RVersion,"/",RVersion,"_Candidate_AuthorV3_TIFR3_Y1.txt"),
#             row.names = F,col.names = TRUE, sep = '\t')
# write.table(NewTable5_R3_Y1,file=paste0(PathName,"/",RVersion,"/",RVersion,"_Candidate_AuthorV3_TIFR3_Y1.csv"),row.names = FALSE,sep = ',')

#R3
NewTable5_R3_Y1 <- NewTable4[NewTable4$Journal.Impact.Factor > 1 & NewTable4$Journal.Impact.Factor <= 3 & NewTable4$Publication.Year ==2019,]
write.table(NewTable5_R3_Y1,file=paste0(PathName,"/",RVersion,"/",RVersion,"_Candidate_AuthorV3_TIFR3_Y1_2019.txt"),
            row.names = F,col.names = TRUE, sep = '\t')
write.table(NewTable5_R3_Y1,file=paste0(PathName,"/",RVersion,"/",RVersion,"_Candidate_AuthorV3_TIFR3_Y1_2019.csv"),row.names = FALSE,sep = ',')


# error
# NewTable4TTT <- NewTable4[-which(NewTable4$Journal.Impact.Factor == "NA"), ]
# NewTable4TTT <- NewTable4[!is.na(NewTable4$Journal.Impact.Factor),]
