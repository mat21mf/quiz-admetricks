#' ---
#' title:  |
#'         | Postulación al cargo de Data Scientist.
#'         | Prueba técnica.
#' author: |
#'         | Matías Rebolledo
#' date: Viernes, 4 de Agosto de 2017
#' header-includes:
#'    - \usepackage{multirow}
#'    - \usepackage{hhline}
#' output:
#'    pdf_document:
#'      toc: true
#'      toc_depth: 3
#'      number_sections: true
#'      highlight: default
#'      includes:
#'        in_header: ./src/header.tex
#'      fig_caption: yes
#' urlcolor: blue
#' linkcolor: blue
#' geometry: margin=.75in
#' ---

#'

#' \newlength{\classpageheight}
#' \setlength{\classpageheight}{\paperheight}
#' \newlength{\classpagewidth}
#' \setlength{\classpagewidth}{\paperwidth}

#' \newpage

#'

#'# Enunciado.

#'

#' El objetivo es que propongas mejoras a nuestra metodología y proceso de
#' estimación de la valorización de campañas para que se asemeje más a la
#' realidad. Que identifiques puntos y variables relevantes a ajustar y/o
#' predecir, que expliques que es lo que ves en los datos y específicamente
#' qué caminos seguirías para realizar las mejoras (no necesariamente
#' avanzar en estos caminos, pero puedes hacerlo en alguno que te interese
#' o encuentras soluciones).

#'

#' Además adjunto muestras de datos para que
#' juegues. El archivo del banco estado, sabemos que a la fecha han
#' invertido $120.000.000 millones en internet, pero nosotros calculamos
#' $80.000.000. El segundo archivo corresponde a dos meses de todo el
#' mercado de Chile. En Internet (iab, achap) puedes encontrar fuentes de
#' inversión total y distribución para hacer supuestos para hacer las
#' correcciones de Inversión total, inversión en escritorio vs móviles,
#' display vs video, etc. Para las impresiones estamos usando similarweb.

#'

#' El formato de entrega es un documento con gráficos y códigos asociados
#' en el lenguaje que más te acomode.

#'

#' La fecha de entrega es una semana
#' vía mail, si te va bien agendamos para que vengas a presentarlo, lo que
#' sería la entrevista / evaluación / final del proceso.

#'

#'# Preparar datos.

#'

#' - Dependencias.

#'

#+ chunkmsg0001, messages=FALSE, echo=TRUE
suppressMessages( suppressWarnings( source( "./src/Dependencias.R" ) ) )
options( knitr.kable.NA = '' )
greenseq <- brewer.pal(6, "BuGn")

#'

#' - Cargar datos en sesión.

#'

#+ chunkmsg0002, messages=FALSE, echo=TRUE, include=FALSE, cache=TRUE
load( "./.RData" )

#'

#' - Renombrar y formatear variables.

#'

#+ chunkmsg0003, messages=FALSE, echo=FALSE
source( "./src/Renombrar.R" )
dfbanco$dates <- as.Date( dfbanco$dates )
dfmarkt$dates <- as.Date( dfmarkt$dates )
dfbanco$month_yr <- format( dfbanco$dates , "%Y-%m" )
dfmarkt$month_yr <- format( dfmarkt$dates , "%Y-%m" )

#'

#' - Exportar a csv para inserción. Delimitador multi caracter.

#+ chunkmsg0004, messages=FALSE, echo=TRUE
# write.table( file = "./csv/banco.csv" , dfbanco , sep = "-_-" , quote = F , row.names = F )
# write.table( file = "./csv/markt.csv" , dfmarkt , sep = "-_-" , quote = F , row.names = F )

#'

#' - Limpieza de datos. Vim + Bash.

#'

#+ chunkmsg0005, messages=FALSE, echo=TRUE
# if ( Sys.info()["sysname"] == "Linux"   ) system( "bash ./src/LimpiarCsv.sh" )
# if ( Sys.info()["sysname"] == "Windows" )  shell( "bash ./src/LimpiarCsv.sh" )

#'

#' - Separar tabla grande en meses.

#'

#+ chunkmsg0006, messages=FALSE, echo=TRUE
# if ( Sys.info()["sysname"] == "Linux"   ) system( "bash ./src/SepararMeses.sh" )
# if ( Sys.info()["sysname"] == "Windows" )  shell( "bash ./src/SepararMeses.sh" )

#'

#' - Crear tipo de datos.

#'

#+ chunkmsg0007, messages=FALSE, echo=TRUE
if ( Sys.info()["sysname"] == "Linux"   ) system( "bash ./src/LlamarImportarDatos.sh" )
if ( Sys.info()["sysname"] == "Windows" )  shell( "bash ./src/LlamarImportarDatos.sh" )

#'

#' - Abrir conexión a PostgreSQL.

#'

#+ chunkmsg0008, messages=FALSE, echo=TRUE
source( "./src/Connect.R" )

#'

#' - Crear inserciones de tablas SQL chicas.

#'

#' ```{r chunkmsg0009, messages=TRUE, echo=TRUE, engine='bash', comment='output:'}
#' cat ./src/CrearTabla.sh
#' cat ./src/InsertarTabla.sh
#' ```

#'

#' \newpage

#'

#' \adjustpagedim{420mm}{614mm}

#'

#' - Ejecutar inserciones de tablas SQL chicas. Tablas de la industria usan mucha memoria, incluso separando por meses.

#'

#' ```{r chunkmsg0010, messages=TRUE, echo=TRUE, engine='bash', comment='output:'}
#' cat ./src/LlamarImportarDatos.sh
#' ```

#'

#' - Crear inserciones de tablas SQL grandes separadas por día para bajar el uso de memoria.

#'

#' ```{r chunkmsg0011, messages=TRUE, echo=TRUE, engine='bash', comment='output:'}
#' cat ./src/SepararDias.sh
#' ```

#'

#' - Ejecutar inserciones de tablas SQL grandes.
#'     - Las anteriores son rutinas cuyo objetivo es la mejora continua, detección de inconsistencias y
#'       creación de flujos de procesamiento de datos.
#'     - Se busca incorporarlas dentro de un \textit{workflow system} como Tensorflow o similar
#'       para tener un frontend con nodos gráficos además de las herramientas de generación de código.

#'

#' ```{r chunkmsg0012, messages=TRUE, echo=TRUE, engine='bash', comment='output:'}
#' cat ./src/LlamarSepararDias.sh
#' ```

#'

#' - Verificar por consulta la inversión total.

#'

