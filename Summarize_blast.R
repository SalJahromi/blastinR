#a function that generates a Sankey plot summarizing categorical 
#information based on taxonomic identifiers from blast search data frames in R

install.packages("htmltools")
install.packages("htmltools", dependencies = TRUE)
packageVersion("htmltools")

install.packages("remotes")

# Update htmltools package from GitHub
remotes::install_github("rstudio/htmltools")

install.packages("networkD3")
install.packages("htmlwidgets")
install.packages("webshot")

webshot::install_phantomjs()
library(dplyr)

library(networkD3)

library(htmlwidgets)
library(webshot)

df1 <- data.frame(
  ID = c(11, 22, 33, 44, 55, 66, 77, 88, 99,14,24,34),
  WatchMovie = c('netflix', 'netflix', 'prime', 'disney', 'prime', 'netflix', 'disney', 'netflix', 'netflix','prime', 'disney', 'prime'),
  Time = c('evening', 'morning', 'morning', 'afternoon', 'evening', 'afternoon', 'morning', 'evening', 'morning','evening', 'afternoon', 'morning'),
  Price = c('high','low','medium','medium','medium','high','medium','high','low','medium','low','medium')
)
df1

summerize_bl <- function(df1, df2, id_col, summarize_cols) {
  # Merge the data frames on ID
  merged_df <- df2 %>%
    left_join(df1, by = c("staxids" = id_col))
  
  # Calculate the total count
  total_count <- nrow(merged_df)
  
  # Summarize the columns
  percentage_df <- merged_df %>%
    group_by(across(all_of(summarize_cols))) %>%
    summarise(count = n(), .groups = 'drop') %>%
    mutate(percentage = (count / total_count) * 100)
  
  # Prepare nodes for Sankey plot
  nodes <- data.frame(name = unique(c("All IDs", unlist(percentage_df[summarize_cols]))))
  
  # Define links
  links <- data.frame()
  for (i in seq_along(summarize_cols)) {
    if (i == 1) {
      links_temp <- percentage_df %>%
        group_by(across(all_of(summarize_cols[i]))) %>%
        summarise(count = sum(count), .groups = 'drop') %>%
        mutate(source = match("All IDs", nodes$name) - 1,
               target = match(!!sym(summarize_cols[i]), nodes$name) - 1,
               pct = (count / total_count) * 100
               ) %>%
        select(source, target, pct)
    } else {
      links_temp <- percentage_df %>%
        mutate(source = match(!!sym(summarize_cols[i - 1]), nodes$name) - 1,
               target = match(!!sym(summarize_cols[i]), nodes$name) - 1,
               pct = (count / total_count) * 100
               )%>%
        select(source, target, pct)
    }
    links <- bind_rows(links, links_temp)
  }
  
  # Convert to plain data frame if needed
  links <- as.data.frame(links)
  
  # Create the sankey plot
 plot <- sankeyNetwork(Links = links, Nodes = nodes,
                Source = "source", Target = "target",
                Value = "pct", NodeID = "name",
                sinksRight = TRUE)

  #save plot as file
 html_outputs_path <- paste0("outputs/png/",timeStamp_global,"_plot.html")
 png_outputs_path <- paste0("outputs/png/",timeStamp_global,"_plot.png")
 results_list <- list(data_table = NULL, plot_table = html_outputs_path)
 function_call <- match.call()
 reporter_function(function_call, results_list, entry_time);
 saveWidget(plot, file = html_outputs_path)
 webshot(html_outputs_path, file = png_outputs_path)
 
 return(plot) 

}


plot1 <- summerize_bl(df1, blast_func, "ID", c("WatchMovie", "Time","Price"))
plot1


