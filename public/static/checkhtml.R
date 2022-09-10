### check posts 下是否存在html文件

htmlfile = dir(path = "./posts",pattern = "\\.html$", full.names = F,recursive = T,ignore.case = T)

if (length(htmlfile) != 0) {
  warnings("posts/ 目录下存在html文件")
}else{
  print("posts/ 目录下不存在html文件")
}
