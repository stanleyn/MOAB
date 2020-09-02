# Background 

* Date Prepared: August 27, 2020
* Contact: Natalie Stanley, NatalieStanley1318@gmail.com
* Purpose: benchmark the quality of dimensionality reduction methods on multiomics datasets

## Dependencies 

The code was was tested in R version 3.6.1 and requires the following packages:
`foreach`, `doParallel`, `igraph`, `FastKNN`, `largeVis`, `MASS`

## Getting Started

Clone this repository into some location, '*myLocation*'

```bash
git clone https://github.com/stanleyn/MOAB
```

Move into the directory that you cloned the repository into,

```bash
cd *myLocation*
```

# Benchmarking Tasks

Here we will show examples for how to run both types of benchmarking tasks introduced in our paper across the three multiomics datasets and six dimensionality reduction methods.

* Task 1) We will quantify the overlap between the low-dimensional projection and original high dimensional space
* Task 2) We will report the visual quality score for each dimensionality reduction method

## Task 1: Alignment between high-dimensional space and low-dimensional projection

Here we show task 1 for each of the three datasets

### TCGA-Sarc
To run the benchmarking task for the TCGA-sarc dataset,

```R
source('TCGA_sarc/LP_Test_sarcoma.R')
```

You can find the matrix of `Method x Neighborhood Size` in `FullDF` 
