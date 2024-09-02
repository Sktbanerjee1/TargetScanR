# TargetScanR

A set of R scripts to identify miRNA against known gene targets using the [Targetscan](https://www.targetscan.org/) predictions.

## Background:

**Targetscan** is a set of predictive methods that aid in the identification of miRNA(s) that are likely to target a region (genes/transcripts) within a known genome.

Detailed method leading to the prediction of miRNA binding sites can be found in the original articles:

-   [Original implementation](http://genome.cshlp.org/content/19/1/92.full.pdf)

-   [Extention of the original parameters to suit worm and fly genomes](http://bartellab.wi.mit.edu/publication_reprints/Jan_Nature_2011.pdf)

-   [Improved re-implementation](http://elifesciences.org/content/4/e05005/)

The perl pipeline associated with the improved re-implementation can be found in this [GitHub repository](https://github.com/vagarwal87/TargetScanTools/tree/master?tab=readme-ov-file).

The predictions generated as part of the TargetScan project are available in the form of a searchable [web tool](https://www.targetscan.org/), however, using this tool to simultaneously identify miRNA(s) targeting multiple genes remains difficult. This is mainly due to the lack of batch search option. In this repository provides a set of R scripts that aid in this regard.

## Data source:

A full miRNA prediction data targeting human genes can be found in the [TargetScan website](https://www.targetscan.org/cgi-bin/targetscan/data_download.vert80.cgi). The scripts in this project download the [Predicted Targets context++ scores (default predictions)](https://www.targetscan.org/vert_80/vert_80_data_download/Predicted_Targets_Context_Scores.default_predictions.txt.zip) and perform downstream processing.

## Getting started:

-   A working installation of R and R-studio is required.
-   Download the project source code from GitHub in a [zip format](https://github.com/Sktbanerjee1/TargetScanR/archive/refs/heads/main.zip).
-   Unzip the folder and open this folder in R studio as a project by opening the `TargetScanR.Rproj` file.
-   Install the necessary R packages (dependencies for the scripts) by running the following commands in the console.

``` r
# CRAN packages
install.packages(c(
"log4r",
"ggplot2",
"RColorBrewer",
"ggpubr",
"jsonlite",
"data.table",
"BiocManager"
))

# Bioconductor packages
BiocManager::install("org.Hs.eg.db")
```

-   Edit the `GeneTargets.txt` file to include the target gene symbols.
-   Open the file `R/search_miRNA.R` and run the entire script.
-   Locate your result in the `results` folder. The naming pattern of the output file includes the date it was generated (e.g: `results/top_miRNA_09-02-2024.svg`).

## Final result

![](results/top_miRNA_09-02-2024.svg){width="728"}

## Known limitations:

-   The current version only supports miRNA search targeting human genes.

-   The script is only tested with maximum of 20 target genes at a time, while the core modules are capable of handing unlimited target genes, the modules responsible for generating the plots might break.
