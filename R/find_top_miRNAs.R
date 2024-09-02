

# FIND TOP miRNA candidates
#------------------------------
find_top_miRNAs <- function(targetScan_df, target_genes, species_taxa_id) {
  # Filter the targetScan data to contain only the target genes
  targetScan_df <- targetScan_df[targetScan_df$`Gene Symbol` %in% target_genes,]
  # filter the targetscan data to contain only miRNAs belonging to the specified species
  targetScan_df <- targetScan_df[targetScan_df$`Gene Tax ID`==species_taxa_id,]
  # get the list of unique miRNAs
  unique_miRNA <- unique(targetScan_df$`miRNA`)
  info(logger, paste("Total unique mirna found", length(unique_miRNA)))
  
  # for each unique miRNA identify the genes it can target
  miRNA_targets <- base::lapply(unique_miRNA, function(x){
    miRNA_target_df <- targetScan_df[targetScan_df$`miRNA` == x,]
  })
  
  # count the number of genes targeted by each miRNA
  miRNA_target_count <- sapply(miRNA_targets, function(x){
    length(base::unique(x$`Gene Symbol`))
  })
  # get data for the miRNA with highest gene targets
  max_idx <- which(miRNA_target_count == max(miRNA_target_count))
  # get the top miRNAs with the associated data
  top_miRNAs <- miRNA_targets[max_idx]
  top_miRNAs <- do.call(rbind, top_miRNAs)
}
