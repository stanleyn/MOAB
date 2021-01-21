# Background 

* Date Prepared: August 27, 2020
* Contact: Natalie Stanley, natalies@cs.unc.edu
* Purpose: benchmark the quality of dimensionality reduction methods on multiomics datasets

## Dependencies 

The code was was tested in R version 3.6.1 and requires the following packages:
`foreach`, `doParallel`, `igraph`, `FastKNN`, `largeVis`, `MASS`, `rPython`. You will also need to have python installed.

## Getting Started

Clone this repository into some location, `myPath`

```bash
git clone https://github.com/stanleyn/MOAB
```

Move into the directory that you cloned the repository into,

```bash
cd myPath
```

# Benchmarking Tasks

Here we will show examples for how to run both types of benchmarking tasks introduced in our paper across the three multiomics datasets and six dimensionality reduction methods. For each dataset/DR algorithm combination, we run 30 trials of the label propagation task. 

* Task 1) We will quantify the overlap between the low-dimensional projection and original high dimensional space
* Task 2) We will report the visual quality score for each dimensionality reduction method

## Task 1: Alignment between high-dimensional space and low-dimensional projection with label propagation task

Here we show task 1 for each of the three datasets

### TCGA-Sarc
To run the benchmarking task for the TCGA-sarc dataset,

```R
> source('TCGA_sarc/LP_Test_sarcoma.R')
```

You can find the matrix of `Method x Neighborhood Size` in `FullDF`

### TCGA-Adreno 
To run the benchmarking task for the TCGA-adreno dataset,

```R
> source('TCGA_adeno/LP_Test_adeno.R')
```

You can find the matrix of `Method x Neighborhood Size` in `FullDF`

### Term Pregnancy
To run the benchmarking task for the Term-Pregnancy dataset,

```R
> source('Term_Pregnancy/LP_Test_TermPreg.R')
```

You can find the matrix of `Method x Neighborhood Size` in `FullDF`

## Task 2: Computing a Local Neighborhood Quality Score

Here we will demonstrate how to compute visual quality scores for each of the 3 datasets across the six dimensionality reduction methods. 

Note that this method requires creating a kNN graph of each layout. These have been pre-computed for each returned dimensionality reduction result using the `largeVis` package in R/python https://github.com/lferry007/LargeVis

### TCGA-Sarc

To run the visual quality scoring benchmarking task on the TCGA-sarc dataset,

```R
> source('TCGA_sarc/VizQuality_sarcoma.R')
```

A vector of quality scores for each algorithm is created in `Quality_Scores`

### TCGA-Adreno

To run the visual quality scoring benchmarking task on the TCGA-Adreno dataset,

```R
> source('TCGA_adeno/VizQuality_adeno.R')
```

A vector of quality scores for each algorithm is created in `Quality_Scores`

### Term Pregnancy

To run the visual quality scoring benchmarking task on the Term Pregnancy dataset,

```R
> source('Term_Pregnancy/VizQuality_TermPregnancy.R')
```

A vector of quality scores for each algorithm is created in `Quality_Scores`

