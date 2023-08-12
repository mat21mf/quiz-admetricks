
  # if [[ -f ../pdf/email.csv ]] ; then rm -rf ../pdf/email.csv ; fi
  # R --quiet -e ' load( "../pdf/email.Rdata" ) ;  ; write.table( file = "../pdf/email.csv" , email , sep = "|" , quote = F , row.names = F ) '

  # sed -r -i '1s/from/fromc/'     ../pdf/email.csv
  # sed -r -i '1s/number/numberc/' ../pdf/email.csv
  # gawk -i inplace -F'|' '{gsub( /\./ , "" , $12) ; print}' OFS='|' ../pdf/email.csv

  a01="${1}"

  Insertar () {

    flepat=$(echo "${1}" | cut -d '/' -f 1)
    flenam=$(echo "${1}" | cut -d '/' -f 2)
    flenom=$(echo "${flenam}" | cut -d '.' -f 1)
    fleext=$(echo "${flenam}" | cut -d '.' -f 2)
    flefoo="${flenom}CreateTable.sql"
    #  echo "${flepat}/${flefoo}"

    cat "${1}" | head -n 1 | sed -r 's/\|/\n/g' | sed -r 's/\.//g;s/ //g' | \
      sed -r 's/(.*)/    \L\1           int/' | \
      sed -r '2,$s/^  /, /' | \
      sed -r '$s/$/ ) ;/' | \
      sed -r 's/avggift           int/avggift         float/' | \
      sed -r 's/part           int/part       char(1)/' | \
      sed '1 i\\CREATE TABLE IF NOT EXISTS '"tb_${flenom}"' (' | \
      sed '$ a\\TRUNCATE TABLE '"tb_${flenom}"' ;'

    cat "${1}" | \
      sed -r '1d' | \
      sed -r 's/\"//g' | \
      gawk -F'|' '{print   \
             $1        "," \
             $2        "," \
             $3        "," \
             $4        "," \
             $5        "," \
             $6        "," \
             $7        "," \
             $8        "," \
             $9        "," \
             $10       "," \
             $11       "," \
             $12       "," \
             $13       "," \
             $14       "," \
             $15       "," \
             $16       "," \
             $17       "," \
             $18       "," \
             $19       "," \
             $20       "," \
             $21       "," \
             $22       "," \
       "\047"$23"\047"     \
      }' | \
      sed -r 's/^/  (/' | \
      sed -r 's/$/)/' | \
      sed -r '2,$s/^  /, /' | \
      sed -r '$s/$/ ;/' | \
      sed '1 i\\INSERT INTO '"tb_${flenom}"' VALUES' | \
      sed '$ a\\SELECT \* FROM '"tb_${flenom}"' ;'

  }

  Insertar "${a01}"