#+ chunkmsg0013, messages=FALSE, echo=TRUE
sumbanco <- dbGetQuery( con , "select brand , sum(valuation) as suma from tb_banco
                               group by brand
                               order by suma desc" )
summarkt <- dbGetQuery( con , "select brand , sum(valuation) as suma from tb_markt
                               group by brand
                               order by suma desc" )
summarkt <- within( summarkt   , quartile <- as.integer( cut( suma       ,
            quantile( suma     , probs = 0:100/100 ) , include.lowest = TRUE ) ) )
kable( sumbanco ,
format.args = list( decimal.mark = ',' , big.mark = '.' ) , digits = 0 ,
      col.names = c( "Empresa" , "Inversión" ) ,
      caption = "Inversión total de Banco Estado." )
kable( head( summarkt , 20 ) ,
format.args = list( decimal.mark = ',' , big.mark = '.' ) , digits = 0 ,
      col.names = c( "Empresa" , "Inversión" , "Percentil" ) ,
      caption = "Inversión total de la Industria y percentiles de cada inversión." )

#'

#' \newpage

#'

#' \adjustpagedim{\classpagewidth}{\classpageheight}

#'

#' - Verificar la inversión mensual.

#'

#+ chunkmsg0014, messages=FALSE, echo=TRUE
smebanco <- dbGetQuery( con , "select brand , date_part( 'month' , dates::date )
                               as mes , sum(valuation) as suma from tb_banco
                               group by brand , mes
                               order by sum(valuation) desc" )
smemarkt <- dbGetQuery( con , "select brand , date_part( 'month' , dates::date )
                               as mes , sum(valuation) as suma from tb_markt
                               group by brand , mes
                               order by sum(valuation) desc" )
kable( smebanco ,
format.args = list( decimal.mark = ',' , big.mark = '.' ) , digits = 0 ,
      col.names = c( "Empresa" , "Mes" , "Inversión" ) ,
      caption = "Inversión total de la Industria a nivel mensual." )
kable( head( smemarkt , 20 ) ,
format.args = list( decimal.mark = ',' , big.mark = '.' ) , digits = 0 ,
      col.names = c( "Empresa" , "Mes" , "Inversión" ) ,
      caption = "Inversión total de la Industria a nivel mensual." )

#'

#' \newpage

#'

#'# Datos de Banco Estado.

#'

#'## Variación de inversiones mensuales de Banco Estado.

#'

#+ chunkmsg0015, messages=FALSE, echo=FALSE
sumval.brand.dfbanco <- aggregate( impact ~ month_yr , data = dfbanco , sum )
sumval.brand.dfbanco$varipc <- c( NA , head( sumval.brand.dfbanco$impact , -1 ) )
sumval.brand.dfbanco$varipc <- ( ( sumval.brand.dfbanco$impact - sumval.brand.dfbanco$varipc ) / sumval.brand.dfbanco$impact * 100 )
sumval.brand.dfbanco$impressions <- aggregate( impressions ~ month_yr , data = dfbanco , sum )[,2]
sumval.brand.dfbanco$varimp <- c( NA , head( sumval.brand.dfbanco$impressions , -1 ) )
sumval.brand.dfbanco$varimp <- ( ( sumval.brand.dfbanco$impressions - sumval.brand.dfbanco$varimp ) / sumval.brand.dfbanco$impressions * 100 )
sumval.brand.dfbanco$valuation <- aggregate( valuation ~ month_yr , data = dfbanco , sum )[,2]
sumval.brand.dfbanco$varval <- c( NA , head( sumval.brand.dfbanco$valuation , -1 ) )
sumval.brand.dfbanco$varval <- ( ( sumval.brand.dfbanco$valuation - sumval.brand.dfbanco$varval ) / sumval.brand.dfbanco$valuation * 100 )
kable( sumval.brand.dfbanco   ,
      format.args = list(decimal.mark = ',', big.mark = ".") , digits = 2 ,
      col.names = c( "Mes" , "Impacto" , "Variación" , "Impresiones" , "Variación" , "Valorización" , "Variación" ) ,
      caption = "Variación porcentual mensual de impacto, impresiones y valorización." )

#'

#' - Una característica común es que las tres variables se comportan
#'   similar en cuanto a su variación porcentual.
#' - Esto no ocurre con el valor observado original de cada una de ellas.
#' - En ese caso, las impresiones tienen un salto abrupto en el mes de Febrero.
#'   Este comportamiento parece ser heredado por la variable valorización.
#' - La variable impacto se atenúa y aumenta solamente en el último mes,
#'   mientras que las dos restantes tienden a mostrar un efecto estacional.
#' - Esto se ve en el gráfico de evolución mensual más adelante en el que las
#'   variables impresiones y valorizaciones aumentan en Febrero y luego
#'   en Junio como evidencia de estacionalidad. Es la variable
#'   impresiones la que aumenta más abruptamente en Febrero.

#'

#'## Contabilizar outliers.

#'

#+ chunkmsg0016, messages=FALSE, echo=FALSE
dfbanco_impact_outliers      <- which( dfbanco$impact      >= ( mean( dfbanco$impact      ) + 3 * sd( dfbanco$impact      )  )  )
dfbanco_impressions_outliers <- which( dfbanco$impressions >= ( mean( dfbanco$impressions ) + 3 * sd( dfbanco$impressions )  )  )
dfbanco_valuation_outliers   <- which( dfbanco$valuation   >= ( mean( dfbanco$valuation   ) + 3 * sd( dfbanco$valuation   )  )  )
dfoutlier_banco <- data.frame( matrix( c(
length( dfbanco_impact_outliers      ) ,
length( dfbanco_impressions_outliers ) ,
length( dfbanco_valuation_outliers   ) ) ,
ncol = 3 , byrow = T ) )
colnames( dfoutlier_banco ) <- c( 'impact' , 'impressions' , 'valuation' )
rownames( dfoutlier_banco ) <- 'outliers'
kable( dfoutlier_banco   ,
      col.names = c( "Impacto" , "Impresiones" , "Valorización" ) ,
      caption = "Outliers para variables impacto, impresiones y valoraciones totales." )

#'

#+ chunkmsg0017, messages=FALSE, echo=FALSE
dfbanco_impact_outliers_2017_01      <- which( dfbanco$impact      [ dfbanco$month_yr == "2017-01" ] >= ( mean( dfbanco$impact      [ dfbanco$month_yr == "2017-01" ] ) + 3 * sd( dfbanco$impact      [ dfbanco$month_yr == "2017-01" ] )  )  )
dfbanco_impact_outliers_2017_02      <- which( dfbanco$impact      [ dfbanco$month_yr == "2017-02" ] >= ( mean( dfbanco$impact      [ dfbanco$month_yr == "2017-02" ] ) + 3 * sd( dfbanco$impact      [ dfbanco$month_yr == "2017-02" ] )  )  )
dfbanco_impact_outliers_2017_03      <- which( dfbanco$impact      [ dfbanco$month_yr == "2017-03" ] >= ( mean( dfbanco$impact      [ dfbanco$month_yr == "2017-03" ] ) + 3 * sd( dfbanco$impact      [ dfbanco$month_yr == "2017-03" ] )  )  )
dfbanco_impact_outliers_2017_04      <- which( dfbanco$impact      [ dfbanco$month_yr == "2017-04" ] >= ( mean( dfbanco$impact      [ dfbanco$month_yr == "2017-04" ] ) + 3 * sd( dfbanco$impact      [ dfbanco$month_yr == "2017-04" ] )  )  )
dfbanco_impact_outliers_2017_05      <- which( dfbanco$impact      [ dfbanco$month_yr == "2017-05" ] >= ( mean( dfbanco$impact      [ dfbanco$month_yr == "2017-05" ] ) + 3 * sd( dfbanco$impact      [ dfbanco$month_yr == "2017-05" ] )  )  )
dfbanco_impact_outliers_2017_06      <- which( dfbanco$impact      [ dfbanco$month_yr == "2017-06" ] >= ( mean( dfbanco$impact      [ dfbanco$month_yr == "2017-06" ] ) + 3 * sd( dfbanco$impact      [ dfbanco$month_yr == "2017-06" ] )  )  )
dfbanco_impact_outliers_2017_07      <- which( dfbanco$impact      [ dfbanco$month_yr == "2017-07" ] >= ( mean( dfbanco$impact      [ dfbanco$month_yr == "2017-07" ] ) + 3 * sd( dfbanco$impact      [ dfbanco$month_yr == "2017-07" ] )  )  )
dfbanco_impressions_outliers_2017_01 <- which( dfbanco$impressions [ dfbanco$month_yr == "2017-01" ] >= ( mean( dfbanco$impressions [ dfbanco$month_yr == "2017-01" ] ) + 3 * sd( dfbanco$impressions [ dfbanco$month_yr == "2017-01" ] )  )  )
dfbanco_impressions_outliers_2017_02 <- which( dfbanco$impressions [ dfbanco$month_yr == "2017-02" ] >= ( mean( dfbanco$impressions [ dfbanco$month_yr == "2017-02" ] ) + 3 * sd( dfbanco$impressions [ dfbanco$month_yr == "2017-02" ] )  )  )
dfbanco_impressions_outliers_2017_03 <- which( dfbanco$impressions [ dfbanco$month_yr == "2017-03" ] >= ( mean( dfbanco$impressions [ dfbanco$month_yr == "2017-03" ] ) + 3 * sd( dfbanco$impressions [ dfbanco$month_yr == "2017-03" ] )  )  )
dfbanco_impressions_outliers_2017_04 <- which( dfbanco$impressions [ dfbanco$month_yr == "2017-04" ] >= ( mean( dfbanco$impressions [ dfbanco$month_yr == "2017-04" ] ) + 3 * sd( dfbanco$impressions [ dfbanco$month_yr == "2017-04" ] )  )  )
dfbanco_impressions_outliers_2017_05 <- which( dfbanco$impressions [ dfbanco$month_yr == "2017-05" ] >= ( mean( dfbanco$impressions [ dfbanco$month_yr == "2017-05" ] ) + 3 * sd( dfbanco$impressions [ dfbanco$month_yr == "2017-05" ] )  )  )
dfbanco_impressions_outliers_2017_06 <- which( dfbanco$impressions [ dfbanco$month_yr == "2017-06" ] >= ( mean( dfbanco$impressions [ dfbanco$month_yr == "2017-06" ] ) + 3 * sd( dfbanco$impressions [ dfbanco$month_yr == "2017-06" ] )  )  )
dfbanco_impressions_outliers_2017_07 <- which( dfbanco$impressions [ dfbanco$month_yr == "2017-07" ] >= ( mean( dfbanco$impressions [ dfbanco$month_yr == "2017-07" ] ) + 3 * sd( dfbanco$impressions [ dfbanco$month_yr == "2017-07" ] )  )  )
dfbanco_valuation_outliers_2017_01   <- which( dfbanco$valuation   [ dfbanco$month_yr == "2017-01" ] >= ( mean( dfbanco$valuation   [ dfbanco$month_yr == "2017-01" ] ) + 3 * sd( dfbanco$valuation   [ dfbanco$month_yr == "2017-01" ] )  )  )
dfbanco_valuation_outliers_2017_02   <- which( dfbanco$valuation   [ dfbanco$month_yr == "2017-02" ] >= ( mean( dfbanco$valuation   [ dfbanco$month_yr == "2017-02" ] ) + 3 * sd( dfbanco$valuation   [ dfbanco$month_yr == "2017-02" ] )  )  )
dfbanco_valuation_outliers_2017_03   <- which( dfbanco$valuation   [ dfbanco$month_yr == "2017-03" ] >= ( mean( dfbanco$valuation   [ dfbanco$month_yr == "2017-03" ] ) + 3 * sd( dfbanco$valuation   [ dfbanco$month_yr == "2017-03" ] )  )  )
dfbanco_valuation_outliers_2017_04   <- which( dfbanco$valuation   [ dfbanco$month_yr == "2017-04" ] >= ( mean( dfbanco$valuation   [ dfbanco$month_yr == "2017-04" ] ) + 3 * sd( dfbanco$valuation   [ dfbanco$month_yr == "2017-04" ] )  )  )
dfbanco_valuation_outliers_2017_05   <- which( dfbanco$valuation   [ dfbanco$month_yr == "2017-05" ] >= ( mean( dfbanco$valuation   [ dfbanco$month_yr == "2017-05" ] ) + 3 * sd( dfbanco$valuation   [ dfbanco$month_yr == "2017-05" ] )  )  )
dfbanco_valuation_outliers_2017_06   <- which( dfbanco$valuation   [ dfbanco$month_yr == "2017-06" ] >= ( mean( dfbanco$valuation   [ dfbanco$month_yr == "2017-06" ] ) + 3 * sd( dfbanco$valuation   [ dfbanco$month_yr == "2017-06" ] )  )  )
dfbanco_valuation_outliers_2017_07   <- which( dfbanco$valuation   [ dfbanco$month_yr == "2017-07" ] >= ( mean( dfbanco$valuation   [ dfbanco$month_yr == "2017-07" ] ) + 3 * sd( dfbanco$valuation   [ dfbanco$month_yr == "2017-07" ] )  )  )
dfoutlier_banco_month_yr <- data.frame( matrix( c(
length( dfbanco_impact_outliers_2017_01      ) ,
length( dfbanco_impact_outliers_2017_02      ) ,
length( dfbanco_impact_outliers_2017_03      ) ,
length( dfbanco_impact_outliers_2017_04      ) ,
length( dfbanco_impact_outliers_2017_05      ) ,
length( dfbanco_impact_outliers_2017_06      ) ,
length( dfbanco_impact_outliers_2017_07      ) ,
length( dfbanco_impressions_outliers_2017_01 ) ,
length( dfbanco_impressions_outliers_2017_02 ) ,
length( dfbanco_impressions_outliers_2017_03 ) ,
length( dfbanco_impressions_outliers_2017_04 ) ,
length( dfbanco_impressions_outliers_2017_05 ) ,
length( dfbanco_impressions_outliers_2017_06 ) ,
length( dfbanco_impressions_outliers_2017_07 ) ,
length( dfbanco_valuation_outliers_2017_01   ) ,
length( dfbanco_valuation_outliers_2017_02   ) ,
length( dfbanco_valuation_outliers_2017_03   ) ,
length( dfbanco_valuation_outliers_2017_04   ) ,
length( dfbanco_valuation_outliers_2017_05   ) ,
length( dfbanco_valuation_outliers_2017_06   ) ,
length( dfbanco_valuation_outliers_2017_07   ) ) ,
ncol = 3 , byrow = T ) )
colnames( dfoutlier_banco_month_yr ) <- c( 'impact' , 'impressions' , 'valuation' )
rownames( dfoutlier_banco_month_yr ) <- as.character( dfipc[,1] )
kable( dfoutlier_banco_month_yr   ,
      col.names = c( "Impacto" , "Impresiones" , "Valorización" ) ,
      caption = "Outliers para variables impacto, impresiones y valoraciones mensuales." )

#'

#' - La regla de cálculo usada es de 3 veces la desviación estándar. Corresponde a una variante de la
#'   regla comúnmente usada que es un poco más restrictiva. El ancho del intervalo se puede ampliar
#'   a modo de aislar los valores atípicos más extremos si no se desea perder mucha información.
#' - Los valores contabilizados corresponden a valores que están en el extremo superior de cada muestra.
#' - El número de outliers depende de la muestra desde donde se calculen. Por eso que a nivel total
#'   el número de valores fuera de rango es distinto que a nivel mensual.
#' - Esta misma información se vará a continuación en los gráficos de caja, tanto a nivel total como mensual.

#'

#' \newpage

#'

#' \adjustpagedim{420mm}{614mm}

#'

#'## Estadígrafos de las variables de interés a nivel mensual.

#'

#+ chunkmsg0018, messages=FALSE, echo=FALSE
options( scipen = 50 )
kable( t( basicStats( dfbanco[,16:18] ) ) ,
       format.args = list(decimal.mark = ',', big.mark = ".") , digits = 2 ,
      #col.names = c( "Impacto" , "Impresiones" , "Inversiones" ) ,
       caption = "Estadígrafos generales para variables numéricas." )

#'

#+ chunkmsg0019, messages=FALSE, echo=FALSE
options( scipen = 50 )
dfipc <- data.frame( cbind( basicStats( dfbanco[ dfbanco$month_yr == "2017-01" , 16 ] ) ,
                            basicStats( dfbanco[ dfbanco$month_yr == "2017-02" , 16 ] ) ,
                            basicStats( dfbanco[ dfbanco$month_yr == "2017-03" , 16 ] ) ,
                            basicStats( dfbanco[ dfbanco$month_yr == "2017-04" , 16 ] ) ,
                            basicStats( dfbanco[ dfbanco$month_yr == "2017-05" , 16 ] ) ,
                            basicStats( dfbanco[ dfbanco$month_yr == "2017-06" , 16 ] ) ,
                            basicStats( dfbanco[ dfbanco$month_yr == "2017-07" , 16 ] ) ) )
colnames( dfipc ) <-     c( "2017-01" ,
                            "2017-02" ,
                            "2017-03" ,
                            "2017-04" ,
                            "2017-05" ,
                            "2017-06" ,
                            "2017-07" )
dfipc <- t( dfipc )
month_yr <- data.frame( month_yr = as.Date( anytime( rownames( dfipc ) ) ) )
month_yr$month_yr <- format( month_yr$month_yr , "%Y-%m" )
rownames( dfipc ) <- NULL
dfipc <- data.frame( cbind( month_yr , dfipc ) )
idxipc <- sapply( dfipc , is.factor )
dfipc[idxipc] <- lapply(dfipc[idxipc], function(x) as.numeric(as.character(x)))
kable( dfipc ,
       format.args = list(decimal.mark = ',', big.mark = ".") , digits = 2 ,
       caption = "Estadígrafos mensuales para la variable impacto." )

#'

#+ chunkmsg0020, messages=FALSE, echo=FALSE
options( scipen = 50 )
dfimp <- data.frame( cbind( basicStats( dfbanco[ dfbanco$month_yr == "2017-01" , 17 ] ) ,
                            basicStats( dfbanco[ dfbanco$month_yr == "2017-02" , 17 ] ) ,
                            basicStats( dfbanco[ dfbanco$month_yr == "2017-03" , 17 ] ) ,
                            basicStats( dfbanco[ dfbanco$month_yr == "2017-04" , 17 ] ) ,
                            basicStats( dfbanco[ dfbanco$month_yr == "2017-05" , 17 ] ) ,
                            basicStats( dfbanco[ dfbanco$month_yr == "2017-06" , 17 ] ) ,
                            basicStats( dfbanco[ dfbanco$month_yr == "2017-07" , 17 ] ) ) )
colnames( dfimp ) <-     c( "2017-01" ,
                            "2017-02" ,
                            "2017-03" ,
                            "2017-04" ,
                            "2017-05" ,
                            "2017-06" ,
                            "2017-07" )
dfimp <- t( dfimp )
month_yr <- data.frame( month_yr = as.Date( anytime( rownames( dfimp ) ) ) )
month_yr$month_yr <- format( month_yr$month_yr , "%Y-%m" )
rownames( dfimp ) <- NULL
dfimp <- data.frame( cbind( month_yr , dfimp ) )
idximp <- sapply( dfimp , is.factor )
dfimp[idximp] <- lapply(dfimp[idximp], function(x) as.numeric(as.character(x)))
kable( dfimp ,
       format.args = list(decimal.mark = ',', big.mark = ".") , digits = 2 ,
       caption = "Estadígrafos mensuales para la variable impresiones." )

#'

#+ chunkmsg0021, messages=FALSE, echo=FALSE
options( scipen = 50 )
dfval <- data.frame( cbind( basicStats( dfbanco[ dfbanco$month_yr == "2017-01" , 18 ] ) ,
                            basicStats( dfbanco[ dfbanco$month_yr == "2017-02" , 18 ] ) ,
                            basicStats( dfbanco[ dfbanco$month_yr == "2017-03" , 18 ] ) ,
                            basicStats( dfbanco[ dfbanco$month_yr == "2017-04" , 18 ] ) ,
                            basicStats( dfbanco[ dfbanco$month_yr == "2017-05" , 18 ] ) ,
                            basicStats( dfbanco[ dfbanco$month_yr == "2017-06" , 18 ] ) ,
                            basicStats( dfbanco[ dfbanco$month_yr == "2017-07" , 18 ] ) ) )
colnames( dfval ) <-     c( "2017-01" ,
                            "2017-02" ,
                            "2017-03" ,
                            "2017-04" ,
                            "2017-05" ,
                            "2017-06" ,
                            "2017-07" )
dfval <- t( dfval )
month_yr <- data.frame( month_yr = as.Date( anytime( rownames( dfval ) ) ) )
month_yr$month_yr <- format( month_yr$month_yr , "%Y-%m" )
rownames( dfval ) <- NULL
dfval <- data.frame( cbind( month_yr , dfval ) )
idxval <- sapply( dfval , is.factor )
dfval[idxval] <- lapply(dfval[idxval], function(x) as.numeric(as.character(x)))
kable( dfval ,
       format.args = list(decimal.mark = ',', big.mark = ".") , digits = 2 ,
       caption = "Estadígrafos mensuales para la variable valorizaciones." )

#'

#+ chunkmsg0022, messages=FALSE, echo=FALSE
arripc0001 <- with( dfipc , tapply( Sum , month_yr , function( v ) sum( v ) ) )
arrimp0001 <- with( dfimp , tapply( Sum , month_yr , function( v ) sum( v ) ) )
arrval0001 <- with( dfval , tapply( Sum , month_yr , function( v ) sum( v ) ) )
trripc0001 = "Impactos mensuales <= 1.000\nde Banco Estado"
trrimp0001 = "Impresiones mensuales <= 10.000\nde Banco Estado"
trrval0001 = "Valoraciones mensuales <= 10.000\nde Banco Estado"
# png(filename="./pic/pngbp0001.png", type="cairo", units="in", width=12, height=4, pointsize=12, res=96)
pdf("./pic/pdf0001.pdf", width=18, height=6)
layout( matrix( c( 1,1,2,2,3,3,1,1,2,2,3,3 ) , nrow = 2 , ncol = 6 , byrow = TRUE ) )
par( mai = c( 0,0.3,0,0 ) + 0.5 ) ; hist( dfbanco$impact      [ dfbanco$impact      <= 10*10^3 ] , xlim = c( 0 , 10*10^3 ) , ylim = c( 0 , 800 ) , main = trripc0001 , col = greenseq , las = 1 )
par( mai = c( 0,0.3,0,0 ) + 0.5 ) ; hist( dfbanco$impressions [ dfbanco$impressions <= 10*10^4 ] , xlim = c( 0 , 10*10^4 ) , ylim = c( 0 , 800 ) , main = trrimp0001 , col = greenseq , las = 1 )
par( mai = c( 0,0.3,0,0 ) + 0.5 ) ; hist( dfbanco$valuation   [ dfbanco$valuation   <= 10*10^4 ] , xlim = c( 0 , 10*10^4 ) , ylim = c( 0 , 800 ) , main = trrval0001 , col = greenseq , las = 1 )
suppressMessages( suppressWarnings( dev.off() ) )

#'

#' \begin{figure}[h]
#' \caption{Histograma del extremo izquierdo de la distribución de, impacto, impresiones y valorizaciones.}
#' \vspace{0.5cm}
#' \includegraphics{./pic/pdf0001.pdf}
#' \end{figure}

#'

#+ chunkmsg0023, messages=FALSE, echo=FALSE
arripc0002 <- with( dfipc , tapply( Sum , month_yr , function( v ) sum( v ) ) )
arrimp0002 <- with( dfimp , tapply( Sum , month_yr , function( v ) sum( v ) ) )
arrval0002 <- with( dfval , tapply( Sum , month_yr , function( v ) sum( v ) ) )
trripc0002 = "Impactos mensuales >= 1.000\nde Banco Estado"
trrimp0002 = "Impresiones mensuales >= 10.000\nde Banco Estado"
trrval0002 = "Valoraciones mensuales >= 10.000\nde Banco Estado"
# png(filename="./pic/pngbp0001.png", type="cairo", units="in", width=12, height=4, pointsize=12, res=96)
pdf("./pic/pdf0002.pdf", width=18, height=6)
layout( matrix( c( 1,1,2,2,3,3,1,1,2,2,3,3 ) , nrow = 2 , ncol = 6 , byrow = TRUE ) )
par( mai = c( 0,0.3,0,0 ) + 0.5 ) ; hist( dfbanco$impact      [ dfbanco$impact      >= 10*10^4 ] , xlim = c( 10*10^4 , 1 *10^6 ) , ylim = c( 0 , 15 ) , main = trripc0002 , col = greenseq , las = 1 )
par( mai = c( 0,0.3,0,0 ) + 0.5 ) ; hist( dfbanco$impressions [ dfbanco$impressions >= 10*10^5 ] , xlim = c( 10*10^5 , 10*10^6 ) , ylim = c( 0 , 15 ) , main = trrimp0002 , col = greenseq , las = 1 )
par( mai = c( 0,0.3,0,0 ) + 0.5 ) ; hist( dfbanco$valuation   [ dfbanco$valuation   >= 10*10^5 ] , xlim = c( 10*10^5 , 10*10^6 ) , ylim = c( 0 , 15 ) , main = trrval0002 , col = greenseq , las = 1 )
suppressMessages( suppressWarnings( dev.off() ) )

#'

#' \begin{figure}[h]
#' \caption{Histograma del extremo derecho de la distribución de, impacto, impresiones y valorizaciones.}
#' \vspace{0.5cm}
#' \includegraphics{./pic/pdf0002.pdf}
#' \end{figure}

#'

#+ chunkmsg0024, messages=FALSE, echo=FALSE
arripc0003 <- with( dfipc , tapply( Sum , month_yr , function( v ) sum( v ) ) )
arrimp0003 <- with( dfimp , tapply( Sum , month_yr , function( v ) sum( v ) ) )
arrval0003 <- with( dfval , tapply( Sum , month_yr , function( v ) sum( v ) ) )
trripc0003 = "Impactos mensuales escala\nlogarítmica de Banco Estado"
trrimp0003 = "Impresiones mensuales escala\nlogarítmica de Banco Estado"
trrval0003 = "Valoraciones mensuales escala\nlogarítmica de Banco Estado"
# png(filename="./pic/pngbp0001.png", type="cairo", units="in", width=12, height=4, pointsize=12, res=96)
pdf("./pic/pdf0003.pdf", width=18, height=6)
layout( matrix( c( 1,1,2,2,3,3,1,1,2,2,3,3 ) , nrow = 2 , ncol = 6 , byrow = TRUE ) )
par( mai = c( 0,0.3,0,0 ) + 0.5 ) ; hist(             log(      dfbanco$impact      )            , xlim = c( 0       , 2 *10^1 ) , ylim = c( 0 , 200 ) , main = trripc0003 , col = greenseq , las = 1 )
par( mai = c( 0,0.3,0,0 ) + 0.5 ) ; hist(             log(      dfbanco$impressions )            , xlim = c( 0       , 2 *10^1 ) , ylim = c( 0 , 200 ) , main = trrimp0003 , col = greenseq , las = 1 )
par( mai = c( 0,0.3,0,0 ) + 0.5 ) ; hist(             log(      dfbanco$valuation   )            , xlim = c( 0       , 2 *10^1 ) , ylim = c( 0 , 200 ) , main = trrval0003 , col = greenseq , las = 1 )
suppressMessages( suppressWarnings( dev.off() ) )

#'

#' \begin{figure}[h]
#' \caption{Histograma en escala logarítmica de la distribución de, impacto, impresiones y valorizaciones.}
#' \vspace{0.5cm}
#' \includegraphics{./pic/pdf0003.pdf}
#' \end{figure}

#'

#' - El histograma de cola izquierda y derecha muestran que la distribución está cargada hacia
#'   la derecha en las tres variables. Esto se llama \textit{right skewed} en inglés y significa
#'   que son asimétricas hacia la derecha.
#' - En el primer histograma, tenemos que en el extremo izquierdo se concentran la mayor cantidad
#'   de observaciones de la muestra para las tres variables, llegando a un número por sobre 600
#'   observaciones.
#' - En el segundo histograma, tenemos que el extremo derecho concentra menos de 20 observaciones.
#'   Es en este extremo donde se registran valores de impactos, impresiones y valorizaciones más
#'   elevados.
#' - Por un lado, el extremo derecho, si bien es cierto es menos concentrado en valores muestreados,
#'   solo se encuentra una menor cantidad de observaciones de la muestra en este lado de la distribución.
#' - Esto implica que habrá una mayor carga de trabajo en análisis en los cálculos más
#'   pequeños en los muestreos rutinarios, porque es en ese extremo donde hay un mayor nivel de
#'   incertidumbre.
#' - El tercer histograma, muestra una representación normal logarítmica para cada muestra.
#'   Es una representación que se usa con regularidad para muestras que son fuertemente sesgadas
#'   hacia la izquierda (con asimetría derecha).
#' - Se puede ver en este gráfico que la variable impresiones tiene forma bimodal. La bimodalidad
#'   según lo visto en este análsis, puede tener origen en que las campañas son realizadas en periodos
#'   específicos del año, lo que explicaría una suerte de estacionalidad. Esto sería como evidencia
#'   de un comportamiento con dos fenómenos distintos dentro de un periodo de 7 meses. Posiblemente
#'   se trate de un inicio de año con una fuerte campaña en publicidad, lo que no se alcanza a repetir
#'   hasta el mes de Julio, en lo que se vería un proceso diferente al de los primeros 2 meses.
#' - Para efectos de modelización, usar una distribución unimodal tiene menos incertidumbre que una
#'   bimodal. Es decir, si se quiere explicar el comportamiento de una variable con fines de optimizar
#'   costos de impresiones, como el CPM, la estacionalidad puede ser una fuente de incertidumbre que debiera
#'   ser modelada.
#' - Los supuestos son más sencillos para un modelo cuya distribución es unimodal, mientras que para una bimodal
#'   son más desafiantes y menos usados en la práctica.

#'

#+ chunkmsg0025, messages=FALSE, echo=FALSE
arripc0004 <- with( dfipc , tapply( Sum , month_yr , function( v ) sum( v ) ) )
arrimp0004 <- with( dfimp , tapply( Sum , month_yr , function( v ) sum( v ) ) )
arrval0004 <- with( dfval , tapply( Sum , month_yr , function( v ) sum( v ) ) )
trripc0004 = "Impactos mensuales totales\nde Banco Estado"
trrimp0004 = "Impresiones mensuales totales\nde Banco Estado"
trrval0004 = "Valoraciones mensuales totales\nde Banco Estado"
# png(filename="./pic/pngbp0001.png", type="cairo", units="in", width=12, height=4, pointsize=12, res=96)
pdf("./pic/pdf0004.pdf", width=18, height=6)
layout( matrix( c( 1,1,2,2,3,3,1,1,2,2,3,3 ) , nrow = 2 , ncol = 6 , byrow = TRUE ) )
par( mai = c( 0,0.3,0,0 ) + 0.5 ) ; boxplot( impact      ~ month_yr , data = dfbanco , main = trripc0004 , col = greenseq , cex.names = 0.8 , yaxt = "n" ) ; axis( 2 , las = 1 , at = axTicks( 2 ) , labels = sprintf( "%2.2E", axTicks( 2 ) ) )
par( mai = c( 0,0.3,0,0 ) + 0.5 ) ; boxplot( impressions ~ month_yr , data = dfbanco , main = trrimp0004 , col = greenseq , cex.names = 0.8 , yaxt = "n" ) ; axis( 2 , las = 1 , at = axTicks( 2 ) , labels = sprintf( "%2.2E", axTicks( 2 ) ) )
par( mai = c( 0,0.3,0,0 ) + 0.5 ) ; boxplot( valuation   ~ month_yr , data = dfbanco , main = trrval0004 , col = greenseq , cex.names = 0.8 , yaxt = "n" ) ; axis( 2 , las = 1 , at = axTicks( 2 ) , labels = sprintf( "%2.2E", axTicks( 2 ) ) )
suppressMessages( suppressWarnings( dev.off() ) )

#'

#' \begin{figure}[h]
#' \caption{Gráfico de cajas de evolución mensual de impacto, impresiones y valorizaciones.}
#' \vspace{0.5cm}
#' \includegraphics{./pic/pdf0004.pdf}
#' \end{figure}

#'

#+ chunkmsg0026, messages=FALSE, echo=FALSE
arripc0005 <- with( dfipc , tapply( Sum , month_yr , function( v ) sum( v ) ) )
arrimp0005 <- with( dfimp , tapply( Sum , month_yr , function( v ) sum( v ) ) )
arrval0005 <- with( dfval , tapply( Sum , month_yr , function( v ) sum( v ) ) )
trripc0005 = "Impactos mensuales totales\nde Banco Estado"
trrimp0005 = "Impresiones mensuales totales\nde Banco Estado"
trrval0005 = "Valoraciones mensuales totales\nde Banco Estado"
# png(filename="./pic/pngbp0002.png", type="cairo", units="in", width=12, height=4, pointsize=12, res=96)
pdf("./pic/pdf0005.pdf", width=18, height=6)
layout( matrix( c( 1,1,2,2,3,3,1,1,2,2,3,3 ) , nrow = 2 , ncol = 6 , byrow = TRUE ) )
par( mai = c( 0,0.3,0,0 ) + 0.5 ) ; boxplot( impact      ~ month_yr , data = dfbanco , main = trripc0005 , log = "y" , col = greenseq , cex.names = 0.8 , yaxt = "n" ) ; axis( 2 , las = 1 , at = axTicks( 2 ) , labels = sprintf( "%2.2E", axTicks( 2 ) ) )
par( mai = c( 0,0.3,0,0 ) + 0.5 ) ; boxplot( impressions ~ month_yr , data = dfbanco , main = trrimp0005 , log = "y" , col = greenseq , cex.names = 0.8 , yaxt = "n" ) ; axis( 2 , las = 1 , at = axTicks( 2 ) , labels = sprintf( "%2.2E", axTicks( 2 ) ) )
par( mai = c( 0,0.3,0,0 ) + 0.5 ) ; boxplot( valuation   ~ month_yr , data = dfbanco , main = trrval0005 , log = "y" , col = greenseq , cex.names = 0.8 , yaxt = "n" ) ; axis( 2 , las = 1 , at = axTicks( 2 ) , labels = sprintf( "%2.2E", axTicks( 2 ) ) )
suppressMessages( suppressWarnings( dev.off() ) )

#'

#' \begin{figure}[h]
#' \caption{Gráfico de cajas en escala logarítmica de evolución mensual de impacto, impresiones y valorizaciones.}
#' \vspace{0.5cm}
#' \includegraphics{./pic/pdf0005.pdf}
#' \end{figure}

#'

#' - Los gráficos de caja o \textit{boxplots} muestran un gran número de \textit{outliers} en cada muestra. Los
#'   \textit{outliers} son los puntos sobre cada caja en cada gráfico. Se han graficado tanto los valores originales
#'   como sus respectivas transformaciones logarítmicas para mejorar la visualización dada la fuerte asimetría de cada
#'   distribución.
#' - Existe un patrón diferente en los primeros 3 meses versus los 3 siguientes. Esto es similar a lo visto en el cuadro
#'   de evolución mensual. El mes de Julio en cambio no muestra un comportamiento similares a los 6 primeros meses.
#' - Las cajas muestran el rango de dispersión que hay entre los percentiles 25 y 75. La variable impresiones
#'   tiene una mayor dispersión en el mes de Enero. Mientras que las valoraciones tienen una mayor dispersión en Febrero
#'   y Marzo.
#' - Los \textit{outliers} contabilizados por medio de los gráficos usan una fórmula más astringente que la presentada en
#'   los cuadros iniciales. En este caso, se trata de 1,5 veces por el rango intercuartilico. Por ser un intervalo más pequeño
#'   que el anterior contabiliza más \textit{outliers}.

#'

#' \newpage

#'

#+ chunkmsg0027, messages=FALSE, echo=FALSE
arripc0006 <- with( sumval.brand.dfbanco , tapply( impact      , month_yr , function( v ) sum( v ) ) )
arrimp0006 <- with( sumval.brand.dfbanco , tapply( impressions , month_yr , function( v ) sum( v ) ) )
arrval0006 <- with( sumval.brand.dfbanco , tapply( valuation   , month_yr , function( v ) sum( v ) ) )
trripc0006 = "Impactos mensuales totales\nde Banco Estado"
trrimp0006 = "Impresiones mensuales totales\nde Banco Estado"
trrval0006 = "Valoraciones mensuales totales\nde Banco Estado"
# png(filename="./pic/pngbp0003.png", type="cairo", units="in", width=12, height=4, pointsize=12, res=96)
pdf("./pic/pdf0006.pdf", width=18, height=6)
layout( matrix( c( 1,1,2,2,3,3,1,1,2,2,3,3 ) , nrow = 2 , ncol = 6 , byrow = TRUE ) )
par( mai = c( 0,0.3,0,0 ) + 0.5 ) ; barplot( arripc0006 , main = trripc0006 , col = greenseq , ylim = c( 0 , 50*10^6 ) , cex.names = 1.0 , yaxt = "n" ) ; axis( 2 , las = 1 , at = axTicks( 2 ) , labels = sprintf( "%2.2E", axTicks( 2 ) ) )
par( mai = c( 0,0.3,0,0 ) + 0.5 ) ; barplot( arrimp0006 , main = trrimp0006 , col = greenseq , ylim = c( 0 , 50*10^6 ) , cex.names = 1.0 , yaxt = "n" ) ; axis( 2 , las = 1 , at = axTicks( 2 ) , labels = sprintf( "%2.2E", axTicks( 2 ) ) )
par( mai = c( 0,0.3,0,0 ) + 0.5 ) ; barplot( arrval0006 , main = trrval0006 , col = greenseq , ylim = c( 0 , 50*10^6 ) , cex.names = 1.0 , yaxt = "n" ) ; axis( 2 , las = 1 , at = axTicks( 2 ) , labels = sprintf( "%2.2E", axTicks( 2 ) ) )
suppressMessages( suppressWarnings( dev.off() ) )

#'

#' \begin{figure}[h]
#' \caption{Gráfico de barras de evolución mensual de impacto, impresiones y valorizaciones.}
#' \vspace{0.5cm}
#' \includegraphics{./pic/pdf0006.pdf}
#' \end{figure}

#'

#+ chunkmsg0028, messages=FALSE, echo=FALSE
arripc0007 <- with( sumval.brand.dfbanco , tapply( varipc , month_yr , function( v ) sum( v ) ) )
arrimp0007 <- with( sumval.brand.dfbanco , tapply( varimp , month_yr , function( v ) sum( v ) ) )
arrval0007 <- with( sumval.brand.dfbanco , tapply( varval , month_yr , function( v ) sum( v ) ) )
trripc0007 = "Variación porcentual de Impactos\nmensuales totales de Banco Estado"
trrimp0007 = "Variación porcentual de Impresiones\nmensuales totales de Banco Estado"
trrval0007 = "Variación porcentual de Valoraciones\nmensuales totales de Banco Estado"
# png(filename="./pic/pngbp0004.png", type="cairo", units="in", width=12, height=4, pointsize=12, res=96)
pdf("./pic/pdf0007.pdf", width=18, height=6)
layout( matrix( c( 1,1,2,2,3,3,1,1,2,2,3,3 ) , nrow = 2 , ncol = 6 , byrow = TRUE ) )
par( mai = c( 0,0.3,0,0 ) + 0.5 ) ; barplot( arripc0007 , main = trripc0007 , col = greenseq , ylim = c( -1500 , 250 ) , cex.names = 1.0 , yaxt = "n" ) ; axis( 2 , las = 1 , at = axTicks( 2 ) , labels = sprintf( "%2.2E", axTicks( 2 ) ) )
par( mai = c( 0,0.3,0,0 ) + 0.5 ) ; barplot( arrimp0007 , main = trrimp0007 , col = greenseq , ylim = c( -1500 , 250 ) , cex.names = 1.0 , yaxt = "n" ) ; axis( 2 , las = 1 , at = axTicks( 2 ) , labels = sprintf( "%2.2E", axTicks( 2 ) ) )
par( mai = c( 0,0.3,0,0 ) + 0.5 ) ; barplot( arrval0007 , main = trrval0007 , col = greenseq , ylim = c( -1500 , 250 ) , cex.names = 1.0 , yaxt = "n" ) ; axis( 2 , las = 1 , at = axTicks( 2 ) , labels = sprintf( "%2.2E", axTicks( 2 ) ) )
suppressMessages( suppressWarnings( dev.off() ) )

#'

#' \begin{figure}[h]
#' \caption{Gráfico de barras de variación porcentual mensual de impacto, impresiones y valorizaciones.}
#' \vspace{0.5cm}
#' \includegraphics{./pic/pdf0007.pdf}
#' \end{figure}

#'

#' - Los gráficos de barras evidencian que el muestreo fue mucho mayor en el mes de Febrero, mientras que los meses
#'   siguientes se ve un una disminución notoria. Sería necesario contrastar esta evidencia con empresas de la misma
#'   industria para verificar patrones similares. Poder observar más de dos meses permite tener una idea de posible
#'   comportamiento en estaciones, lo cual se puede modelizar dentro de alguna técnica de machine learning.
#' - Las variaciones porcentuales tienden a acentuarse para el caso de Marzo y Abril, dado por la fuerte caida que se ve
#'   en los valores originales de cada variable. Esta es otra representación que evidenciaría un esquema estacional.
#' - Estos gráficos señalan que las tres variables heredan un comportamiento similar. Debido a la metodología de
#'   cálculo estas variables deben estar correlacionadas. Para efectos de modelización, bastaría con usar alguna
#'   de ellas dado que al usarlas todas se estaría duplicando información. No se puede invertir la matriz de información
#'   con variables que comparten un mismo cálculo, lo que es necesario para un modelo logístico o lineal múltiple.
#'   A esto se le llama singularidad o colinealidad y es sencillo corroborarlo.
#' - Con fines de mejora continua es importante detectar valores atípicos en toda variable involucrada en el
#'   proceso de muestreo y estimaciones totales.
#' - Por otro lado, las impresiones son elevadas en comparación con las otras variables. Estas son estimaciones de
#'   SimilarWeb, lo que indica que habría que identificar cómo mejorar el proceso de mejora de estimación total
#'   de valorización. Específicamente midiendo la incertidumbre que genera la incorporación de la información
#'   proveniente de los \textit{pageviews} de SimilarWeb. Posiblemente penalizar, sobre la estimación, los elevados
#'   valores de impresiones o usar un símil de factor de expansión que represente un segmento de la muestra que
#'   pondera como más elevado que otros en el mismo periodo y estratificarlo según número de impresiones.

#'

#' \newpage

#'

#'## Variación de inversiones mensuales de Banco Estado según campaña.

#'

#+ chunkmsg0029, messages=FALSE, echo=FALSE
sumval.campaign.dfbanco <- aggregate( valuation ~ campaign_name + month_yr , data = dfbanco , sum ) %>% spread( month_yr , valuation )
sumval.campaign.dfbanco$tot <- rowSums( sumval.campaign.dfbanco[,2:8] , na.rm = T , dims = 1 )
sumval.campaign.dfbanco$var <- ( ( rowSums( sumval.campaign.dfbanco[,4:8] , na.rm = T , dims = 1 ) - rowSums( sumval.campaign.dfbanco[,2:3] , na.rm = T , dims = 1 ) ) / rowSums( sumval.campaign.dfbanco[,4:8] , na.rm = T , dims = 1 ) * 100 )
sumval.campaign.dfbanco$var[ sumval.campaign.dfbanco$var == "-Inf" ] <- NA
kable( sumval.campaign.dfbanco   ,
      format.args = list(decimal.mark = ',', big.mark = ".") , digits = 2 ,
      col.names = c( "Campaña" , colnames( sumval.campaign.dfbanco )[2:8] , "Total" , "Variación" ) ,
      caption = "Evolución mensual de inversión según campaña." )

#'

#' - El cuadro muestra que el canal publicitario que permanece constante en inversiones, es el Home de Banco Estado.
#' - Por otro lado, hay otros canales donde hay estimaciones fuertes, tales como, el programa "En fácil y en chileno"
#'   tanto por youtube como por el mismo sitio de la campaña, con 12 y 8 millones, en Enero y Febrero, respectivamente.
#' - Estos dos últimos generan incertidumbre en dichos periodos, al igual que, los canales de "Ahorro e inversiones",
#'   "Crédito hipotecario" y "Tarjeta visa", entre los meses de Mayo y Julio con altos valores en estimaciones.
#' - Como aclaración, la incertidumbre es lo que se modeliza en a través de un modelo estadístico o de machine learning.
#'   Es un concepto que se utiliza aquí solamente con fines técnicos, cuyo potencial es la mejora mediante la compresión
#'   de ese comportamiento usando una herramienta estadística, tales como, regresión logística, árboles de clasificación,
#'   redes neuronales, etc.
#' - La modelización tendría dos necesidades fuertes. Por un lado, medir el comportamiento mensual de variables relevantes,
#'   en busca de patrones comunes en el tiempo y definir estrategias de mejora en esa dirección. Por otro lado, mejora en
#'   el proceso de muestreo. Habría que hacer supuestos en cuanto a qué nivel de estimaciones se obtendrían en periodos y
#'   canales determinados, considerando la alta asimetría en las muestras, la periodicidad del levantamiento, estimaciones
#'   localizadas y extremas versus estimaciones más pequeñas y constantes, entre otras estrategias.

#'

#'## Variación de inversiones mensuales de Banco Estado según website.

#'

#+ chunkmsg0030, messages=FALSE, echo=FALSE
sumval.website.dfbanco <- aggregate( valuation ~ website + month_yr , data = dfbanco , sum ) %>% spread( month_yr , valuation )
sumval.website.dfbanco$tot <- rowSums( sumval.website.dfbanco[,2:8] , na.rm = T , dims = 1 )
sumval.website.dfbanco$var <- ( ( rowSums( sumval.website.dfbanco[,4:8] , na.rm = T , dims = 1 ) - rowSums( sumval.website.dfbanco[,2:3] , na.rm = T , dims = 1 ) ) / rowSums( sumval.website.dfbanco[,4:8] , na.rm = T , dims = 1 ) * 100 )
sumval.website.dfbanco <- sumval.website.dfbanco[ order( sumval.website.dfbanco[,9] , decreasing = T ) , ]
sumval.website.dfbanco$var[ sumval.website.dfbanco$var == "-Inf" ] <- NA
kable( head( sumval.website.dfbanco , 25 ) ,
      format.args = list(decimal.mark = ',', big.mark = ".") , digits = 2 ,
      col.names = c( "Website" , colnames( sumval.website.dfbanco )[2:8] , "Total" , "Variación" ) ,
      caption = "Evolución mensual de inversión según website." )

#'

#' - Este cuadro muestra los primeros 20 sitios web con mayor nivel de inversiones estimado.
#'   Los sitios "youtube", "Facebook" y "lun.com", llevan la delantera en el mes de Febrero, lo que ya se ha
#'   ha visto en visualizaciones anteriores.
#' - El sitio Youtube vuelve a aumentar en el mes de Mayo y Junio, lo que resulta muy interesante. El mes
#'   de Febrero también es muy elevado como ya se ha visto anteriormente.
#' - Se ve nuevamente un fuerte aumento en el mes de Febrero en camapañas en varios sitios web.
#' - Por otro lado, hay sitios web donde hay evidencia de valorizaciones que se mantienen permanentemente
#'   a diferencia de otros en los que se concentra en meses puntuales. Aquí hay dos comportamientos diferentes
#'   que debieran abordarse con estrategias distintas.

#'

#'## Variación de impactos mensuales de Banco Estado según tipo de publicidad y dispositivo.

#'

#+ chunkmsg0031, messages=FALSE, echo=FALSE
sumval.ad_type.dfbanco.ipc          <- data.frame(                                     display = with( dfbanco , tapply( impact , list( month_yr , ad_type ) , sum ) )[,1] )
sumval.ad_type.dfbanco.ipc$vardis   <- c( NA , head( sumval.ad_type.dfbanco.ipc$display , -1 ) )
sumval.ad_type.dfbanco.ipc$vardis   <- ( ( sumval.ad_type.dfbanco.ipc$display - sumval.ad_type.dfbanco.ipc$vardis ) / sumval.ad_type.dfbanco.ipc$display * 100 )
sumval.ad_type.dfbanco.ipc          <- data.frame( cbind( sumval.ad_type.dfbanco.ipc , video   = with( dfbanco , tapply( impact , list( month_yr , ad_type ) , sum ) )[,2] ) )
sumval.ad_type.dfbanco.ipc$varvid   <- c( NA , head( sumval.ad_type.dfbanco.ipc$video   , -1 ) )
sumval.ad_type.dfbanco.ipc$varvid   <- ( ( sumval.ad_type.dfbanco.ipc$video   - sumval.ad_type.dfbanco.ipc$varvid ) / sumval.ad_type.dfbanco.ipc$video   * 100 )
sumval.ad_type.dfbanco.ipc          <- data.frame( cbind( sumval.ad_type.dfbanco.ipc , desktop = with( dfbanco , tapply( impact , list( month_yr , device  ) , sum ) )[,1] ) )
sumval.ad_type.dfbanco.ipc$vardes   <- c( NA , head( sumval.ad_type.dfbanco.ipc$desktop , -1 ) )
sumval.ad_type.dfbanco.ipc$vardes   <- ( ( sumval.ad_type.dfbanco.ipc$desktop - sumval.ad_type.dfbanco.ipc$vardes ) / sumval.ad_type.dfbanco.ipc$desktop * 100 )
sumval.ad_type.dfbanco.ipc          <- data.frame( cbind( sumval.ad_type.dfbanco.ipc , mobile  = with( dfbanco , tapply( impact , list( month_yr , device  ) , sum ) )[,2] ) )
sumval.ad_type.dfbanco.ipc$varmob   <- c( NA , head( sumval.ad_type.dfbanco.ipc$mobile  , -1 ) )
sumval.ad_type.dfbanco.ipc$varmob   <- ( ( sumval.ad_type.dfbanco.ipc$mobile  - sumval.ad_type.dfbanco.ipc$varmob ) / sumval.ad_type.dfbanco.ipc$mobile  * 100 )
kable(       sumval.ad_type.dfbanco.ipc        ,
      format.args = list(decimal.mark = ',', big.mark = ".") , digits = 2 ,
      col.names = c( "Display" , "Variación" , "Video" , "Variación" , "Desktop" , "Variación" , "Mobile" , "Variación" ) ,
      caption = "Evolución mensual de impacto según tipo de publicidad y dispositivo." )

#'

#'## Variación de impresiones mensuales de Banco Estado según tipo de publicidad y dispositivo.

#'

#+ chunkmsg0032, messages=FALSE, echo=FALSE
sumval.ad_type.dfbanco.imp          <- data.frame(                                     display = with( dfbanco , tapply( impressions , list( month_yr , ad_type ) , sum ) )[,1] )
sumval.ad_type.dfbanco.imp$vardis   <- c( NA , head( sumval.ad_type.dfbanco.imp$display , -1 ) )
sumval.ad_type.dfbanco.imp$vardis   <- ( ( sumval.ad_type.dfbanco.imp$display - sumval.ad_type.dfbanco.imp$vardis ) / sumval.ad_type.dfbanco.imp$display * 100 )
sumval.ad_type.dfbanco.imp          <- data.frame( cbind( sumval.ad_type.dfbanco.imp , video   = with( dfbanco , tapply( impressions , list( month_yr , ad_type ) , sum ) )[,2] ) )
sumval.ad_type.dfbanco.imp$varvid   <- c( NA , head( sumval.ad_type.dfbanco.imp$video   , -1 ) )
sumval.ad_type.dfbanco.imp$varvid   <- ( ( sumval.ad_type.dfbanco.imp$video   - sumval.ad_type.dfbanco.imp$varvid ) / sumval.ad_type.dfbanco.imp$video   * 100 )
sumval.ad_type.dfbanco.imp          <- data.frame( cbind( sumval.ad_type.dfbanco.imp , desktop = with( dfbanco , tapply( impressions , list( month_yr , device  ) , sum ) )[,1] ) )
sumval.ad_type.dfbanco.imp$vardes   <- c( NA , head( sumval.ad_type.dfbanco.imp$desktop , -1 ) )
sumval.ad_type.dfbanco.imp$vardes   <- ( ( sumval.ad_type.dfbanco.imp$desktop - sumval.ad_type.dfbanco.imp$vardes ) / sumval.ad_type.dfbanco.imp$desktop * 100 )
sumval.ad_type.dfbanco.imp          <- data.frame( cbind( sumval.ad_type.dfbanco.imp , mobile  = with( dfbanco , tapply( impressions , list( month_yr , device  ) , sum ) )[,2] ) )
sumval.ad_type.dfbanco.imp$varmob   <- c( NA , head( sumval.ad_type.dfbanco.imp$mobile  , -1 ) )
sumval.ad_type.dfbanco.imp$varmob   <- ( ( sumval.ad_type.dfbanco.imp$mobile  - sumval.ad_type.dfbanco.imp$varmob ) / sumval.ad_type.dfbanco.imp$mobile  * 100 )
kable(       sumval.ad_type.dfbanco.imp        ,
      format.args = list(decimal.mark = ',', big.mark = ".") , digits = 2 ,
      col.names = c( "Display" , "Variación" , "Video" , "Variación" , "Desktop" , "Variación" , "Mobile" , "Variación" ) ,
      caption = "Evolución mensual de impresiones según tipo de publicidad y dispositivo." )

#'

#'## Variación de inversiones mensuales de Banco Estado según tipo de publicidad y dispositivo.

#'

#+ chunkmsg0033, messages=FALSE, echo=FALSE
sumval.ad_type.dfbanco.val          <- data.frame(                                     display = with( dfbanco , tapply( valuation , list( month_yr , ad_type ) , sum ) )[,1] )
sumval.ad_type.dfbanco.val$vardis   <- c( NA , head( sumval.ad_type.dfbanco.val$display , -1 ) )
sumval.ad_type.dfbanco.val$vardis   <- ( ( sumval.ad_type.dfbanco.val$display - sumval.ad_type.dfbanco.val$vardis ) / sumval.ad_type.dfbanco.val$display * 100 )
sumval.ad_type.dfbanco.val          <- data.frame( cbind( sumval.ad_type.dfbanco.val , video   = with( dfbanco , tapply( valuation , list( month_yr , ad_type ) , sum ) )[,2] ) )
sumval.ad_type.dfbanco.val$varvid   <- c( NA , head( sumval.ad_type.dfbanco.val$video   , -1 ) )
sumval.ad_type.dfbanco.val$varvid   <- ( ( sumval.ad_type.dfbanco.val$video   - sumval.ad_type.dfbanco.val$varvid ) / sumval.ad_type.dfbanco.val$video   * 100 )
sumval.ad_type.dfbanco.val          <- data.frame( cbind( sumval.ad_type.dfbanco.val , desktop = with( dfbanco , tapply( valuation , list( month_yr , device  ) , sum ) )[,1] ) )
sumval.ad_type.dfbanco.val$vardes   <- c( NA , head( sumval.ad_type.dfbanco.val$desktop , -1 ) )
sumval.ad_type.dfbanco.val$vardes   <- ( ( sumval.ad_type.dfbanco.val$desktop - sumval.ad_type.dfbanco.val$vardes ) / sumval.ad_type.dfbanco.val$desktop * 100 )
sumval.ad_type.dfbanco.val          <- data.frame( cbind( sumval.ad_type.dfbanco.val , mobile  = with( dfbanco , tapply( valuation , list( month_yr , device  ) , sum ) )[,2] ) )
sumval.ad_type.dfbanco.val$varmob   <- c( NA , head( sumval.ad_type.dfbanco.val$mobile  , -1 ) )
sumval.ad_type.dfbanco.val$varmob   <- ( ( sumval.ad_type.dfbanco.val$mobile  - sumval.ad_type.dfbanco.val$varmob ) / sumval.ad_type.dfbanco.val$mobile  * 100 )
kable(       sumval.ad_type.dfbanco.val        ,
      format.args = list(decimal.mark = ',', big.mark = ".") , digits = 2 ,
      col.names = c( "Display" , "Variación" , "Video" , "Variación" , "Desktop" , "Variación" , "Mobile" , "Variación" ) ,
      caption = "Evolución mensual de valorizaciones según tipo de publicidad y dispositivo." )

#'

#' \newpage

#'

#+ chunkmsg0034, messages=FALSE, echo=FALSE
arripc0008 <- setNames( sumval.ad_type.dfbanco.ipc[,1] , rownames( sumval.ad_type.dfbanco.ipc ) )
arrimp0008 <- setNames( sumval.ad_type.dfbanco.imp[,1] , rownames( sumval.ad_type.dfbanco.imp ) )
arrval0008 <- setNames( sumval.ad_type.dfbanco.val[,1] , rownames( sumval.ad_type.dfbanco.val ) )
trripc0008 = "Impactos en display\nmensuales totales de Banco Estado"
trrimp0008 = "Impresiones en display\nmensuales totales de Banco Estado"
trrval0008 = "Valoraciones en display\nmensuales totales de Banco Estado"
# png(filename="./pic/pngbp0004.png", type="cairo", units="in", width=12, height=4, pointsize=12, res=96)
pdf("./pic/pdf0008.pdf", width=18, height=6)
layout( matrix( c( 1,1,2,2,3,3,1,1,2,2,3,3 ) , nrow = 2 , ncol = 6 , byrow = TRUE ) )
par( mai = c( 0,0.3,0,0 ) + 0.5 ) ; barplot( arripc0008 , main = trripc0008 , col = greenseq , ylim = c( 0 , 3 *10^6 ) , cex.names = 1.0 , yaxt = "n" ) ; axis( 2 , las = 1 , at = axTicks( 2 ) , labels = sprintf( "%2.2E", axTicks( 2 ) ) )
par( mai = c( 0,0.3,0,0 ) + 0.5 ) ; barplot( arrimp0008 , main = trrimp0008 , col = greenseq , ylim = c( 0 , 50*10^6 ) , cex.names = 1.0 , yaxt = "n" ) ; axis( 2 , las = 1 , at = axTicks( 2 ) , labels = sprintf( "%2.2E", axTicks( 2 ) ) )
par( mai = c( 0,0.3,0,0 ) + 0.5 ) ; barplot( arrval0008 , main = trrval0008 , col = greenseq , ylim = c( 0 , 20*10^6 ) , cex.names = 1.0 , yaxt = "n" ) ; axis( 2 , las = 1 , at = axTicks( 2 ) , labels = sprintf( "%2.2E", axTicks( 2 ) ) )
suppressMessages( suppressWarnings( dev.off() ) )

#'

#' \begin{figure}[h]
#' \caption{Gráfico de barras de display mensuales de impacto, impresiones y valorizaciones.}
#' \vspace{0.5cm}
#' \includegraphics{./pic/pdf0008.pdf}
#' \end{figure}

#'

#+ chunkmsg0035, messages=FALSE, echo=FALSE
arripc0009 <- setNames( sumval.ad_type.dfbanco.ipc[,2] , rownames( sumval.ad_type.dfbanco.ipc ) )
arrimp0009 <- setNames( sumval.ad_type.dfbanco.imp[,2] , rownames( sumval.ad_type.dfbanco.imp ) )
arrval0009 <- setNames( sumval.ad_type.dfbanco.val[,2] , rownames( sumval.ad_type.dfbanco.val ) )
trripc0009 = "Impactos en display\nvariaciones mensuales de Banco Estado"
trrimp0009 = "Impresiones en display\nvariaciones mensuales de Banco Estado"
trrval0009 = "Valoraciones en display\nvariaciones mensuales de Banco Estado"
# png(filename="./pic/pngbp0004.png", type="cairo", units="in", width=12, height=4, pointsize=12, res=96)
pdf("./pic/pdf0009.pdf", width=18, height=6)
layout( matrix( c( 1,1,2,2,3,3,1,1,2,2,3,3 ) , nrow = 2 , ncol = 6 , byrow = TRUE ) )
par( mai = c( 0,0.3,0,0 ) + 0.5 ) ; barplot( arripc0009 , main = trripc0009 , col = greenseq , ylim = c( -1.25*10^3 , 250 ) , cex.names = 1.0 , yaxt = "n" ) ; axis( 2 , las = 1 , at = axTicks( 2 ) , labels = sprintf( "%2.2E", axTicks( 2 ) ) )
par( mai = c( 0,0.3,0,0 ) + 0.5 ) ; barplot( arrimp0009 , main = trrimp0009 , col = greenseq , ylim = c( -1.25*10^3 , 250 ) , cex.names = 1.0 , yaxt = "n" ) ; axis( 2 , las = 1 , at = axTicks( 2 ) , labels = sprintf( "%2.2E", axTicks( 2 ) ) )
par( mai = c( 0,0.3,0,0 ) + 0.5 ) ; barplot( arrval0009 , main = trrval0009 , col = greenseq , ylim = c( -1.25*10^3 , 250 ) , cex.names = 1.0 , yaxt = "n" ) ; axis( 2 , las = 1 , at = axTicks( 2 ) , labels = sprintf( "%2.2E", axTicks( 2 ) ) )
suppressMessages( suppressWarnings( dev.off() ) )

#'

#' \begin{figure}[h]
#' \caption{Gráfico de barras de display variaciones mensuales de impacto, impresiones y valorizaciones.}
#' \vspace{0.5cm}
#' \includegraphics{./pic/pdf0009.pdf}
#' \end{figure}

#'

#' - Los gráficos de barras anteriores y siguientes muestran el comportamiento mensual
#'   de las variables de interés separando por tipo de publicidad y dispositivo, tanto
#'   para los valores observados como sus variaciones porcentuales.
#' - Los gráficos sobre display muestran un patrón similar a los visto en las variables
#'   anteriormente. Se ve un aumento abrupto al comienzo del año el que tiende aparentemente
#'   a repetirse en Julio, lo que no se corrobora en ningún caso, porque ese mes está incompleto
#'   en la base de ejemplo. De todas formas, el comportamiento es similar.
#' - En los gráficos siguientes esto solamente se verifica para las variables muestreadas según
#'   desktop. Mientras que aquellas medidas según video y mobile, presentan un comportamiento
#'   que no se había visto hasta ahora.

#'

#' \newpage

#'

#+ chunkmsg0036, messages=FALSE, echo=FALSE
arripc0010 <- setNames( sumval.ad_type.dfbanco.ipc[,3] , rownames( sumval.ad_type.dfbanco.ipc ) )
arrimp0010 <- setNames( sumval.ad_type.dfbanco.imp[,3] , rownames( sumval.ad_type.dfbanco.imp ) )
arrval0010 <- setNames( sumval.ad_type.dfbanco.val[,3] , rownames( sumval.ad_type.dfbanco.val ) )
trripc0010 = "Impactos en video\nmensuales totales de Banco Estado"
trrimp0010 = "Impresiones en video\nmensuales totales de Banco Estado"
trrval0010 = "Valoraciones en video\nmensuales totales de Banco Estado"
# png(filename="./pic/pngbp0004.png", type="cairo", units="in", width=12, height=4, pointsize=12, res=96)
pdf("./pic/pdf0010.pdf", width=18, height=6)
layout( matrix( c( 1,1,2,2,3,3,1,1,2,2,3,3 ) , nrow = 2 , ncol = 6 , byrow = TRUE ) )
par( mai = c( 0,0.3,0,0 ) + 0.5 ) ; barplot( arripc0010 , main = trripc0010 , col = greenseq , ylim = c( 0 , 2 *10^6 ) , cex.names = 1.0 , yaxt = "n" ) ; axis( 2 , las = 1 , at = axTicks( 2 ) , labels = sprintf( "%2.2E", axTicks( 2 ) ) )
par( mai = c( 0,0.3,0,0 ) + 0.5 ) ; barplot( arrimp0010 , main = trrimp0010 , col = greenseq , ylim = c( 0 , 10*10^6 ) , cex.names = 1.0 , yaxt = "n" ) ; axis( 2 , las = 1 , at = axTicks( 2 ) , labels = sprintf( "%2.2E", axTicks( 2 ) ) )
par( mai = c( 0,0.3,0,0 ) + 0.5 ) ; barplot( arrval0010 , main = trrval0010 , col = greenseq , ylim = c( 0 , 30*10^6 ) , cex.names = 1.0 , yaxt = "n" ) ; axis( 2 , las = 1 , at = axTicks( 2 ) , labels = sprintf( "%2.2E", axTicks( 2 ) ) )
suppressMessages( suppressWarnings( dev.off() ) )

#'

#' \begin{figure}[h]
#' \caption{Gráfico de barras de video mensuales de impacto, impresiones y valorizaciones.}
#' \vspace{0.5cm}
#' \includegraphics{./pic/pdf0010.pdf}
#' \end{figure}

#'

#+ chunkmsg0037, messages=FALSE, echo=FALSE
arripc0011 <- setNames( sumval.ad_type.dfbanco.ipc[,4] , rownames( sumval.ad_type.dfbanco.ipc ) )
arrimp0011 <- setNames( sumval.ad_type.dfbanco.imp[,4] , rownames( sumval.ad_type.dfbanco.imp ) )
arrval0011 <- setNames( sumval.ad_type.dfbanco.val[,4] , rownames( sumval.ad_type.dfbanco.val ) )
trripc0011 = "Impactos en video\nvariaciones mensuales de Banco Estado"
trrimp0011 = "Impresiones en video\nvariaciones mensuales de Banco Estado"
trrval0011 = "Valoraciones en video\nvariaciones mensuales de Banco Estado"
# png(filename="./pic/pngbp0004.png", type="cairo", units="in", width=12, height=4, pointsize=12, res=96)
pdf("./pic/pdf0011.pdf", width=18, height=6)
layout( matrix( c( 1,1,2,2,3,3,1,1,2,2,3,3 ) , nrow = 2 , ncol = 6 , byrow = TRUE ) )
par( mai = c( 0,0.3,0,0 ) + 0.5 ) ; barplot( arripc0011 , main = trripc0011 , col = greenseq , ylim = c( -1.00*10^3 , 200 ) , cex.names = 1.0 , yaxt = "n" ) ; axis( 2 , las = 1 , at = axTicks( 2 ) , labels = sprintf( "%2.2E", axTicks( 2 ) ) )
par( mai = c( 0,0.3,0,0 ) + 0.5 ) ; barplot( arrimp0011 , main = trrimp0011 , col = greenseq , ylim = c( -1.00*10^3 , 200 ) , cex.names = 1.0 , yaxt = "n" ) ; axis( 2 , las = 1 , at = axTicks( 2 ) , labels = sprintf( "%2.2E", axTicks( 2 ) ) )
par( mai = c( 0,0.3,0,0 ) + 0.5 ) ; barplot( arrval0011 , main = trrval0011 , col = greenseq , ylim = c( -1.00*10^3 , 200 ) , cex.names = 1.0 , yaxt = "n" ) ; axis( 2 , las = 1 , at = axTicks( 2 ) , labels = sprintf( "%2.2E", axTicks( 2 ) ) )
suppressMessages( suppressWarnings( dev.off() ) )

#'

#' \begin{figure}[h]
#' \caption{Gráfico de barras de video variaciones mensuales de impacto, impresiones y valorizaciones.}
#' \vspace{0.5cm}
#' \includegraphics{./pic/pdf0011.pdf}
#' \end{figure}

#'

#' - La apertura por video muestra un comportamiento diferente en cuanto al muestreo, lo que se
#'   refleja en las estimaciones.
#' - Esto se acentúa más en la apertura según dispositivo mobile más adelante.

#'

#' \newpage

#'

#+ chunkmsg0038, messages=FALSE, echo=FALSE
arripc0012 <- setNames( sumval.ad_type.dfbanco.ipc[,5] , rownames( sumval.ad_type.dfbanco.ipc ) )
arrimp0012 <- setNames( sumval.ad_type.dfbanco.imp[,5] , rownames( sumval.ad_type.dfbanco.imp ) )
arrval0012 <- setNames( sumval.ad_type.dfbanco.val[,5] , rownames( sumval.ad_type.dfbanco.val ) )
trripc0012 = "Impactos en desktop\nmensuales totales de Banco Estado"
trrimp0012 = "Impresiones en desktop\nmensuales totales de Banco Estado"
trrval0012 = "Valoraciones en desktop\nmensuales totales de Banco Estado"
# png(filename="./pic/pngbp0004.png", type="cairo", units="in", width=12, height=4, pointsize=12, res=96)
pdf("./pic/pdf0012.pdf", width=18, height=6)
layout( matrix( c( 1,1,2,2,3,3,1,1,2,2,3,3 ) , nrow = 2 , ncol = 6 , byrow = TRUE ) )
par( mai = c( 0,0.3,0,0 ) + 0.5 ) ; barplot( arripc0012 , main = trripc0012 , col = greenseq , ylim = c( 0 , 3 *10^6 ) , cex.names = 1.0 , yaxt = "n" ) ; axis( 2 , las = 1 , at = axTicks( 2 ) , labels = sprintf( "%2.2E", axTicks( 2 ) ) )
par( mai = c( 0,0.3,0,0 ) + 0.5 ) ; barplot( arrimp0012 , main = trrimp0012 , col = greenseq , ylim = c( 0 , 50*10^6 ) , cex.names = 1.0 , yaxt = "n" ) ; axis( 2 , las = 1 , at = axTicks( 2 ) , labels = sprintf( "%2.2E", axTicks( 2 ) ) )
par( mai = c( 0,0.3,0,0 ) + 0.5 ) ; barplot( arrval0012 , main = trrval0012 , col = greenseq , ylim = c( 0 , 25*10^6 ) , cex.names = 1.0 , yaxt = "n" ) ; axis( 2 , las = 1 , at = axTicks( 2 ) , labels = sprintf( "%2.2E", axTicks( 2 ) ) )
suppressMessages( suppressWarnings( dev.off() ) )

#'

#' \begin{figure}[h]
#' \caption{Gráfico de barras de desktop mensuales de impacto, impresiones y valorizaciones.}
#' \vspace{0.5cm}
#' \includegraphics{./pic/pdf0012.pdf}
#' \end{figure}

#'

#+ chunkmsg0039, messages=FALSE, echo=FALSE
arripc0013 <- setNames( sumval.ad_type.dfbanco.ipc[,6] , rownames( sumval.ad_type.dfbanco.ipc ) )
arrimp0013 <- setNames( sumval.ad_type.dfbanco.imp[,6] , rownames( sumval.ad_type.dfbanco.imp ) )
arrval0013 <- setNames( sumval.ad_type.dfbanco.val[,6] , rownames( sumval.ad_type.dfbanco.val ) )
trripc0013 = "Impactos en desktop\nvariaciones mensuales de Banco Estado"
trrimp0013 = "Impresiones en desktop\nvariaciones mensuales de Banco Estado"
trrval0013 = "Valoraciones en desktop\nvariaciones mensuales de Banco Estado"
# png(filename="./pic/pngbp0004.png", type="cairo", units="in", width=12, height=4, pointsize=12, res=96)
pdf("./pic/pdf0013.pdf", width=18, height=6)
layout( matrix( c( 1,1,2,2,3,3,1,1,2,2,3,3 ) , nrow = 2 , ncol = 6 , byrow = TRUE ) )
par( mai = c( 0,0.3,0,0 ) + 0.5 ) ; barplot( arripc0013 , main = trripc0013 , col = greenseq , ylim = c( -1.00*10^3 , 200 ) , cex.names = 1.0 , yaxt = "n" ) ; axis( 2 , las = 1 , at = axTicks( 2 ) , labels = sprintf( "%2.2E", axTicks( 2 ) ) )
par( mai = c( 0,0.3,0,0 ) + 0.5 ) ; barplot( arrimp0013 , main = trrimp0013 , col = greenseq , ylim = c( -1.25*10^3 , 200 ) , cex.names = 1.0 , yaxt = "n" ) ; axis( 2 , las = 1 , at = axTicks( 2 ) , labels = sprintf( "%2.2E", axTicks( 2 ) ) )
par( mai = c( 0,0.3,0,0 ) + 0.5 ) ; barplot( arrval0013 , main = trrval0013 , col = greenseq , ylim = c( -2.50*10^3 , 200 ) , cex.names = 1.0 , yaxt = "n" ) ; axis( 2 , las = 1 , at = axTicks( 2 ) , labels = sprintf( "%2.2E", axTicks( 2 ) ) )
suppressMessages( suppressWarnings( dev.off() ) )

#'

#' \begin{figure}[h]
#' \caption{Gráfico de barras de desktop variaciones mensuales de impacto, impresiones y valorizaciones.}
#' \vspace{0.5cm}
#' \includegraphics{./pic/pdf0013.pdf}
#' \end{figure}

#'

#' - La apertura según tipo de dispositivo desktop es más parecida al comportamiento de las
#'   variables originalmente muestreadas y valorizadas.

#'

#' \newpage

#'

#+ chunkmsg0040, messages=FALSE, echo=FALSE
arripc0014 <- setNames( sumval.ad_type.dfbanco.ipc[,7] , rownames( sumval.ad_type.dfbanco.ipc ) )
arrimp0014 <- setNames( sumval.ad_type.dfbanco.imp[,7] , rownames( sumval.ad_type.dfbanco.imp ) )
arrval0014 <- setNames( sumval.ad_type.dfbanco.val[,7] , rownames( sumval.ad_type.dfbanco.val ) )
trripc0014 = "Impactos en mobile\nmensuales totales de Banco Estado"
trrimp0014 = "Impresiones en mobile\nmensuales totales de Banco Estado"
trrval0014 = "Valoraciones en mobile\nmensuales totales de Banco Estado"
# png(filename="./pic/pngbp0004.png", type="cairo", units="in", width=12, height=4, pointsize=12, res=96)
pdf("./pic/pdf0014.pdf", width=18, height=6)
layout( matrix( c( 1,1,2,2,3,3,1,1,2,2,3,3 ) , nrow = 2 , ncol = 6 , byrow = TRUE ) )
par( mai = c( 0,0.3,0,0 ) + 0.5 ) ; barplot( arripc0014 , main = trripc0014 , col = greenseq , ylim = c( 0 , 5 *10^6 ) , cex.names = 1.0 , yaxt = "n" ) ; axis( 2 , las = 1 , at = axTicks( 2 ) , labels = sprintf( "%2.2E", axTicks( 2 ) ) )
par( mai = c( 0,0.3,0,0 ) + 0.5 ) ; barplot( arrimp0014 , main = trrimp0014 , col = greenseq , ylim = c( 0 , 5 *10^6 ) , cex.names = 1.0 , yaxt = "n" ) ; axis( 2 , las = 1 , at = axTicks( 2 ) , labels = sprintf( "%2.2E", axTicks( 2 ) ) )
par( mai = c( 0,0.3,0,0 ) + 0.5 ) ; barplot( arrval0014 , main = trrval0014 , col = greenseq , ylim = c( 0 , 5 *10^6 ) , cex.names = 1.0 , yaxt = "n" ) ; axis( 2 , las = 1 , at = axTicks( 2 ) , labels = sprintf( "%2.2E", axTicks( 2 ) ) )
suppressMessages( suppressWarnings( dev.off() ) )

#'

#' \begin{figure}[h]
#' \caption{Gráfico de barras de mobile mensuales de impacto, impresiones y valorizaciones.}
#' \vspace{0.5cm}
#' \includegraphics{./pic/pdf0014.pdf}
#' \end{figure}

#'

#+ chunkmsg0041, messages=FALSE, echo=FALSE
arripc0015 <- setNames( sumval.ad_type.dfbanco.ipc[,8] , rownames( sumval.ad_type.dfbanco.ipc ) )
arrimp0015 <- setNames( sumval.ad_type.dfbanco.imp[,8] , rownames( sumval.ad_type.dfbanco.imp ) )
arrval0015 <- setNames( sumval.ad_type.dfbanco.val[,8] , rownames( sumval.ad_type.dfbanco.val ) )
trripc0015 = "Impactos en mobile\nvariaciones mensuales de Banco Estado"
trrimp0015 = "Impresiones en mobile\nvariaciones mensuales de Banco Estado"
trrval0015 = "Valoraciones en mobile\nvariaciones mensuales de Banco Estado"
# png(filename="./pic/pngbp0004.png", type="cairo", units="in", width=12, height=4, pointsize=12, res=96)
pdf("./pic/pdf0015.pdf", width=18, height=6)
layout( matrix( c( 1,1,2,2,3,3,1,1,2,2,3,3 ) , nrow = 2 , ncol = 6 , byrow = TRUE ) )
par( mai = c( 0,0.3,0,0 ) + 0.5 ) ; barplot( arripc0015 , main = trripc0015 , col = greenseq , ylim = c( -1.25*10^4 , 200 ) , cex.names = 1.0 , yaxt = "n" ) ; axis( 2 , las = 1 , at = axTicks( 2 ) , labels = sprintf( "%2.2E", axTicks( 2 ) ) )
par( mai = c( 0,0.3,0,0 ) + 0.5 ) ; barplot( arrimp0015 , main = trrimp0015 , col = greenseq , ylim = c( -8.25*10^3 , 200 ) , cex.names = 1.0 , yaxt = "n" ) ; axis( 2 , las = 1 , at = axTicks( 2 ) , labels = sprintf( "%2.2E", axTicks( 2 ) ) )
par( mai = c( 0,0.3,0,0 ) + 0.5 ) ; barplot( arrval0015 , main = trrval0015 , col = greenseq , ylim = c( -6.50*10^3 , 200 ) , cex.names = 1.0 , yaxt = "n" ) ; axis( 2 , las = 1 , at = axTicks( 2 ) , labels = sprintf( "%2.2E", axTicks( 2 ) ) )
suppressMessages( suppressWarnings( dev.off() ) )

#'

#' \begin{figure}[h]
#' \caption{Gráfico de barras de mobile variaciones mensuales de impacto, impresiones y valorizaciones.}
#' \vspace{0.5cm}
#' \includegraphics{./pic/pdf0015.pdf}
#' \end{figure}

#'

#' - La apertura según dispositivo mobile es la más errática en relación con las demás estimaciones.
#' - Se ve estimaciones abruptas, localizadas y con meses faltantes. Esto se refleja en variaciones
#'   porcentuales aún más erráticas y acentuadas que lo visto anteriormente.
#'

#'

#' \newpage

#'

#'

#'

#'

#'

#' \adjustpagedim{\classpagewidth}{\classpageheight}

#'

#' \newpage

#'

#'# Datos de la industria.

#'

#'## Variación de inversiones mensuales de la Industria según empresa.

#'

#+ chunkmsg0042, messages=FALSE, echo=FALSE
sumval.brand.dfmarkt <- aggregate(valuation ~ brand + month_yr , data = dfmarkt , sum ) %>% spread( month_yr , valuation )
sumval.brand.dfmarkt[,4] <- NULL
sumval.brand.dfmarkt$tot <- rowSums( sumval.brand.dfmarkt[,2:3] , na.rm = T , dims = 1 )
sumval.brand.dfmarkt$var <- ( ( sumval.brand.dfmarkt[,3] - sumval.brand.dfmarkt[,2] ) / sumval.brand.dfmarkt[,3] * 100 )
sumval.brand.dfmarkt <- sumval.brand.dfmarkt[ order( sumval.brand.dfmarkt[,4] , decreasing = T ) , ]
kable( head( sumval.brand.dfmarkt , 40 ) , format.args = list(decimal.mark = ',', big.mark = ".") , digits = 2 ,
      col.names = c( "Empresa" , colnames( sumval.brand.dfmarkt )[2:3] , "Total" , "Variación" ) ,
      caption = "Variación porcentual mensual de inversión según empresa." )

#'

#'## Contabilizar outliers.

#'

#+ chunkmsg0043, messages=FALSE, echo=FALSE
dfmarkt_valuation_outliers <- which( dfmarkt$valuation >= ( mean( dfmarkt$valuation ) + 3 * sd( dfmarkt$valuation ) ) )
length( dfmarkt_valuation_outliers )

#'

#' \adjustpagedim{420mm}{614mm}

#'

#' \newpage

#'

#'## Variación de inversiones mensuales de la Industria según industria.

#'

#+ chunkmsg0044, messages=FALSE, echo=FALSE
sumval.industry.dfmarkt <- aggregate( valuation ~ industry + month_yr , data = dfmarkt , sum ) %>% spread( month_yr , valuation )
sumval.industry.dfmarkt[,4] <- NULL
sumval.industry.dfmarkt$tot <- rowSums( sumval.industry.dfmarkt[,2:3] , na.rm = T , dims = 1 )
sumval.industry.dfmarkt$var <- ( ( sumval.industry.dfmarkt[,3] - sumval.industry.dfmarkt[,2] ) / sumval.industry.dfmarkt[,3] * 100 )
sumval.industry.dfmarkt <- sumval.industry.dfmarkt[ order( sumval.industry.dfmarkt[,3] , decreasing = T ) , ]
kable( head( sumval.industry.dfmarkt , 40 ) , format.args = list(decimal.mark = ',', big.mark = ".") , digits = 2 ,
      col.names = c( "Industria" , colnames( sumval.industry.dfmarkt )[2:3] , "Total" , "Variación" ) ,
      caption = "Variación porcentual mensual de inversión según industria." )

#'

#+ chunkmsg0045, messages=FALSE, echo=FALSE
dbDisconnect( con )

#'

#' \adjustpagedim{\classpagewidth}{\classpageheight}

#'

#' \newpage

#'

#'# Recomendaciones.

#'

#' - Sobre la identificación de variables relevantes hay que señalar varias cosas.
#'   Las aperturas, niveles o categorías en cada variable son de mucha importancia,
#'   por ejemplo, el sitio web desde donde los robots contabilizan las impresiones.
#'   Siendo una característica que puede abarcar varias empresas incluso industrias.
#' - Si bien es cierto, las variables analizadas están relacionadas en el proceso de
#'   estimación, es necesario su análisis para identificar dónde hay mayor incertidumbre
#'   e inconsistencias, así como también verificar los supuestos, por ejemplo, de
#'   distribución que hay detrás, en caso que se desee modelizar.
#' - Adicionalmente, cabe preguntar algo importante sobre las variables, o unidad de análisis
#'   mas bien. Existe un unidad de análisis identificable en el tiempo, es decir, una sola
#'   pieza publicitaria claramente identificable a modo de usarla como unidad de análisis con
#'   fines de modelización temporal o según otra apertura relevante. Si esto aplica, que creo
#'   que efectivamente sí aplica, sería ideal incorporar dentro del análisis un identificador
#'   no ambiguo para poder hacer modelos de machine learning, que incluyan esquema temporal
#'   especialmente estacionalidad.
#' - El segundo elemento importante, además de una posible estructura temporal, es sobre el tipo
#'   de muestreo considerando que hay variables muy sesgadas y cargadas a las colas de la distribución.
#'   La sugerencia es tratar de ajustar las muestras a una distribución log-normal, weibull
#'   o similar, en conjunto con analizar si efectivamente los outliers que se ven en las inspecciones
#'   hechas son realmente inherentes y pertenecen a la muestra en cuestión o se trata de otro
#'   fenómeno, que amerite corrección de inconsistencia, revisión de la metodología u otro.
#' - Es necesario conocer los gastos en inversión reales, que seguramente están a mano, con lo
#'   cual se puede indentificar en cada caso, si el proceso está efectivamente sub estimando
#'   las inversiones reales o sobre estimándolas, puesto que una estrategia sería diferente de la
#'   según corresponda.
#' - La posibilidad de despejar el CPM desde la variable valorización es una opción interesante, siempre
#'   que se vea que las impresiones incorporan una gran variabilidad en las estimaciones. Esto permitiría
#'   un mejor análisis además de definir con esa variable una matriz de beneficio para un método de machine
#'   learning de tipo predictivo. El definir como objetivo usar un modelo que minimice costos de
#'   impresión nos acercamos a la forma en que la empresa toma la decisión al momento de contratar las
#'   publicidades.
#' - El enfoque de mejora continua puede ser abordado desde mi punto de vista con diseño de flujos
#'   de datos usando un workflow system y herramientas de tipo Unix tools, Python o similares. Lo que en
#'   mi experiencia resulta rápido para mejorar la calidad de los datos.
#'
#'
#'

#'

#' \newpage

#'

#'# Referencias.

#'

#' - [Which statistics are more precise? Alexa.com or similarweb.com? Somebody have insights?](https://www.quora.com/Which-statistics-are-more-precise-Alexa-com-or-similarweb-com-Somebody-have-insights)
#' - [Real-time Bidding for Online Advertising: Measurement and Analysis](https://arxiv.org/pdf/1306.6542.pdf)
#' - [Deciphering the internet advertising puzzle](http://faculty.washington.edu/sandeep/d/mmgtarticle.pdf)
#' - [Wikipedia: Competitve Intelligence](https://en.wikipedia.org/wiki/Competitive_intelligence)
#' - [Which web traffic measurement service is the most accurate? Compete, Quantcast, Alexa, Comscore, etc?](https://www.quora.com/Which-web-traffic-measurement-service-is-the-most-accurate-Compete-Quantcast-Alexa-Comscore-etc)

#'

