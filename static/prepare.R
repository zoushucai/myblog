##### macnote 文件夹
rm(list = ls())
library(stringr)
extract_text = function(inpath='./posts/macnote', ftitle = "mac笔记", outfile= "mac.qmd"){
  filePath = list.files(path = inpath,pattern = '\\.[Rq]{0,1}md$',full.names = T)
  file_title = NULL
  for (i in seq_along(filePath)) {
    temp_file = filePath[i]
    front = rmarkdown::yaml_front_matter(temp_file)
    file_title = c(file_title,front[['title']] )
  }
  
  s0 = str_glue('---\ntitle: "{ftitle}"\ndate: "2022-08-28"\nlang: zh\ntoc: true\nauthor: "zsc"\ntitle-block-banner: true\n---\n')
  s1 = str_glue("[{file_title}]({filePath})")
  
  writeLines(text = c(s0,s1), con =outfile,sep = "\n\n")
  #invisible()
}


if (dir.exists("public/")) {
  #unlink("public/", recursive = TRUE)
  print("成功删除目录: public/")
  

  extract_text('./posts/macnote','mac笔记', 'mac.qmd')
  extract_text('./posts/matlab','matlab笔记', 'matlab.qmd')
  extract_text('./posts/uncertain','uncertain理论笔记', 'uncertain.qmd')
  
}else{
  print("什么都没做")
}
