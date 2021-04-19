rm(list=ls())

# setwd("E:/cnblogs")                                    #設定工作目錄【修改】
setwd(getwd())
PathName = setwd(getwd())
FolderName = c("20210419") 


library(readxl)
Author_list <- read_excel(paste0(PathName,"/author list_Su_3_Lee.xlsx"))

# <U+00A0>
# http://shihs-blog.logdown.com/posts/4773148-how-to-delete-u-00a0-in-r
#NG# Author_list2 <- gsub("\U00A0", "",Author_list)

write.table(Author_list, file=paste0(PathName,"/author list_Su_3_Lee.csv"),  
            sep=",", row.names=FALSE)
