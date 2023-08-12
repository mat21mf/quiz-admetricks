
  a01="${1}"
  a02="${2}"

  InsertarFrecuenciaDiaria () {

#### SEPARAR {{{
  if [[ "${2}" == 1 ]] ; then
    gawk -F'-_-' 'NR>1 {print FILENAME, $1, $1}' "${1}" | sort | uniq | sed -r 's/-/_/;s/-/_/' | \
    sed -r 's/(.*)\.(.*) (.*) (.*)/gawk -F'\''-_-'\'' '\''NR==1 {print} NR>1 \&\& \$1 \~ \/\4\/ {print}'\'' \1\.\2 > \1_\3\.\2/'
  fi
#### }}}

#### CREAR INSERCIONES {{{
  if [[ "${2}" == 2 ]] ; then
    gawk -F'-_-' 'NR>1 {print FILENAME, $1}' "${1}" | sort | uniq | sed -r 's/-/_/g' | \
    sed -r 's/(.*)\/(.*)\.(.*) (.*)/bash \.\/src\/InsertarTabla.sh \1\/\2_\4\.\3 \.\/sql\/insertar_\2_\4\.sql 2/'
  fi
#### }}}

#### VERIFICAR LONGITUD {{{
  if [[ "${2}" == 3 ]] ; then
    gawk -F'-_-' 'NR>1 {print FILENAME, $1}' "${1}" | sort | uniq | sed -r 's/-/_/g' | \
    sed -r 's/(.*)\.(.*) (.*)/gawk -F'\''-_-'\'' '\''length > m { m = length; a = NR } END { print a }'\'' \1_\3\.\2/'
  fi
#### }}}

#### EJECUTAR INSERCIONES {{{
  if [[ "${2}" == 4 ]] ; then
    gawk -F'-_-' 'NR>1 {print FILENAME, $1}' "${1}" | sort | uniq | sed -r 's/-/_/g' | \
    sed -r 's/(.*)\/(.*)\.(.*) (.*)/psql -U postgres -h localhost -d dbadmetricks -f \.\/sql\/insertar_\2_\4\.sql/'
  fi
#### }}}

  }

  InsertarFrecuenciaDiaria "${a01}" "${a02}"
