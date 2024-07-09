library(uuid)
library(data.table)

library(ggplot2)

library(DT)
library(knitr)
library(rmarkdown)


sys_time <- Sys.time() #save the time
timeStamp_global <- format(sys_time, "%Y%m%d%H%M%S") # time stamp for naming output files
entry_time <- timestamp(stamp = sys_time, prefix = "--- ", suffix = " ---", quiet = FALSE) # time stamp for the report



blast_func <- blstinr('blastx','spike_protein_seqs_SARS','genomes_seqs_SARS.fasta', TRUE)
plot1 <- summerize_bl(df1, blast_func, "ID", c("WatchMovie", "Time","Price"))



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


