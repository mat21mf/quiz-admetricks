drv <- dbDriver( "PostgreSQL" )
con <- dbConnect( drv ,
                  dbname = "dbadmetricks" ,
                  host = "localhost" ,
                  port = 5432 ,
                  user = "postgres" )
