# a function to retrieve the hit sequence from blast search results from within R
# Parameters: 
# query_ids: a vector of query IDs
# blast_results: a data frame of blast search results
# blastdb: blast database file path/name
# outfile: output file name
# Returns: 
# Hit sequences as a vector of characters

retrieve_hit_seqs <- function(query_ids, blast_results, blastdb, NumHitseqs = 1, outfile, cut_seq = TRUE, MultFiles = FALSE, report = TRUE) {
  
  function_call_sig <- match.call()
  Directory_check()
  directory_path <- "outputs/hits/"
  
  filenames_list <- list()
  
  # Initialize a character vector to store the output
  output_lines <- character()
  
  # To store all output lines
  output_all <- character()
  
  # Loop through each query ID
  for (query_id in query_ids) {
    
    # Subset the blast results for the current query 
    query_results <- blast_results[blast_results$qseqid == query_id, ]
    
    # Loop through each hit sequence for the current query ID
    for (i in 1:min(NumHitseqs, nrow(query_results))) {
      
      # Extract the hit sequence ID
      hitSeq <- query_results$sseqid[i]
      
      # Use blastdbcmd to retrieve the hit sequence
      hit_sequence <- system2(
        command = "blastdbcmd",
        args = c("-db", blastdb, "-entry", hitSeq),
        stdout = TRUE,
        wait = TRUE
      )
      
      sequence_lines <- hit_sequence[-1]  # Skip the first line (header)
      full_sequence <- paste(sequence_lines, collapse = "")
      
      if (cut_seq == TRUE) {
        # Extract the start and end positions from query_results
 
        sstart <- query_results$sstart[i]
        send <- query_results$send[i]
        # +strand
        if(sstart < send){
          cut_seqs <- substr(full_sequence, sstart, send)
        }
        # -strand handling. Reverses the sequence within the range.
        else{
          temp = sstart
          sstart = send
          send = tmep
          cut_unreversed <- substr(full_sequence, sstart, send)
          cut_seqs <- paste(rev(strsplit(cut_unreversed, NULL)[[1]]), collapse = "")
        }

        
        # Append query ID and hit sequence ID to output_lines
        output_lines <- c(output_lines, paste(">", hitSeq, "__queryID:", query_id, "_sstart:", sstart, "_send:", send, sep = ""))
        
        # Append hit sequence to output_lines
        output_lines <- c(output_lines, cut_seqs)
        
      } else {
        # Append query ID and hit sequence ID to output_lines
        output_lines <- c(output_lines, paste(">", hitSeq, "__queryID:", query_id, sep = ""))
        
        # Append hit sequence to output_lines
        output_lines <- c(output_lines, full_sequence)
      }
      
    }
    output_all <- c(output_all, output_lines)
    
    # If MultFiles is TRUE, write each query to a separate file
    if (MultFiles) {
      # Create a filename based on query ID and write output_lines to a file
      filename <- paste(directory_path, outfile, "_", query_id, ".fasta", sep = "")
      writeLines(output_lines, con = filename)
      
      filenames_list[[length(filenames_list) + 1]] <- filename
      
      # Clear output_lines for the next query ID
      output_lines <- character()
    }
    
  }
  
  # Write output_lines to a single text file if MultFiles is not TRUE
  if (!MultFiles) {
    filename <- paste(directory_path, outfile, ".fasta", sep = "") 
    writeLines(output_lines, con = filename)
    
    filenames_list[[length(filenames_list) + 1]] <- filename
  }
  
  if(report == TRUE){
    time <- time_func()
    Directory_check()
    results_list <- list(data_table = NULL, plot_table = NULL, message = NULL, output_files = filenames_list)
    reporter_function(function_call_sig, results_list, time[[2]]);
  }

  
  # Return the output lines (optional, if needed for further processing)
  return(output_all)
}

qry_ids <- c("Bat_coronavirus")

cc<- retrieve_hit_seqs(qry_ids, blast_func, "spike_protein_seqs_SARS", 6, "prot_hit_OneFile", TRUE, FALSE, FALSE)



