
#  a01="${1}"

#  Comprimir () {

#    flenom=$(echo "${1}" | cut)
#    fleext=$()

#    if [[ -f "${1}" ]] ; then pigz -4 -K -- "${1}" ; else pigz -4 -d -- "${1}.zip" ; fi

#  }

#  Comprimir "${a01}"

  7za a -spf -r -t7z ./Prueba_tecnica_Matias_Rebolledo.7z @./src/Lista.txt
