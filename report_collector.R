library(uuid)
library(data.table)

library(ggplot2)

library(DT)
library(knitr)
library(rmarkdown)


# creates labels for the R markdown chunks
label_generator <- function(){
  return(paste0(UUIDgenerate()))
}

# A function that fixes the message string made by functions like retrieve_hit_seqs.R.
# parameters: 
# messageList: The list holding name of files generated by function.
# return:
# cleaned string with the files separated properly.
list_to_string <- function(messageList){
  str <- ""
  for(i in messageList){
    str <- paste0(str,i)
    str <- paste0(str,"\n")
    str <- paste0(str,"<br>")
    str <- paste0(str,"\n")
    
  }
  return(str)
}

# Fixes the format of the function call object for the report. The call objects are the commands that run the functions.
# parameters:
# function_call: The call object that contains function call or command
# return:
# function_call: The cleaned up string that holds function call.
fix_functionCall <- function(function_call){
  function_call <- deparse(function_call)
  function_call <- paste(function_call, collapes = " ")
  function_call <- toString(function_call)
  function_call <- gsub("\\\\",",",function_call)
  function_call <- gsub("\\s*,\\s*",",", function_call)
  function_call <- gsub("\\s+"," ", function_call)
  return(function_call)
}

# Creates a report in rmd.
#Parameters:
# function_call: the function call or the line of code that ran a function by the user
# data_list: A list that contains data from the function ran by the user
#           contents of the list can be paths to csv or html files, or message and files outputted by function.
#           If the function doesn't have those items, then they will have the NULL value in the list
# entry time: The time the function was run by the user
reporter_function <- function(function_call, data_list, entry_time){
  
  # fixes the call object and turns it into a string. 
  function_call <- fix_functionCall(function_call)
  rmd_file <- "blast_history_report.rmd" # name of rmd file
  if(!file.exists(rmd_file)){
    file.create(rmd_file)
    title <- c(
      "---",
      "title: \"BLAST+ History\"",
      "output: html_document",
      "---",
      "\n"
    )
    writeLines(title, rmd_file)
  }
  rmd_content <- readLines(rmd_file)
  
  rmd_content_time <- c(paste0("### ", entry_time))
  rmd_content_new <- c()
  
  # For printing the make_blast_db message
  data_list$message <- gsub("\\\\", "/", data_list$message)
  if(!is.null(data_list$message)){
    make_db_content <- c(
      paste0("#### Function Name: make_blast_db"),
      paste0("```{r ", label_generator(),",eval = FALSE}\n",
             function_call,"\n",
             "```"),
      paste0(data_list$message),
      paste0('\n'),
      print("<br>")
    )
    rmd_content_new <- c(make_db_content)
  }
  
  
  # The time stamp of the entry
  if(!is.null(data_list$data_table)){
    table_content <- c(
      paste0("#### Function Name: blstinr"),
      paste0("```{r ", label_generator(),",eval = FALSE}\n",
             function_call,"\n",
             "```"),
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
    plot_content<- c(
      paste0("#### Function Name: Summarize_bl"),
      paste0("```{r ", label_generator(),",eval = FALSE}\n",
             function_call,"\n",
             "```"),
      paste0("```{r ",label_generator(),", echo=FALSE , out.width = '80%', warning = FALSE}","\n",
                            paste0("knitr::include_url('",data_list$plot_table,"')"),"\n",
                            "```"),
                     ""
    )
    rmd_content_new <- c(plot_content)
  }
  
  
  
  #outputs list of files
  if(!is.null(data_list$output_files)){
    file_list <- list_to_string(data_list$output_files)
    output_content <- c(
      paste0("#### Function Name: retrieve_hit_seqs"),
      paste0("```{r ", label_generator(),",eval = FALSE}\n",
             function_call,"\n",
             "```"),
      paste0(file_list),
      print("<br>")
    )
    
    rmd_content_new <- c(output_content)
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
    
  } 

}


