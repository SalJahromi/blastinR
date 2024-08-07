# a function to retrieve the hit sequence from blast search results from within R
# Parameters: 
# query_ids: a vector of query IDs
# blast_results: a data frame of blast search results
# blastdb: blast database file path/name
# outfile: output file name
# Returns: 
# Hit sequences as a vector of characters
<<<<<<< HEAD

retrieve_hit_seqs <- function(query_ids, blast_results, blastdb, NumHitseqs = 1, outfile, cut_seq = TRUE, MultFiles = FALSE) {
  
  function_call_sig <- match.call()
  Directory_check()
  directory_path <- "outputs/hits/"
  
  filenames_list <- list()
=======
retrieve_hit_seqs <- function(query_ids, blast_results, blastdb, outfile, cut_seq = TRUE) {
>>>>>>> 0aa4be7967ebf825536d2377e743dde8cbcc8c93
  
  # Initialize a character vector to store the output
  output_lines <- character()
  
<<<<<<< HEAD
  # To store all output lines
  output_all <- character()
  
=======
>>>>>>> 0aa4be7967ebf825536d2377e743dde8cbcc8c93
  # Loop through each query ID
  for (query_id in query_ids) {
    
    # Subset the blast results for the current query 
    query_results <- blast_results[blast_results$qseqid == query_id, ]
<<<<<<< HEAD
    
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
        cut_seqs <- substr(full_sequence, sstart, send)
        
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
  
  time <- time_func()
  Directory_check()
  results_list <- list(data_table = NULL, plot_table = NULL, message = NULL, output_files = filenames_list)
  reporter_function(function_call_sig, results_list, time[[2]]);
  
  
  # Return the output lines (optional, if needed for further processing)
  return(output_all)
}
=======
    
    # Extract the hit sequence ID assuming it is the first one in the result
    hitSeq <- query_results$sseqid[1]
    
    # Use blastdbcmd to retrieve the hit sequence
    hit_sequence <- system2(
      command = "blastdbcmd",
      args = c("-db", blastdb, "-entry", hitSeq),
      stdout = TRUE,
      wait = TRUE
    )
    
    sequence_lines <- hit_sequence[-1]  # Skip the first line (header)
    full_sequence <- paste(sequence_lines, collapse = "")
    
    if(cut_seq == TRUE){
    
    # Extract the start and end positions from query_results
    sstart <- query_results$sstart[1]
    send <- query_results$send[1]
    cut_seqs <- substr(full_sequence, sstart, send)
    
    # Append query ID and hit sequence ID to output_lines
    output_lines <- c(output_lines, paste(">", hitSeq, "__queryID:", query_id, "_sstart:", sstart, "_send:", send, sep = ""))
    
    # Append hit sequence to output_lines
    output_lines <- c(output_lines, cut_seqs)
    }
    
    else{
    # Append query ID and hit sequence ID to output_lines
    output_lines <- c(output_lines, paste(">", hitSeq, "__queryID:", query_id, sep = ""))
    
    # Append hit sequence to output_lines
    output_lines <- c(output_lines, full_sequence)
    
  }
  }
  # Write output_lines to a text file
  writeLines(output_lines, con = outfile)
  
  # Return the output lines
  return(output_lines)
}

>>>>>>> 0aa4be7967ebf825536d2377e743dde8cbcc8c93
