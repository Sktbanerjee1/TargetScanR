# dependencies
library(org.Hs.eg.db) # human gene database

# VALIDATION
#------------------------------------------
# function to validate human gene names
validate_human_gene_names <- function(genes) {
  # Get all valid gene symbols from the database
  gene_global <- keys(org.Hs.eg.db, keytype = "SYMBOL")
  # check if the provided gene symbol is valid
  gene_validation <- sapply(genes, function(x){
    if(x %in% gene_global){
      return(TRUE)
    } else{
      return(FALSE)
    }
  })
  return(gene_validation)
}

# PARSE GENE NAMES
# --------------------------------
get_target_genes <- function(gene_list_path){
  # if the provided gene list file exists
  if(file.exists(gene_list_path)){
    gene_list <- readLines(gene_list_path)
    # check if the provided gene symbols are valid
    gene_name_validation <- validate_human_gene_names(gene_list)
    # create a data frame 
    gene_validation <- data.frame(Name = gene_list, Valid = gene_name_validation)
    # generate log of the gene validation
    if(!all(gene_validation$Valid)){
      invalid_genes <- gene_validation[gene_validation$Valid == FALSE, "Name"]
      warn(logger, paste("Invalid gene name found:", paste(invalid_genes, collapse = ", ")))
    } else{
      info(logger, "All gene names are valid")
    }
  } else {
    stop("The provided file path does not exist.")
  }
  valid_genes <- gene_validation[gene_validation$Valid == TRUE, "Name"]
  return(valid_genes)
}
