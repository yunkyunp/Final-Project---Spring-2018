# Final-Project---Spring-2018

# Summary

This is a summary of my final project for TRGN510.

![screen shot 2018-04-30 at 4 16 16 pm](https://user-images.githubusercontent.com/35276847/39454735-de83d83e-4c91-11e8-99ae-9cf422080b1a.png)

The goal of my project is to use various ChIP-seq data to profile enhancers in a specific B-cell line, infected with a herpesvirus. I want to identify how the enhancer profile changes upon reactivation of a herpesvirus from latent to lytic state in this cell line.

H3K4me1 and H3K27ac are the predominant histone modifications deposited at nucleosomes flanking enhancer elements. I will be looking at H3K27ac ChIP-seq profiles during latent and lytic viral infection in B-cells.

### Resources for my analyses
1. [Homer](http://homer.ucsd.edu/homer/index.html): Most of the analysis done using this package. Pre-downloaded.
2. [Partek Flow](http://www.partek.com/partekflow): The input files (.bam) are generated using this purchased software that does pre-processing (trimming & aligning).  

### Papers useful for my project
1. [Epstein-Barr virus oncoprotein super-enhancers control B cell growth](https://www.ncbi.nlm.nih.gov/pubmed/25639793)   
2. [A database of super-enhancers in mouse and human genome](http://asntech.org/dbsuper/)
3. [Modification of Enhancer Chromatin: What, How, and Why?](https://www.sciencedirect.com/science/article/pii/S1097276513001020)

# Pre-analysis (Partek Flow) 
1. Trim bases on both ends and Pre-alignment QA/QC. 
2. Align reads and Post-alignment QA/QC: used default settings and used Bowtie2 and aligned to hg19 (human genome)

Outputs from Partek Flow: 
1. `LyticVSLatent_TMMNorm_1.txt` - Binding differentials between lytic and latent. 
![screen shot 2018-04-30 at 4 24 07 pm](https://user-images.githubusercontent.com/35276847/39454951-f1733592-4c92-11e8-8d72-a7d1044097b7.png)

2. `TBCBL-RTAdox-H3K27Ac_S1_L001_R1_001.bam, TBCBL-RTAdox-H3K27Ac_S1_L001_R1_002.bam, TBCBL-RTAdox-H3K27Ac_S1_L001_R1_003.bam, TBCBL-RTAdox-H3K27Ac_S1_L001_R1_004.bam` - Due to the sequencing platform that we used (NextSeq), each sample is divided into 4 different bam files. They will be combined into one in the downstream analysis in HOMER.

# Analysis (Volcano plot - R Shiny)
Input: `LyticVSLatent_TMMNorm_1.txt`
Differential binding profile between latent vs lytic virus infection. The R shiny script `app.R` is uploaded onto github.

Output: [Click here to view URL](http://52.14.202.125:3838/yunkyunp/finalproject/Final-Project---Spring-2018/)

This interactive volcano plot compares H3K27Ac ChIP-seq data in lytic infection vs latent infection in B-cell lymphoma, showing binding sites on the entire genome (inter-genic, TSS, etc). 
Following analysis (HOMER) is to look at the H3K27Ac marks on enhancers only (non-TSS sites). 


# Analysis (HOMER)

### Creating a "Tag Directory" 
Tag directory is  platform independent sequence alignment representing the experiment, analogous to loading the data into a database.  It is essentially a directory on your computer that contains several files describing your experiment. 
HOMER guesses input format, but I used `-force bam`

[HOMER: Creating a "Tag Directory" with makeTagDirectory](http://homer.ucsd.edu/homer/ngs/tagDir.html) 
Input: `TBCBL-RTAdox-H3K27Ac_S1_L001_R1_001.bam`

```bash
makeTagDirectory H3K27AC_NoDox TBCBL-RTAdox-H3K27Ac_S1_L001_R1_001.bam TBCBL-RTAdox-H3K27Ac_S1_L002_R1_001.bam TBCBL-RTAdox-H3K27Ac_S1_L003_R1_001.bam TBCBL-RTAdox-H3K27Ac_S1_L004_R1_001.bam
```

Output: folder `H3K27AC_NoDox` aka TagDirectory

### Find "enriched peaks"
Use either `-style factor` or '-style histone' depending on what type of ChIP-seq it is.
This step will normalize to 10 million reads.

[HOMER: Finding Enriched Peaks, Regions, and Transcripts](http://homer.ucsd.edu/homer/ngs/peaks.html) 

e.g.
```bash
findPeaks H3K27AC_NoDox -style histone -size 1000 -o H3K27Ac_NoDox_Peaks.txt -i 20180409_HHKVVBGX5_input_NoDox
```

`20180409_HHKVVBGX5_input_NoDox` was used as ChIP input control

Output: `H3K27Ac_NoDox_Peaks.txt`

### Annotate peaks 
Annotated peaks come in `.txt` file. Default settings are used, and use 'hg19' for genome.

[HOMER: Annotating Regions in the Genome (annotatePeaks.pl)](http://homer.ucsd.edu/homer/ngs/annotation.html)

```bash
annotatePeaks.pl H3K27Ac_NoDox_Peaks.txt hg19 -d H3K27AC_NoDox >H3K27Ac_NoDox_Peaks_annotated.txt
```

Output: `H3K27Ac_NoDox_Peaks_annotated.txt` 

### Using excel, we pulled out the promoter/TSS to only look at ChIP bindings in non-promoters (possibly enhancers)
H3K27ac is enriched in both active promoters and enhancers. Identify active enhancers by taking out the `Promoter/TSS` from `H3K27Ac_NoDox_Peaks.txt` using the annotated file.

![annotated](https://user-images.githubusercontent.com/35276847/39323241-e2dac3f6-4940-11e8-9e58-f0e5403950d2.png)


Output: `H3K27Ac_NoDox_Peaks_noTSS.txt` It is the H3K27Ac binding sites for non-TSS (potentially enhancers)

### Anchor plot (Histograms of Tag Directories)

```bash
annotatePeaks.pl H3K27Ac_NoDox_Peaks_noTSS.txt hg19 -size 20000 -hist 10 -d H3K27AC_NoDox >H3K27Ac_NoDox_Peaks_20kb_annotated.txt
```
20,000 = x-axis

Output: `H3K27Ac_NoDox_Peaks_20kb_annotated.txt`

### Do the same thing using H3K27Ac_PlusDox_Peaks (repeat from the beginning)
H3K27Ac_NoDox is ChIP-seq for H3K27Ac in lymphoma cell line infected with latent herpesvirus. We also did ChIP-seq for H3K27Ac_PlusDox, which is the same cell line infected with reactivated lytic herpesvirus. 

# Visualization (R)
### Anchor plot 
```R
#Read in anchorplot text files from Homer (annotatePeaks)
H3K27AC_ND_noTSS_20kb <- read.delim("~/Documents/Data/BCBL_ChipSeq/Homer_Analysis/H3K27Ac_NoDox_noTSS_20kb_anchorplot.txt")
H3K27AC_PD_noTSS_20kb <- read.delim("~/Documents/Data/BCBL_ChipSeq/Homer_Analysis/H3K27Ac_PlusDox_noTSS_20kb_anchorplot.txt")

#Plot Anchor Plots
png("H3K27ac_20kb_noTSS.png")
plot(H3K27AC_ND_noTSS_20kb[,1], H3K27AC_ND_noTSS_20kb[,2], type="l", col="blue", xlab="Distance from Overlap", ylab="H3K27Ac Read Coverage", main="H3K27Ac Coverage in BCBL-1 (no TSS H3K27Ac Peaks)")
lines(H3K27AC_PD_noTSS_20kb[,1],H3K27AC_PD_noTSS_20kb[,2], type="l", col="red")
dev.off()
```
Output: `H3K27ac_20kb_noTSS.png`

![h3k27ac_20kb_notss](https://user-images.githubusercontent.com/35276847/39328606-b12d184e-4950-11e8-9667-a00a9565793a.png)

This anchor plot shows the global level of H3K27Ac marks on enhancers only. The conclusion is that upon reactivation of herpesvirus(latent --> lytic) in B-cell lymphoma cell line, global enhancer activity (noted by H3K27Ac) decreases.
