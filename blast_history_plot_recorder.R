install.packages("rmarkdown")
install.packages("ggplot2")
install.packages("data.table")
install.packages("DT")
install.packages("xfun")

remotes::install_github('rlesur/klippy')
library(klippy)

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
sys_time <- Sys.time() #save the time
timeStamp_global <- format(sys_time, "%Y%m%d%H%M%S") # time stamp for naming output files
entry_time <- timestamp(stamp = sys_time, prefix = "--- ", suffix = " ---", quiet = FALSE) # time stamp for the report




# png file name
png_outputs_path <- paste0("outputs/png/",timeStamp_global,"_plot.png")
table_outputs_path <- paste0("outputs/table/",timeStamp_global,"_table.csv")
html_outputs_path <- paste0("outputs/png/",timeStamp_global,"_plot.html")



print(png_outputs_path)


power_to_weight_calc <- function(cars_dataset){
  # power_to_weight_calc_function_call <- paste(capture.output(deparse(power_to_weight_calc)),collapse = "\n")
  # cleaned_code <- gsub("^\\s*\\[\\d+\\]\\s*\"|\"\\s*$", "", power_to_weight_calc_function_call)
  # function_name <- paste0("outputs/rscripts/power_to_weight_calc",timeStamp_global,".txt")
  # writeLines(power_to_weight_calc_function_call, con = function_name)
  cars_dataset$power_to_weight <- cars_dataset$hp / cars_dataset$wt
  
  # print(cleaned_code)
  function_call_sig <- match.call()
  print(function_call_sig)
  plot <- ggplot(cars_dataset,aes(x = wt, y = hp)) + geom_point() + theme_minimal()

  cars_datatable <- (cars_dataset)

  # saveRDS(plot, file = "my_plot.rds")
  ggsave(png_outputs_path, plot = plot, width = 7, height = 5)

  write.table(cars_datatable, file = table_outputs_path, sep = ",", row.names = FALSE, quote = TRUE)

  result_list <- list(data_table = table_outputs_path, plot_table = png_outputs_path, function_call = cleaned_code)

  reporter_function(function_call_sig, result_list, entry_time)

  return(cars_dataset)

}

power_to_weight_calc("")
# power_to_weight_calc_function_call <- paste(capture.output(deparse(power_to_weight_calc)),collapse = "\n")
# cleaned_code <- gsub("^\\s*\\[\\d+\\]\\s*\"|\"\\s*$", "", power_to_weight_calc_function_call)
# 
# function_name <- paste0("outputs/rscripts/power_to_weight_calc",timeStamp_global,".txt")
# # save(power_to_weight_calc_function_call, file = function_name)
# writeLines(power_to_weight_calc_function_call, con = function_name)


power_to_weight_calc_function_call <- capture.output(deparse(power_to_weight_calc))
power_to_weight_calc_function_call_cleaned <- gsub('^\\s*\\[\\d+\\]\\s*"', '', power_to_weight_calc_function_call)
power_to_weight_calc_function_call_cleaned <- gsub('"\\s*$', '', power_to_weight_calc_function_call)

power_to_weight_calc_function_call_cleaned <- paste(power_to_weight_calc_function_call_cleaned, collapse ="\n")
power_to_weight_calc_function_call_cleaned
writeLines(power_to_weight_calc_function_call_cleaned, con = function_name)

# power_to_weight_calc_function_call <- paste(capture.output(deparse(power_to_weight_calc)),collapse = "\n")
# 
# cleaned_code <- gsub("^\\s*\\[\\d+\\]\\s*\"|\"\\s*$", "", power_to_weight_calc_function_call)
# formatted_code <- paste(cleaned_code, collapse = "\n")
# cleaned_code
# cat(formatted_code)


power_to_weight_calc_function_call

label_generator <- function(){
  return(paste0(UUIDgenerate()))
}





# Example usage
reporter_function(function_call_sig, "my_plot.rds")


reporter_function <- function(function_call, data_list, entry_time){

  rmd_file <- "history_markdown_graph_test.rmd" # name of rmd file

  rmd_content <- readLines(rmd_file)
  rmd_content_time <- c(paste0("### ", entry_time))
  rmd_content_new <- c()
  # The time stamp of the entry
  if(!is.null(data_list$data_table)){
    table_content <- c(
      paste0(cat(data_list$function_call)),
      paste0("```{r ", label_generator(),", echo=FALSE,warning = FALSE}\n",
             "library(DT)\n",
             "data <- read.csv('",data_list$data_table,"')\n",
             "datatable(data)\n",
             "```"),
      print("<br>"),
      ""
    )
    rmd_content_new <- c(table_content);
  }

  # if plot_table is not null, then it contains a plot
  if(!is.null(data_list$plot_table)){
    plot_content<- c(paste0("```{r ",label_generator(),", echo=FALSE , out.width = '80%', warning = FALSE}","\n",
           paste0("knitr::include_url('",data_list$plot_table,"')"),"\n",
           "```"),
           ""
    )
    rmd_content_new <- c(plot_content)
  }
  
  # check if the rmd file exists
  if (file.exists(rmd_file)) {
    # reads in what is already in the file
    rmd_content <- readLines(rmd_file)
    
    
    # combine the new content with the content that was already in the rmd file
    if(all(rmd_content_time %in% rmd_content)){
      update_content <- c(rmd_content, rmd_content_new)
    }
    else{
      update_content <- c(rmd_content, rmd_content_time, rmd_content_new)
      
    }

    # write in the new concatenation
    writeLines(update_content, rmd_file)
    
  } else {
    # title of the page
    title <- c(
      "---",
      "title: \"BLAST+ History\"",
      "output: html_document",
      "---",
      "\n"
    )
    
    # create the file and write the title
    writeLines(title, rmd_file)
    
    # read the file created
    rmd_content <- readLines(rmd_file)
    
    # combine the title with the new content
    update_content <- c(rmd_content, table_content)
    
    # write the combined content to the file
    writeLines(update_content, rmd_file)
  }
  
}



power_to_weight_calc(cars_dataset = cdf)

# Example usage
record_history_plots("cars")




# else {
#   # title of the page
#   file.create(rmd_file)
#   title <- c(
#     "---",
#     "title: \"BLAST+ History\"",
#     "output: html_document",
#     "---",
#     "\n"
#   )
#   
#   # create the file and write the title
#   writeLines(title, rmd_file)
#   
#   # read the file created
#   rmd_content <- readLines(rmd_file)
#   
#   # combine the title with the new content
#   update_content <- c(rmd_content, table_content)
#   
#   # write the combined content to the file
#   writeLines(update_content, rmd_file)
# }
# 

