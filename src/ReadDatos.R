
  dfbanco <- openxlsx::read.xlsx( "./admetricks_brand_report_c8d951a04ab83d33b783e1d286c04744_copia.xlsx"  , colNames = TRUE , startRow = 1 , sheet = 1 )
  dim( dfbanco )
  dfmarkt <- openxlsx::read.xlsx( './admetricks_market_report_4051416cb1b49ac75a4894858a3f57aa_copia.xlsx' , colNames = TRUE , startRow = 1 , sheet = 1 )
  dim( dfmarkt )
