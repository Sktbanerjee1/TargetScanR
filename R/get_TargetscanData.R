
# dependecies
library(jsonlite)
library(data.table)

# Load the prediction data into the R environment
get_targetscan <- function() {
  conf_path <- "conf/targetscan_urls.json"
  
  # Check if the provided config file exists
  if (!file.exists(conf_path)) {
    fatal(logger, "Conf file not found!")
    stop("Conf file not found!")  # Stop execution with an error
  }
  
  # Check if the config file is a JSON file
  if (!grepl("\\.json$", conf_path, ignore.case = TRUE)) {
    fatal(logger, "Conf file is not JSON!")
    stop("Conf file is not JSON!")  # Stop execution with an error
  }
  
  # Validate the integrity of the config JSON
  conf_file <- tryCatch({
    fromJSON(conf_path)
  }, error = function(e) {
    fatal(logger, paste("Failed to load conf file:", e$message))
    stop("Failed to load conf file.")  # Stop execution with an error
  })
  
  info(logger, "Conf file successfully loaded.")
  
  # Get the URL from the conf file
  targetscan_url <- conf_file$data_url
  info(logger, paste("URL retrieved."))
  
  # get the data from the URL
  targetscan_pred_data <- fread(targetscan_url, data.table = F)
  return(targetscan_pred_data)
}