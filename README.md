# Final-Project---Spring-2018

### Summary

This is a summary of my final project for TRGN510.

The goal of my project is to use various ChIP-seq data to profile enhancers in a specific cell line, BCBL-1.
BCBL-1 is a Primary Effusion Lymphoma cell line, infected with Kaposi's Sarcoma-associated Herpesvirus (KSHV). I want to identify how the enhancer profile changes upon reactivation of this herpesvirus from latent to lytic state.

H3K4me1 and H3K27ac are the predominant histone modifications deposited at nucleosomes flanking enhancer elements. I will be looking at H3K27ac ChIP-seq profiles during latent and lytic infection of KSHV in B-cells.

### Resources for my analyses
1. [Homer](http://homer.ucsd.edu/homer/index.html): Most of the analysis done using this package.
2. [Partek Flow](http://www.partek.com/partekflow): The input files (.bam) are generated using this purchased software that does pre-processing (trimming & aligning).  

### Papers useful for my project
1. [Epstein-Barr virus oncoprotein super-enhancers control B cell growth](https://www.ncbi.nlm.nih.gov/pubmed/25639793) 
2. [Epstein-Barr virus super-enhancer eRNAs are essential for MYC oncogene expression and lymphoblast proliferation](https://www.ncbi.nlm.nih.gov/pubmed/27864512)    
3. [A database of super-enhancers in mouse and human genome](http://asntech.org/dbsuper/)
4. [Modification of Enhancer Chromatin: What, How, and Why?](https://www.sciencedirect.com/science/article/pii/S1097276513001020)

### Pre-analysis (Partek Flow) 
1. Trim bases on both ends and Pre-alignment QA/QC. 
2. Align reads and Post-alignment QA/QC: used default settings and used Bowtie2 and aligned to hg19 (human genome)

Output from Partek Flow: `TBCBL-RTAdox-H3K27Ac_S1_L001_R1_001.bam`

Due to the sequencing platform that we used (NextSeq), each sample is divided into 4 different bam files. They will be combined into one in the next step.

### Creating a "Tag Directory" (HOMER)
Tag directory is  platform independent sequence alignment representing the experiment, analogous to loading the data into a database.  It is essentially a directory on your computer that contains several files describing your experiment. 
HOMER guesses input format, but I used `-force bam`

[HOMER: Creating a "Tag Directory" with makeTagDirectory](http://homer.ucsd.edu/homer/ngs/tagDir.html) 

1. Install HOMER

```bash
makeTagDirectory <Output Directory Name> [options] <alignment file1> [alignment file 2] ...
```
```bash
makeTagDirectory H3K27AC_NoDox TBCBL-RTAdox-H3K27Ac_S1_L001_R1_001.bam TBCBL-RTAdox-H3K27Ac_S1_L002_R1_001.bam TBCBL-RTAdox-H3K27Ac_S1_L003_R1_001.bam TBCBL-RTAdox-H3K27Ac_S1_L004_R1_001.bam
```

Output: folder `H3K27AC_NoDox` aka TagDirectory

### Fined "enriched peaks" (HOMER)
Use either `-style factor` or '-style histone' depending on what type of ChIP-seq it is.
This step will normalize to 10 million reads.

[HOMER: Finding Enriched Peaks, Regions, and Transcripts](http://homer.ucsd.edu/homer/ngs/peaks.html) 

```bash
findPeaks <tag directory> -style <factor or histone> -o Sample_Peaks.txt -i <input tag directory>
```
```bash
findPeaks H3K27AC_NoDox -style histone -size 1000 -o H3K27Ac_NoDox_Peaks.txt -i 20180409_HHKVVBGX5_input_NoDox
```

input was used as control

Output: `H3K27Ac_NoDox_Peaks.txt`

### Annotate peaks (HOMER)
Annotated peaks come in `.txt` file. Default settings are used, and use 'hg19' for genome.

[HOMER: Annotating Regions in the Genome (annotatePeaks.pl)](http://homer.ucsd.edu/homer/ngs/annotation.html)

```bash
annotatePeaks.pl Sample_Peaks.txt hg19 >Sample_Peaks_annotated.txt
```
```bash
annotatePeaks.pl H3K27Ac_NoDox_Peaks.txt hg19 -d H3K27AC_NoDox >H3K27Ac_NoDox_Peaks_annotated.txt
```

Output: `H3K27Ac_NoDox_Peaks_annotated.txt` (take a screenshot of the .txt file)

### Using excel, we pulled out the promoter/TSS to only look at ChIP bindings in non-promoters (possibly enhancers)

H3K27ac is enriched in both active promoters and enhancers. Identify active enhancers by taking out the `Promoter/TSS` from `H3K27Ac_NoDox_Peaks.txt` using the annotated file.

Output: `H3K27Ac_NoDox_Peaks_noTSS.txt` It is the H3K27Ac binding sites for non-TSS (potentially enhancers)

### Anchor plot (Histograms of Tag Directories)

annotatePeaks.pl ARpeaks.txt hg18 -size 4000 -hist 10 -d H3K4me2-control/ H3K4me2-dht-16h/ > outputfile.txt


```bash
annotatePeaks.pl H3K27Ac_NoDox_Peaks_noTSS.txt hg19 -size 20000 -hist 10 -d H3K27AC_NoDox >H3K27Ac_NoDox_Peaks_20kb_annotated.txt
```
20,000 = x-axis
### 

Output: `H3K27Ac_NoDox_Peaks_8kb_annotated.txt`
Do the same thing using H3K27Ac_PlusDox_Peaks (repeat from the beginning)





