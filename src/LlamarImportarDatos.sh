  bash ./src/CrearTabla.sh    ./csv/banco.csv ./sql/crear_tabla_banco.sql 1
  bash ./src/CrearTabla.sh    ./csv/markt.csv ./sql/crear_tabla_markt.sql 2
  bash ./src/InsertarTabla.sh ./csv/banco.csv ./sql/insertar_banco.sql    1
# bash ./src/InsertarTabla.sh ./csv/markt.csv ./sql/insertar_markt.sql    2
# bash ./src/InsertarTabla.sh ./csv/markt_2017_05.csv ./sql/insertar_markt_2017_05.sql 2
# bash ./src/InsertarTabla.sh ./csv/markt_2017_06.csv ./sql/insertar_markt_2017_06.sql 2
# bash ./src/InsertarTabla.sh ./csv/markt_2017_07.csv ./sql/insertar_markt_2017_07.sql 2
