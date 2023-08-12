# bash ./src/SepararDias.sh ./csv/markt.csv 1 | parallel
# bash ./src/SepararDias.sh ./csv/markt.csv 2 | parallel
  psql -U postgres -h localhost -d dbadmetricks -f ./sql/crear_tabla_banco.sql
  psql -U postgres -h localhost -d dbadmetricks -f ./sql/crear_tabla_markt.sql
  psql -U postgres -h localhost -d dbadmetricks -f ./sql/insertar_banco.sql
# bash ./src/SepararDias.sh ./csv/markt.csv 3 | head -n 4 | bash
  bash ./src/SepararDias.sh ./csv/markt.csv 4 | bash
