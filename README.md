# Final-Project---Spring-2018

### Summary

This is a summary of my final project for TRGN510.
The goal of my project is to use various ChIP-seq data to profile enhancers in a specific cell line, BCBL-1.
BCBL-1 is a Primary Effusion Lymphoma cell line, infected with Kaposi's Sarcoma-associated Herpesvirus (KSHV). I want to identify how the enhancer profile changes upon reactivation of this herpesvirus from latent to lytic state.

### Resources for my analyses
1. [Homer](http://homer.ucsd.edu/homer/index.html): Most of the analysis done using this package.
2. [Partek Flow](http://www.partek.com/partekflow): The input files (.bam) are generated using this purchased software that does pre-processing (trimming & aligning).  

### Papers useful for my project
1. [Epstein-Barr virus oncoprotein super-enhancers control B cell growth](https://www.ncbi.nlm.nih.gov/pubmed/25639793) 
2. [PEpstein-Barr virus super-enhancer eRNAs are essential for MYC oncogene expression and lymphoblast proliferation](https://www.ncbi.nlm.nih.gov/pubmed/27864512)    
3. [a database of super-enhancers in mouse and human genome](http://asntech.org/dbsuper/)

### Pre-analysis (Partek Flow) 
1. Trim bases on both ends and Pre-alignment QA/QC. 
2. Align reads and Post-alignment QA/QC: used default settings and used Bowtie2 and aligned to hg19 (human genome)

### Creating a "Tag Directory" (Homer)
Tag directory is  platform independent sequence alignment representing the experiment, analogous to loading the data into a database.  It is essentially a directory on your computer that contains several files describing your experiment. 
HOMER guesses input format, but I used "-force bam"

[Next-gen Sequencing Analysis: Creating a "Tag Directory" with makeTagDirectory](http://homer.ucsd.edu/homer/ngs/tagDir.html) 

```bash
 
```

### Fined "enriched peaks" (Homer)

[Finding Enriched Peaks, Regions, and Transcripts](http://homer.ucsd.edu/homer/ngs/peaks.html) 

