projectKNNs <- function(wij, # symmetric sparse matrix
                        dim = 2, # dimension of the projection space
                        sgd_batches = NULL,
                        M = 5,
                        gamma = 7,
                        alpha = 1,
                        rho = 1,
                        coords = NULL,
												useDegree = FALSE,
												momentum = NULL,
												seed = NULL,
												threads = NULL,
                        verbose = getOption("verbose", TRUE)) {

  if (alpha < 0) stop("alpha < 0 is meaningless")
  N <-  (length(wij@p) - 1)
  js <- rep(0:(N - 1), diff(wij@p))
  if (any(is.na(js))) stop("NAs in the index vector.")
  is <- wij@i

  ##############################################
  # Initialize coordinate matrix
  ##############################################
  if (is.null(coords)) coords <- matrix((runif(N * dim) - 0.5) / dim * 0.0001, nrow = dim)

  if (is.null(sgd_batches)) {
  	sgd_batches <- sgdBatches(N, length(wij@x / 2))
  } else if (sgd_batches < 0) stop("sgd batches must be > 0")
  else if (sgd_batches < 1) {
  	sgd_batches = sgd_batches * sgdBatches(N, length(wij@x / 2))
  }

  if (!is.null(threads)) threads <- as.integer(threads)
  if (!is.null(momentum)) momentum <- as.double(momentum)

  #################################################
  # SGD
  #################################################
  if (verbose) cat("Estimating embeddings.\n")
  coords <- sgd(coords,
                targets_i = is,
                sources_j = js,
                ps = wij@p,
                weights = wij@x,
                alpha = as.double(alpha),
  							gamma = as.double(gamma),
  							M = as.integer(M),
                rho = as.double(rho),
                n_samples = sgd_batches,
  							momentum = momentum,
  							useDegree = as.logical(useDegree),
  							seed = seed,
  							threads = threads,
                verbose = as.logical(verbose))

  return(coords)
}

#' sgdBatches
#'
#' Calculate the default number of batches for a given number of vertices and edges.
#'
#' The formula used is the one used by the \code{LargeVis} reference implementation.  This is substantially less than the recommendation \eqn{E * 10000} in the original paper.
#'
#' @param N Number of vertices.
#' @param E Number of edges.
#'
#' @return The recommended number of sgd batches.
#' @export
#'
#' @examples
#' # Observe that increasing K has no effect on processing time
#' N <- 70000 # MNIST
#' K <- 10:250
#' plot(K, sgdBatches(rep(N, length(K)), N * K / 2))
#'
#' # Observe that processing time scales linarly with N
#' N <- c(seq(from = 1, to = 10000, by = 100), seq(from = 10000, to = 10000000, by = 1000))
#' plot(N, sgdBatches(N))
sgdBatches <- function(N, E = 150 * N / 2) {
	ifelse(N < 10000, 2000 * E, ifelse(N < 1000000, 1000000 * (9000 * (N - 10000) / (1000000 - 10000) + 1000), N * 10000))
}
