install.packages("rmarkdown")
install.packages("ggplot2")
install.packages("data.table")
install.packages("DT")
install.packages("xfun")

data(cars)
head(cars)
library(uuid)
library(data.table)

library(ggplot2)

library(DT)
library(knitr)
library(rmarkdown)
head(mtcars)
utils::install.packages("rmarkdown")



# may be used for file names so that they can be called up to the correct reprots.
timeStamp_global <- format(Sys.time(), "%Y%m%d%H%M%S")
entry_time <- timestamp(stamp = date(), prefix = "--- ", suffix = " ---", quiet = FALSE)


# png file name
png_outputs_path <- paste0("outputs/png/",timeStamp_global,"_plot.png")
table_outputs_path <- paste0("outputs/table/",timeStamp_global,"_table.csv")



print(png_outputs_path)



power_to_weight_calc <- function(cars_dataset){

  cars_dataset$power_to_weight <- cars_dataset$hp / cars_dataset$wt

  function_call_sig <- match.call()

  plot <- ggplot(cars_dataset,aes(x = wt, y = hp)) + geom_point() + theme_minimal()

  cars_datatable <- (cars_dataset)

  # saveRDS(plot, file = "my_plot.rds")
  ggsave(png_outputs_path, plot = plot, width = 7, height = 5)

  write.table(cars_datatable, file = table_outputs_path, sep = ",", row.names = FALSE, quote = TRUE)

  result_list <- list(data_table = table_outputs_path, plot_table = png_outputs_path)

  reporter_function(function_call_sig, result_list, entry_time)

  return(cars_dataset)
}


label_generator <- function(){
  return(paste0(UUIDgenerate()))
}





# Example usage
reporter_function(function_call_sig, "my_plot.rds")


reporter_function <- function(function_call, data_list, entry_time){

  rmd_file <- "history_markdown_graph_test.rmd" # name of rmd file

  print(data_list$plot_table)

  # The time stamp of the entry
  rmd_content_new <- c(
    paste0("### ", entry_time),
    paste0("```{r ", label_generator(),", echo=FALSE}\n",
          "data <- read.csv('",data_list$data_table,"')\n",
          "datatable(data)\n",
          "```"),
    "",
    paste0("```{r ",label_generator(),", echo=FALSE }","\n",
    paste0("knitr::include_graphics('",data_list$plot_table,"')"),"\n",
    "```")
  )

  # check if the rmd file exists
  if (file.exists(rmd_file)) {
    # reads in what is already in the file
    rmd_content <- readLines(rmd_file)
    
    # combine the new content with the content that was already in the rmd file
    update_content <- c(rmd_content, rmd_content_new)
    
    # write in the new concatenation
    writeLines(update_content, rmd_file)
    
  } else {
    # title of the page
    title <- c(
      "---",
      "title: \"BLAST+ History\"",
      "output: html_document",
      "date: \"`r Sys.Date()`\"",
      "---",
      ""
    )
    
    # create the file and write the title
    writeLines(title, rmd_file)
    
    # read the file created
    rmd_content <- readLines(rmd_file)
    
    # combine the title with the new content
    update_content <- c(rmd_content, rmd_content_new)
    
    # write the combined content to the file
    writeLines(update_content, rmd_file)
  }
  
}


power_to_weight_calc(cars_dataset = cdf)

# Example usage
record_history_plots("cars")



