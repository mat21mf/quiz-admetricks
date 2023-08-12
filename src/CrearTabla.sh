
  a01="${1}"
  a02="${2}"
  a03="${3}"

  CrearTabla () {

  #### CREAR TIPO DATOS {{{
  if [[ "${3}" == 1 ]] ; then
  cat "${1}" | head -n 1 | sed -r 's/-_-/\n/g' | \
        dos2unix | \
        sed -r 's/ /_/g;s/\(//g;s/\)//g' | \
        sed -r 's/(.*)/\L\1 varchar(300)/' | \
        sed -r 's/^/  /' | \
        sed -r '2,$s/^  /, /' | \
        sed -r '$s/$/ ) ;/' | \
        sed -r 's/date/dates/' | \
        sed -r 's/date varchar\(300\)/date varchar(10)/' | \
        sed -r 's/industry varchar\(300\)/industry varchar(17)/' | \
        sed -r 's/brand varchar\(300\)/brand varchar(12)/' | \
        sed -r 's/campaign_name varchar\(300\)/campaign_name varchar(57)/' | \
        sed -r 's/campaign_landing_page varchar\(300\)/campaign_landing_page varchar(89)/' | \
        sed -r 's/website varchar\(300\)/website varchar(26)/' | \
        sed -r 's/website_sections varchar\(300\)/website_sections varchar(270)/' | \
        sed -r 's/ad_type varchar\(300\)/ad_type varchar(7)/' | \
        sed -r 's/ad_size varchar\(300\)/ad_size varchar(87)/' | \
        sed -r 's/duration_video varchar\(300\)/duration_video varchar(8)/' | \
        sed -r 's/skip_video varchar\(300\)/skip_video varchar(17)/' | \
        sed -r 's/country varchar\(300\)/country varchar(5)/' | \
        sed -r 's/device varchar\(300\)/device varchar(7)/' | \
        sed -r 's/hosted_by varchar\(300\)/hosted_by varchar(41)/' | \
        sed -r 's/sold_by varchar\(300\)/sold_by varchar(14)/' | \
        sed -r 's/web_report varchar\(300\)/web_report varchar(474)/' | \
        sed -r 's/impact varchar\(300\)/impact int/' | \
        sed -r 's/impressions varchar\(300\)/impressions int/' | \
        sed -r 's/valuation varchar\(300\)/valuation int/' | \
        sed -r 's/web_report varchar\(300\)/web_report varchar(800)/' | \
        sed '1 i\\CREATE TABLE IF NOT EXISTS tb_banco (' | \
        sed '1 i\\DROP   TABLE IF     EXISTS tb_banco ;' | \
        sed '$ a\\TRUNCATE TABLE tb_banco ;' > \
        "${2}"
  fi
  if [[ "${3}" == 2 ]] ; then
  cat "${1}" | head -n 1 | sed -r 's/-_-/\n/g' | \
        dos2unix | \
        sed -r 's/ /_/g;s/\(//g;s/\)//g' | \
        sed -r 's/(.*)/\L\1 varchar(300)/' | \
        sed -r 's/^/  /' | \
        sed -r '2,$s/^  /, /' | \
        sed -r '$s/$/ ) ;/' | \
        sed -r 's/date/dates/' | \
        sed -r 's/date varchar\(300\)/date varchar(10)/' | \
        sed -r 's/industry varchar\(300\)/industry varchar(89)/' | \
        sed -r 's/brand varchar\(300\)/brand varchar(83)/' | \
        sed -r 's/campaign_name varchar\(300\)/campaign_name varchar(839)/' | \
        sed -r 's/campaign_landing_page varchar\(300\)/campaign_landing_page varchar(464)/' | \
        sed -r 's/website varchar\(300\)/website varchar(29)/' | \
        sed -r 's/website_section varchar\(300\)/website_section varchar(591)/' | \
        sed -r 's/ad_type varchar\(300\)/ad_type varchar(7)/' | \
        sed -r 's/ad_size varchar\(300\)/ad_size varchar(145)/' | \
        sed -r 's/duration_video varchar\(300\)/duration_video varchar(17)/' | \
        sed -r 's/skip_video varchar\(300\)/skip_video varchar(17)/' | \
        sed -r 's/advertisement varchar\(300\)/advertisement varchar(71)/' | \
        sed -r 's/screenshot varchar\(300\)/screenshot varchar(78)/' | \
        sed -r 's/country varchar\(300\)/country varchar(5)/' | \
        sed -r 's/device varchar\(300\)/device varchar(7)/' | \
        sed -r 's/hosted_by varchar\(300\)/hosted_by varchar(59)/' | \
        sed -r 's/sold_by_beta varchar\(300\)/sold_by_beta varchar(37)/' | \
        sed -r 's/impact varchar\(300\)/impact int/' | \
        sed -r 's/impressions varchar\(300\)/impressions int/' | \
        sed -r 's/valuation varchar\(300\)/valuation int/' | \
        sed -r 's/web_report varchar\(300\)/web_report varchar(800)/' | \
        sed '1 i\\CREATE TABLE IF NOT EXISTS tb_markt (' | \
        sed '1 i\\DROP   TABLE IF     EXISTS tb_markt ;' | \
        sed '$ a\\TRUNCATE TABLE tb_markt ;' > \
        "${2}"
  fi
  #### }}}

  }

  CrearTabla "${a01}" "${a02}" "${a03}"
