install.packages("rmarkdown")
install.packages("ggplot2")
install.packages("data.table")
install.packages("DT")
install.packages("xfun")
data(cars)

head(cars)

library(data.table)

library(ggplot2)

library(DT)
png(filename = "myplot.png", width = 800, height = 600, res = 100)

# plot(cars$speed, cars$dist,
#      main = "Speed vs. Stopping Distance",
#      xlab = "Speed (mph)",
#      ylab = "Stopping Distance (ft)",
#      pch = 19, col = "blue")
data(cars)
plot <- ggplot(cars, aes(x = speed, y = dist)) +
  geom_point(color = "blue") + 
  labs(title = "Speed vs. Stopping Distance",
       x = "Speed (mph)",
       y = "Stopping Distance (ft)") + 
         theme_minimal()

print(plot)
dev.off()

datatable(head(cars))






# Prototype for reading and writing into rmd file.
# Creates an R Markdown file which will contain the function calls and contents within.

record_history_plots <- function(){
  
  rmd_file<- "history_markdown_graph_test.rmd" # name of rmd file
  
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
      paste0("```{r}"),
      "library(ggplot2)",
      "data(cars)",
      "ggplot(cars,aes(x = speed, y = dist)) + geom_point() + theme_minimal()",
      "```",
      ":::"
    )
    
    rmd_png_embedding <- c("```{r include_graphics, echo = FALSE, out.width = '100%'}",
                           "knitr::include_graphics('myplot.png')",
                           "```")
    
    
    data_table <- c("datatable(head(cars))")
    # combine the new content with the content that was already in the rmd file
    update_content <- c(rmd_content, "", rmd_content_new,"",rmd_png_embedding)
    
    # write in the new concatenation
    writeLines(update_content, rmd_file)
    
    # if the file does not already exist
  } else{
    
    # title of the page
    title <- c("---",
               "title: \"BLAST+ History\"",
               "output: html_document",
               "date: \"`r Sys.Date()`\"",
               "---")
    title_fixed = paste(title, collapse = "\n")
    rmd_content <- c(title_fixed,"")
    rcon <- file("history_markdown_graph_test.rmd", "w") # Create Rmarkdown file
    cat(rmd_content, file = rcon) # write the title into the rmd file
    close(rcon)
    
    # read the file created 
    rmd_content <- readLines(rmd_file)
    
    rmd_content_new <- c(
      paste0("#### ", entry_time),
      "",
      "::: {.frame}",
      paste0("```{r}"),
      "library(ggplot2)",
      "data(cars)",
      "ggplot(cars,aes(x = speed, y = dist)) + geom_point() + theme_minimal()",
      "```",
      ":::"
    )
    
    update_content <- c(rmd_content, "", rmd_content_new)
    
    writeLines(update_content, rmd_file)
    
  }
  
  
}



