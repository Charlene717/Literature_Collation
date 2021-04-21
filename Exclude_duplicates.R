#############

rm(list = ls()) #清除變數


## Files name setting
# Main file
setwd(getwd()) ## Set current working directory
PathName <- getwd() ## Set output directroy
#PathName = "path/to/your/file"

FloderName_Old <- "#_Sendied mail" #_Sendied mail
FloderName_New <- "202104021V1" 
FloderName_New_Sub = "R1_2018_author list"

dir.create(paste0(PathName,"/",FloderName_New,"/",FloderName_New_Sub))


## Load New files
Author_list_New <- read.csv(paste0(PathName,"/",FloderName_New,
                                     "/202104021V1_Candidate_AuthorV3_TIFR1_Y1_2018.csv"),  # 資料檔名 
                                    header=T)         # 資料中的第一列，作為欄位名稱

#

## Read Old files
first_category_name = list.files(FloderName_Old)            #list.files命令得到"OOOP”文件夾下所有文件夾的名稱【修改】
dir = paste("/",FloderName_Old ,"/",first_category_name,sep="")   #用paste命令構建路徑變數dir,第一級目錄的詳細路徑【修改】
n = length(dir)                                       #讀取dir長度，也就是：總共有多少個一級目錄                                                     

n_sub<-rep(0,n)
n_sub<-as.data.frame(n_sub)
n_sub<-t(n_sub)
head(n_sub)                                          #n_sub是每個一級目錄(文件夾)下有多少個文件，也就是：有多少個二級目錄，初始化為0，用於後面的操作

##########
library(readxl)
library(dplyr)

#merge_1 <- read.csv(paste0(PathName,dir[1]))
merge_1 <- list()
for(i in 1:n){         #對於每個一級目錄(文件夾)
#  b=list.files(dir[i]) #b是列出每個一級目錄(文件夾)中每個xlsx文件的名稱
#  n_sub[i]=length(b)   #得到一級目錄(文件夾)下xlsx的文件個數:n_sub
  
  new_1 <- read.csv(paste0(PathName,dir[i])) #讀取csv文件

  
  merge_1<- rbind(merge_1,new_1)
}

unique_Email2 <- merge_1[!duplicated(merge_1$`EMail`), ]

######################################################################

Author_list_New2 <- Author_list_New[,1:6]
colnames(Author_list_New2) <- colnames(unique_Email2)
library(dplyr)
Author_list_New3 <- dplyr::anti_join(Author_list_New2,unique_Email2,by="EMail")
write.table(Author_list_New3,file=paste0(PathName,"/",FloderName_New,"/",FloderName_New_Sub,"/",
                                         FloderName_New ,"_",FloderName_New_Sub,"_All.csv"),
                                         row.names = FALSE,sep = ',')

######################################################################
GroupNum <- ceiling(length(Author_list_New3[,1])/100)
Author_list_New3_Part <- list()

for(i in 1:GroupNum){
  Author_list_New3_Part[[i]] <- Author_list_New3[(i*100-100+1):(i*100),]
  Author_list_New3_Part[[i]] <- na.omit(Author_list_New3_Part[[i]]) #刪除有空值的行
  write.table(Author_list_New3_Part[[i]],file=paste0(PathName,"/",FloderName_New,"/",FloderName_New_Sub,"/",
                                           FloderName_New ,"_",FloderName_New_Sub,"_P",i,".csv"),
              row.names = FALSE,sep = ',')
 }

