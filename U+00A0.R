rm(list=ls())

# setwd("E:/cnblogs")                                    #設定工作目錄【修改】
setwd(getwd())
PathName = setwd(getwd())
FolderName = c("20210419") 


library(readxl)
Author_list <- read_excel(paste0(PathName,"/author list_Su_3_Lee.xlsx"))

Author_list2 <- as.matrix(Author_list)
#Author_list3 <- as.character(Author_list2)
Author_list3  <- gsub("\U00A0", "", Author_list2)

# <U+00A0>
# http://shihs-blog.logdown.com/posts/4773148-how-to-delete-u-00a0-in-r
#NG# Author_list2 <- gsub("\U00A0", "",Author_list)

#https://stackoverflow.com/questions/9934856/removing-non-ascii-characters-from-data-files

# x %>% 
#   tibble(name = .) %>%
#   filter(xfun::is_ascii(name)== T)

write.table(Author_list2, file=paste0(PathName,"/author list_Su_3_Lee2.csv"),  
            sep=",", row.names=FALSE)
