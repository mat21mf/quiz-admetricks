#### SEPARAR {{{
  gawk -F'-_-' 'NR==1 {print} NR>1 && substr( $1 , 6 , 2 ) ~ /05/ {print}' ./csv/markt.csv > ./csv/markt_2017_05.csv
  gawk -F'-_-' 'NR==1 {print} NR>1 && substr( $1 , 6 , 2 ) ~ /06/ {print}' ./csv/markt.csv > ./csv/markt_2017_06.csv
  gawk -F'-_-' 'NR==1 {print} NR>1 && substr( $1 , 6 , 2 ) ~ /07/ {print}' ./csv/markt.csv > ./csv/markt_2017_07.csv
#### }}}

#### VERIFICAR {{{
  gawk -F'-_-' 'NR>1 {print $1}' ./csv/markt_2017_05.csv | cut -d '-' -f 2 | sort | uniq -c
  gawk -F'-_-' 'NR>1 {print $1}' ./csv/markt_2017_06.csv | cut -d '-' -f 2 | sort | uniq -c
  gawk -F'-_-' 'NR>1 {print $1}' ./csv/markt_2017_07.csv | cut -d '-' -f 2 | sort | uniq -c
  wc -l ./csv/markt_2017_05.csv
  wc -l ./csv/markt_2017_06.csv
  wc -l ./csv/markt_2017_07.csv
#### }}}
