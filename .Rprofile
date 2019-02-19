#### -- Packrat Autoloader (version 0.4.9-3) -- ####
source("packrat/init.R")
#### -- End Packrat Autoloader -- ####

.get_os <- function(){
  sysinf <- Sys.info()
  if (!is.null(sysinf)){
    os <- sysinf['sysname']
    if (os == 'Darwin')
      os <- "osx"
  } else { ## mystery machine
    os <- .Platform$OS.type
    if (grepl("^darwin", R.version$os))
      os <- "osx"
    if (grepl("linux-gnu", R.version$os))
      os <- "linux"
  }
  tolower(os)
}

#####
# I assume that you use Windows
local({
  # assume that the file "~/wrds which contains
  #
  #   [user name],[password]
  
  f <- switch(
    .get_os(),
    windows = file.path(Sys.getenv("HOMEDRIVE"), Sys.getenv("HOMEPATH"), "wrds"),
    NULL)
  
  if(!is.null(f) && file.exists(f)){
    x <- strsplit(readLines(f), split = ",")[[1]]
    
    user <- x[1]
    pass <- x[2]
    
    .wrdsconnect <<- eval(bquote(
      function(user = .(user), pass = .(pass)){
        if(!require(RPostgres))
          stop("You need RPostgres to connect to WRDS. See the github page (https://github.com/r-dbi/RPostgres) for how to install the package.")
        
        wrds <- dbConnect(Postgres(),
                          host='wrds-pgdata.wharton.upenn.edu',
                          port=9737,
                          user=user,
                          password=pass, #NOTICE: not your SAS password!
                          sslmode='require',
                          dbname='wrds')
        return(wrds)
      }))
  } else 
    warning("Did not find file with ", sQuote("WRDS"), " connection info", 
            " in ", sQuote(".Rprofile"))
})
