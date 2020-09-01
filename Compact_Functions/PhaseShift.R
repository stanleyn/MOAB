PhaseShift=function(Raw,PointLab,BuildGraph){

library('igraph')
library('largeVis')
library('Rtsne')
library('umap')

#inputs:
	#Raw needs to be in the format of features x samples

#########################################
source('~/Clean_Multiomics/General/SampleEmbedding_GiveLab.R')

findComm=cluster_louvain(BuildGraph,weights=E(BuildGraph)$weight)
findComm=membership(findComm)
print(max(findComm))
#find the sizes of the communities
CommSize=table(findComm)
SizeRank=order(CommSize)

Val=c()
UMAPVal=c()
TVal=c()
ModVal=c()
for(i in 1:length(SizeRank)){
CommUse=SizeRank[1:i]

#select relevant rows
RelRows=which(is.element(findComm,CommUse))

#select the subset of data
SubData=Raw[RelRows,]

#find the number of PCs for 90% of variance
PCRes=prcomp(SubData)
getCumu=summary(PCRes)[[6]][3,]

#find first value greater than 0.9
FirstVal=min(which(getCumu>=0.9))
print(FirstVal)
Val=c(Val,FirstVal)


NumGen=1000
RndStuff=Gen_Unif(SubData,NumGen)
ModPointLab=c(PointLab[RelRows],rep(max(PointLab[RelRows])+1,1000))

#find the elbow for dataset modularity
res=svd(RndStuff)$d
print('length of res')
print(length(res))

#stop('')
ModVal=c(ModVal,elbowPoint(1:length(res),res)$y)
print('this is mod val')
print(ModVal)
#umap first

loT=Rtsne(RndStuff,check_duplicates=FALSE)
loT=loT$Y

loU=umap(RndStuff)
loU=loU$layout

ResT=SampleEmbedding_GiveLab(loT,RndStuff,ModPointLab,15)
ResU=SampleEmbedding_GiveLab(loU,RndStuff,ModPointLab,15)

UMAPVal=c(UMAPVal,median(ResU))
TVal=c(TVal,median(ResT))

print('umap vec')
print(UMAPVal)

print('Tsne vec')
print(TVal)
}
OutMat=rbind(ModVal,UMAPVal,TVal)
} #function

elbowPoint <- function(x, y) {

  # check for non-numeric or infinite values in the inputs
  is.invalid <- function(x) {
    any((!is.numeric(x)) | is.infinite(x))
  }
  if (is.invalid(x) || is.invalid(y)) {
    stop("x and y must be finite and numeric. Missing values are not allowed.")
  }
  if (length(x) != length(y)) {
    stop("x and y must be of equal length.")
  }

  # generate value of curve at equally-spaced points
  new.x <- seq(from=min(x), to=max(x), length.out=length(x))
  # Smooths out noise using a spline
  sp <- smooth.spline(x, y)
  new.y <- predict(sp, new.x)$y

  # Finds largest odd number below given number
  largest.odd.num.lte <- function(x) {
    x.int <- floor(x)
    if (x.int %% 2 == 0) {
      x.int - 1
    } else {
      x.int
    }
  }

  # Use Savitzky-Golay filter to get derivatives
  smoothen <- function(y, p=p, filt.length=NULL, ...) {
    # Time scaling factor so that the derivatives are on same scale as original data
    ts <- (max(new.x) - min(new.x)) / length(new.x)
    p <- 3 # Degree of polynomial to estimate curve
    # Set filter length to be fraction of length of data
    # (must be an odd number)
    if (is.null(filt.length)) {
      filt.length <- min(largest.odd.num.lte(length(new.x)), 7)
    }
    if (filt.length <= p) {
      stop("Need more points to find cutoff.")
    }
    signal::sgolayfilt(y, p=p, n=filt.length, ts=ts, ...)
  }

  # Calculate first and second derivatives
  first.deriv <- smoothen(new.y, m=1)
  second.deriv <- smoothen(new.y, m=2)

  # Check the signs of the 2 derivatives to see whether to flip the curve
  # (Pick sign of the most extreme observation)
  pick.sign <- function(x) {
    most.extreme <- which(abs(x) == max(abs(x), na.rm=TRUE))[1]
    sign(x[most.extreme])
  }
  first.deriv.sign <- pick.sign(first.deriv)
  second.deriv.sign <- pick.sign(second.deriv)

  # The signs for which to flip the x and y axes
  x.sign <- 1
  y.sign <- 1
  if ((first.deriv.sign == -1) && (second.deriv.sign == -1)) {
    x.sign <- -1
  } else if ((first.deriv.sign == -1) && (second.deriv.sign == 1)) {
    y.sign <- -1
  } else if ((first.deriv.sign == 1) && (second.deriv.sign == 1)) {
    x.sign <- -1
    y.sign <- -1
  }
  # If curve needs flipping, then run same routine on flipped curve then
  # flip the results back
  if ((x.sign == -1) || (y.sign == -1)) {
    results <- elbowPoint(x.sign * x, y.sign * y)
    return(list(x = x.sign * results$x, y = y.sign * results$y))
  }

  # Find cutoff point for x
  cutoff.x <- NA
    # Find x where curvature is maximum
    curvature <- abs(second.deriv) / (1 + first.deriv^2)^(3/2)

    if (max(curvature) < min(curvature) | max(curvature) < max(curvature)) {
      cutoff.x = NA
    } else {
      # Interpolation function
      f <- approxfun(new.x, curvature, rule=1)
      # Minimize |f(new.x) - max(curvature)| over range of new.x
      cutoff.x = optimize(function(new.x) abs(f(new.x) - max(curvature)), range(new.x))$minimum
    }

   if (is.na(cutoff.x)) {
    warning("Cutoff point is beyond range. Returning NA.")
    list(x=NA, y=NA)
    } else {
    # Return cutoff point on curve
    approx(new.x, new.y, cutoff.x)
  }
}
