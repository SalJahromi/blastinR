library(uuid)
library(data.table)

library(ggplot2)

library(DT)
library(knitr)
library(rmarkdown)


timeStamp_global <- format(Sys.time(), "%Y%m%d%H%M%S")
entry_time <- timestamp(stamp = date(), prefix = "--- ", suffix = " ---", quiet = FALSE)
function_call_sig <- c('function_call')


blast_func <- blstinr('blastx','spike_protein_seqs_SARS','genomes_seqs_SARS.fasta', TRUE)
plot1 <- summerize_bl(df1, blast_func, "ID", c("WatchMovie", "Time","Price"))


result_list <- list(data_table = table_outputs_path, plot_table = png_outputs_path)


report_collector()
reporter_function(function_call_sig, result_list,entry_time)


# collects the results of all functions of blstinR and sends them to the reporter function.
report_collector <- function(result_list, time_stamp){
  
  
  
  result_list <- list(data_table = table_outputs_path, plot_table = png_outputs_path, function_call = cleaned_code)
  
}


