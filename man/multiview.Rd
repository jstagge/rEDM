% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/multiview_interface.R
\name{multiview}
\alias{multiview}
\title{Perform forecasting using multiview embedding}
\usage{
multiview(block, lib = c(1, floor(NROW(block)/2)),
  pred = c(floor(NROW(block)/2), NROW(block)), norm_type = c("L2 norm",
  "L1 norm", "P norm"), P = 0.5, E = 3, tau = 1, tp = 1, max_lag = 3,
  num_neighbors = "e+1", k = "sqrt", na.rm = FALSE, target_column = 1,
  stats_only = TRUE, first_column_time = FALSE, exclusion_radius = NULL,
  silent = FALSE, short_output = FALSE)
}
\arguments{
\item{block}{either a vector to be used as the time series, or a 
data.frame or matrix where each column is a time series}

\item{lib}{a 2-column matrix (or 2-element vector) where each row specifes the 
first and last *rows* of the time series to use for attractor reconstruction}

\item{pred}{(same format as lib), but specifying the sections of the time 
series to forecast.}

\item{norm_type}{the distance function to use. see 'Details'}

\item{P}{the exponent for the P norm}

\item{E}{the embedding dimensions to use for time delay embedding}

\item{tau}{the lag to use for time delay embedding}

\item{tp}{the prediction horizon (how far ahead to forecast)}

\item{max_lag}{the maximum number of lags to use for variable combinations}

\item{num_neighbors}{the number of nearest neighbors to use for the in-sample 
prediction (any of "e+1", "E+1", "e + 1", "E + 1" will peg this parameter 
to E+1 for each run, any value < 1 will use all possible neighbors.)}

\item{k}{the number of embeddings to use (any of "sqrt", "SQRT" will use 
k = floor(sqrt(m)))}

\item{na.rm}{logical. Should missing values (including \code{NaN} be omitted 
from the calculations?)}

\item{target_column}{the index (or name) of the column to forecast}

\item{stats_only}{specify whether to output just the forecast statistics or 
the raw predictions for each run}

\item{first_column_time}{indicates whether the first column of the given 
block is a time column (and therefore excluded when indexing)}

\item{exclusion_radius}{excludes vectors from the search space of nearest 
neighbors if their *time index* is within exclusion_radius (NULL turns 
this option off)}

\item{silent}{prevents warning messages from being printed to the R console}

\item{short_output}{specifies whether to return a truncated output data.frame
whose rows only include the predictions made and not the whole input block}
}
\value{
If stats_only, then a data.frame with components for the parameters 
  and forecast statistics:
\tabular{ll}{
  E \tab embedding dimension\cr
  tau \tab time lag\cr
  tp \tab prediction horizon\cr
  nn \tab number of neighbors\cr
  k \tab number of embeddings used\cr
  num_pred \tab number of predictions\cr
  rho \tab correlation coefficient between observations and predictions\cr
  mae \tab mean absolute error\cr
  rmse \tab root mean square error\cr
  perc \tab percent correct sign\cr
  p_val \tab p-value that rho is significantly greater than 0 using Fisher's 
  z-transformation\cr
  const_rho \tab same as rho, but for the constant predictor\cr
  const_mae \tab same as mae, but for the constant predictor\cr
  const_rmse \tab same as rmse, but for the constant predictor\cr
  const_perc \tab same as perc, but for the constant predictor\cr
  const_p_val \tab same as p_val, but for the constant predictor
}
Otherwise, a list where the number of elements is equal to the number of runs 
  (unique parameter combinations). Each element is a list with the following 
  components:
\tabular{ll}{
  params \tab data.frame of parameters (E, tau, tp, nn, k)\cr
  lib_stats \tab data.frame of in-sample forecast statistics\cr
  model_output \tab data.frame with columns for the time index, observations, 
    and predictions\cr
  pred_stats \tab data.frame of forecast statistics\cr
}
}
\description{
\code{multiview} applies the method described in Ye & Sugihara (2016) for 
forecasting, wherein multiple attractor reconstructions are tested, and a 
single nearest neighbor is selected from each of the top "k" reconstructions 
to produce final forecasts.
}
\details{
uses multiple time series given as input to generate an 
attractor reconstruction, and then applies the simplex projection or s-map 
algorithm to make forecasts. This method generalizes the \code{simplex} and 
\code{s-map} routines, and allows for "mixed" embeddings, where multiple time 
series can be used as different dimensions of an attractor reconstruction.

The default parameters are set so that, given a matrix of time series, 
forecasts will be produced for the first column. By default, all possible 
combinations of the columns are used for the attractor construction, the 
k = sqrt(m) heuristic will be used, forecasts will be one time step ahead. 
Rownames will be converted to numeric if possible to be used as the time 
index, otherwise 1:NROW will be used instead. The default lib and pred are 
to use the first half of the data for the "library" and to predict over the 
second half of the data. Unless otherwise set, the output will be just the 
forecast statistics.

norm_type "L2 norm" (default) uses the typical Euclidean distance:
\deqn{distance(a,b) := \sqrt{\sum_i{(a_i - b_i)^2}}}{distance(a, b) := \sqrt(\sum(a_i - b_i)^2)}
norm_type "L1 norm" uses the Manhattan distance:
\deqn{distance(a,b) := \sum_i{|a_i - b_i|}}{distance(a, b) := \sum|a_i - b_i|}
norm type "P norm" uses the P norm, generalizing the L1 and L2 norm to use $p$ as the exponent:
\deqn{distance(a,b) := \sum_i{(a_i - b_i)^p}^{1/p}}{distance(a, b) := (\sum(a_i - b_i)^p)^(1/p)}
}
\examples{
data("block_3sp")
block <- block_3sp[, c(2, 5, 8)]
multiview(block, k = c(1, 3, "sqrt"))
}

