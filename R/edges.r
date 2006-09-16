"edges<-" <- function(x, value) UseMethod("edges<-", x)

"edges<-.GGobi" <- function(x, value) {
  name <- deparse(substitute(value))
  if(is(value, "graphNEL")) {
    value <- t(edgeMatrix(value))
  }

  browser()
  x[[name]] <- data.frame(id=1:nrow(value))
  edges(x[[name]]) <- value

  x
}

"edges<-.GGobiDisplay" <- function(x, value) {
	if (is.null(value)) {
		.GGobiCall("setDisplayEdges", list(x), value, FALSE, FALSE)
	} else {
		.GGobiCall("setDisplayEdges", list(x), value, FALSE, TRUE)
	}
	x
}


# Set edges
# Set edges for a dataset.
#
# In GGobi, and edge dataset is a special type of dataset that has
# two additional (hidden) columns which specification source and
# destination row names.  These rownames are compared to the row 
# names of the dataset in the current plot, and if any match, it
# is possible to specify this dataset as an edge set to the plotted
# datset.  When this is done, edges will be drawn between points 
# specified by the edge dataset.
# 
# To remove edges, set edges to NULL.
# 
# @arguments GGobiData
# @arguments matrix, data frame, or graph containing of edges.  First column should be from edge, second column to edge. 
# @keyword manip
# @seealso \code{\link{ggobi_longitudinal}} for creating edges which simulate time series plots
#X cc<-cor(t(swiss),use="p", method="s") 
#X ccd<-sqrt(2*(1-cc)) 
#X a <- which(lower.tri(ccd), arr.ind=TRUE)
#X src <- row.names(swiss)[a[,2]]
#X dest <- row.names(swiss)[a[,1]] 
#X weight <- as.vector(as.dist(ccd))
#X gg <- ggobi(swiss)
#X gg$cor <- data.frame(weight)
#X edges(gg$cor) <- cbind(src, dest)
#X edges(gg$cor)
#X edges(gg$cor) <- NULL
"edges<-.GGobiData" <- function(x, value) {
  if (is.null(value)) return(invisible(.GGobiCall("setEdges", character(0), character(0), FALSE, x)))
  
  if(is(value, "graphNEL")) {
    value <- t(edgeMatrix(value))
  }

  src  <- value[,1]
  dest <- value[,2]    
  

	if (is.numeric(src)) src <- rownames(x)[src]
	if (is.numeric(dest)) dest <- rownames(x)[dest]

	.GGobiCall("setEdges", src, dest, FALSE, x)
	x
}

# Get edges
# Get edges for a dataset
#
# @arguments ggobi dataset
# @value A matrix of edge pairs
# @keyword manip
edges <- function(x) {
	m <- .GGobiCall("getSymbolicEdges", x)
	if (ncol(m) == 2) colnames(m) <- c("source", "destination")
	m
}

# Get connecting edges 
# Get actual edges from application of edges dataset to target dataset.
# 
# @arguments target ggobi dataset
# @arguments ggobi dataset containing edges
# @keyword manip 
connecting_edges <- function(x, y) {
	m <- .GGobiCall("getConnectedEdges", y, x) + 1
	if (ncol(m) == 2) colnames(m) <- c("source", "destination")
	m
}