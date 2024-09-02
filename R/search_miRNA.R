# Clear R environment
rm(list = ls())

# About: A script for searching miRNA for known gene targets using the TargetScan predictions

# Dependencies
library(log4r)
library(ggplot2)
library(ggpubr)
library(RColorBrewer)


# Set up basic logging
logger <- create.logger()
logfile(logger) <- stderr()  # Direct logs to standard error/output
level(logger) <- "DEBUG" 

# FUNCTIONS
#------------------------------------------------
source("R/get_TargetscanData.R") # function to load data from targetscan
source("R/get_and_validate_geneNames.R") # function to load and validate gene symbols
source("R/find_top_miRNAs.R") # funtion to find miRNAs that target maximum number of genes in the target list


# SEARCH miRNA
#------------------------------------------------
# get the predicted miRNA targets 
pred_human_data <- get_targetscan()

# get the target genes
gene_list_path <- "GeneTargets.txt"
target_genes <- get_target_genes(gene_list_path = gene_list_path)

# find the top miRNAs that target the genes
top_miRNAs <- find_top_miRNAs(
  targetScan_df = pred_human_data, 
  target_genes = target_genes, 
  species_taxa_id="9606" # NCBI Taxa id for human
  )

# convert the site type information to text
top_miRNAs$`Site Type` <- factor(
  top_miRNAs$`Site Type`, 
  levels = c(1, 2, 3), 
  labels = c("8mer site", "7mer-m8 site", "7mer-1A site")
  )

# VISUALIZATION
# -------------------------------------------
# Site types
p1 <- ggplot(top_miRNAs, aes(
  x = miRNA, y=`Gene Symbol`, fill=as.character(`Site Type`)
)) + geom_tile(color="white") +
  theme_minimal() +
  scale_fill_brewer(name = "Site Type",palette = "Set3") +
   labs(
    title = "miRNA binding site types",
    fill = "Site Type"
  ) +
  theme(
    legend.position = "left",
    plot.title = element_text(hjust = 0.5)
  )

# site efficacy
p2 <- ggplot(top_miRNAs, aes(
  x = miRNA, y=`Gene Symbol`, fill=`context++ score`
)) + geom_tile(color="white") +
  theme_minimal() +
  labs(
    title = "miRNA binding site efficacy",
    subtitle = "Repression is inversely proprtional context++ score"
  ) +
  theme(
    legend.position = "right",
    plot.title = element_text(hjust = 0.5),
    plot.subtitle = element_text(hjust = 0.5)
  ) + scale_fill_gradient2(low="darkgreen", mid = "white", high = "cyan4")

# merge the plots into one plot and write to a file
out_dir <- "results/"
# if the output folder does not exist create this
if(!dir.exists(out_dir)){
  dir.create(out_dir, recursive = T)
}
# write the plot
out_file <- paste0(out_dir, "top_miRNA_",format(Sys.Date(), "%m-%d-%Y"),".svg")
svg(out_file, height = 6, width = 9)
ggpubr::ggarrange(p1, p2)
dev.off()
