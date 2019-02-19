make_ym <- function(x, base_year = 1960L){
  library(lubridate)
  out <- (as.integer(lubridate::year(x) + 1e-8) - base_year) * 12L + 
    as.integer(lubridate::month(x) + 1e-8) - 1L
  attr(out, "base_year") <-  base_year
  out
}

make_ym_inv <- function(x, base_year = 1960L){
  stopifnot(is.integer(x))
  y <- x %/% 12L + base_year
  m <- x %% 12L + 1L
  as.Date(paste0(y, "-", sprintf("%02d", m), "-01"))
}

local({
  tmp <- as.Date(0:(365*4), origin = "1970-01-01")
  x <- make_ym(tmp)
  y <- make_ym_inv(x)
  
  library(lubridate)
  stopifnot(all(lubridate::month(tmp) == lubridate::month(y)))
  stopifnot(all(lubridate::year(tmp)  == lubridate::year(y)))
  
  invisible()
})
