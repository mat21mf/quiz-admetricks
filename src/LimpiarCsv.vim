  sil g//s///g | noh
  2,$s/\n\(\(^[0-9]\{4}\)\@!.*\)/\1/
  sil g/'\('\)\@!/s//''/g | noh
 "sil g/\t\t\+/s// /g | noh
 "sil g/Ã¨/s//é/g | noh
  sil wqa
