# Background 

* Date Prepared: August 27, 2020
* Contact: Natalie Stanley, NatalieStanley1318@gmail.com
* Purpose: benchmark the quality of dimensionality reduction methods on multiomics datasets

## Dependencies 

The code was was tested in R version 3.6.1 and requires the following packages:
`foreach`, `doParallel`, `igraph`, `FastKNN`, `largeVis`, `MASS`

# Benchmarking Tasks

Here we will show examples for how to run both types of benchmarking tasks introduced in our paper across the three multiomics datasets and six dimensionality reduction methods.

* Task 1) We will quantify the overlap between the low-dimensional projection and original high dimensional space
* Task 2) We will report the visual quality score for each dimensionality reduction method

## Task 1: Alignment between high-dimensional space and low-dimensional projection

Here we show task 1 for each of the three datasets

### TCGA-Sarc 
