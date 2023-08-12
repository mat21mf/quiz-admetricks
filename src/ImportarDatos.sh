
  a01="${1}"
  a02="${2}"
  a03="${3}"

  CrearInsercion () {

  #### CREAR TIPO DATOS {{{
  cat ./csv/banco.csv | head -n 1 | sed -r 's/-_-/\n/g' | dos2unix | sed -r 's/ /_/g;s/\(//g;s/\)//g' | sed -r 's/(.*)/\L\1 varchar(300)/' | \
        sed -r 's/^/  /' | \
        sed -r '2,$s/^  /, /' | \
        sed -r '$s/$/ ) ;/' | \
        sed -r 's/date/dates/' | \
        sed -r 's/impact varchar\(300\)/impact int/' | \
        sed -r 's/impressions varchar\(300\)/impressions int/' | \
        sed -r 's/valuation varchar\(300\)/valuation int/' | \
        sed -r 's/web_report varchar\(300\)/web_report varchar(800)/' | \
        sed '1 i\\CREATE TABLE IF NOT EXISTS tb_banco (' | \
        sed '1 i\\DROP   TABLE IF     EXISTS tb_banco ;' | \
        sed '$ a\\TRUNCATE TABLE tb_banco ;' > \
        ./src/crear_tabla_banco.sql
  cat ./csv/markt.csv | head -n 1 | sed -r 's/-_-/\n/g' | dos2unix | sed -r 's/ /_/g;s/\(//g;s/\)//g' | sed -r 's/(.*)/\L\1 varchar(300)/' | \
        sed -r 's/^/  /' | \
        sed -r '2,$s/^  /, /' | \
        sed -r '$s/$/ ) ;/' | \
        sed -r 's/date/dates/' | \
        sed -r 's/impact varchar\(300\)/impact int/' | \
        sed -r 's/impressions varchar\(300\)/impressions int/' | \
        sed -r 's/valuation varchar\(300\)/valuation int/' | \
        sed -r 's/web_report varchar\(300\)/web_report varchar(800)/' | \
        sed '1 i\\CREATE TABLE IF NOT EXISTS tb_markt (' | \
        sed '1 i\\DROP   TABLE IF     EXISTS tb_markt ;' | \
        sed '$ a\\TRUNCATE TABLE tb_markt ;' > \
        ./src/crear_tabla_markt.sql
  #### }}}

  #### CREAR INSERCION DE DATOS {{{
  cat ./csv/banco.csv | gawk -F'-_-' 'NR>1 {print \
         "\047"$1"\047"  "," \
         "\047"$2"\047"  "," \
         "\047"$3"\047"  "," \
         "\047"$4"\047"  "," \
         "\047"$5"\047"  "," \
         "\047"$6"\047"  "," \
         "\047"$7"\047"  "," \
         "\047"$8"\047"  "," \
         "\047"$9"\047"  "," \
         "\047"$10"\047" "," \
         "\047"$11"\047" "," \
         "\047"$12"\047" "," \
         "\047"$13"\047" "," \
         "\047"$14"\047" "," \
         "\047"$15"\047" "," \
               $16       "," \
               $17       "," \
               $18       "," \
         "\047"$19"\047"     \
         }' | \
        sed -r 's/^/  (/' | \
        sed -r 's/$/)/' | \
        sed -r '2,$s/^  /, /' | \
        sed -r '$s/$/ ;/' | \
        sed '1 i\\INSERT INTO tb_banco VALUES' > \
        ./src/insertar_banco.sql
  cat ./csv/markt.csv | gawk -F'-_-' 'NR>1 {print \
         "\047"$1"\047"  "," \
         "\047"$2"\047"  "," \
         "\047"$3"\047"  "," \
         "\047"$4"\047"  "," \
         "\047"$5"\047"  "," \
         "\047"$6"\047"  "," \
         "\047"$7"\047"  "," \
         "\047"$8"\047"  "," \
         "\047"$9"\047"  "," \
         "\047"$10"\047" "," \
         "\047"$11"\047" "," \
         "\047"$12"\047" "," \
         "\047"$13"\047" "," \
         "\047"$14"\047" "," \
         "\047"$15"\047" "," \
         "\047"$16"\047" "," \
         "\047"$17"\047" "," \
               $18       "," \
               $19       "," \
               $20           \
         }' | \
        sed -r 's/^/  (/' | \
        sed -r 's/$/)/' | \
        sed -r '2,$s/^  /, /' | \
        sed -r '$s/$/ ;/' | \
        sed '1 i\\INSERT INTO tb_markt VALUES' > \
        ./src/insertar_markt.sql
  #### }}}

  }

  CrearInsercion "${a01}" "${a02}" "${a03}"
