
# Prototype for reading and writing into rmd file.
# Creates an R Markdown file which will contain the function calls and contents within.

record_history <- function(){
  
  rmd_file<- "history_markdown.rmd" # name of rmd file
  
  # The time stamp of the entry
  entry_time <- timestamp(stamp = date(), prefix = "##--- ", suffix = " ---##", quiet = FALSE)
  
  # if the file exists, will add new content
  if(file.exists(rmd_file)){
    rmd_content <- readLines(rmd_file) # reads in what is already in the file
    
    # new entry
    rmd_content_new <- c(
      paste0("#### ", entry_time),
      "",
      "::: {.frame}",
      paste0("```{r ", entry_time, "}"),
      "print('hello world')",
      "```",
      ":::"
    )
    
    # combine the new content with the content that was already in the rmd file
    update_content <- c(rmd_content, "", rmd_content_new)
    
    # write in the new concatenation
    writeLines(update_content, rmd_file)
    
  # if the file does not already exist
  } else{
    
    # title of the page
    title <- c("# <>BLAST+ HISTORY<> \n")
    
    
    rmd_content <- c(title,"")
    rcon <- file("history_markdown.Rmd", "w") # Create Rmarkdown file
    cat(rmd_content, file = rcon) # write the title into the rmd file
    close(rcon)
    
    # read the file created 
    rmd_content <- readLines(rmd_file)
    
    rmd_content_new <- c(
      paste0("#### ", entry_time),
      "",
      "::: {.frame}",
      paste0("```{r ", entry_time, "}"),
      "print('hello world')",
      "```",
      ":::"
    )
    
    update_content <- c(rmd_content, "", rmd_content_new)
    
    writeLines(update_content, rmd_file)
    
  }
  
  
}


