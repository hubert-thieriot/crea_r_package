require("RPostgres")
require("purrr")

library(DBI)
library(purrr)

pkg.globals <- new.env()
pkg.globals$CON <- NULL


connection <- function() {
  # Connect to a specific postgres database i.e. Heroku
  if(is.null(pkg.globals$CON)){

    pkg.globals$CON <- DBI::dbConnect(RPostgres::Postgres(),dbname = 'development',
                      host = '35.205.243.56',
                      port = 5432, # or any other port specified by your DBA
                      user = 'postgres',
                      password = 'qDJew3z7Ij0kLlE3')
  }

  return(pkg.globals$CON)
}

filters_to_pg_str <- function(filters){

  if(length(filters)==0) return('')

  clauses = c()

  flt_parse_one <- function(flt){
    if(typeof(flt)=="character"){
      return(paste("\'", flt, "\'", sep=""))
    }else{
      return(flt)
    }
  }

  flt_parse <- function(flt){
    if(typeof(flt)=="list"){
      return(purrr::map(flt, flt_parse_one))
    }else{
      return(flt_parse_one(flt))
    }
  }

  for (flt_name in names(filters)){
    flt_name
    flt = flt_parse(filters[[flt_name]])
    if(typeof(flt)=="list"){
      clauses <- c(clauses, paste(flt_name, "= ANY(",flt,")", sep=" "))
    }else{
      clauses <- c(clauses, paste(flt_name, "= ",flt, sep=" "))
    }
  }
  result <- paste(clauses, collapse=" AND ")
  filters_str <- paste("WHERE ", result)
  return(filters_str)
}


