#######################################
# Prints script usage/help
# Globals:
#  none
# Arguments:
#  none
# Returns:
#   Script usage
#######################################
usage() {

  echo "${t_bold}Usage:${t_normal} $( basename $0 ) <measurement> <options>"
  echo ""
  echo "${t_bold}Options: ${t_normal}"
  echo "--help     shows this usage info"
  echo "--verbose  prints verbose output"
  echo "--update   updates datasources and exits"
  echo ""
  echo "${t_bold}Supported measurements: ${t_normal}"
  echo ""
  list_measurements
  echo ""
}

setup_directories() {

  bp::test_access "${HOME_DIR}"
  [ ! -d "${DATA_DIR}" ] && mkdir "${DATA_DIR}"

}

#######################################
# Retrieves raw data files.
# Will use wget with -N option to only
# retrieve changed files.
# Globals:
#  none
# Arguments:
#  none
# Returns:
#   0 for success
#######################################
update_datasource() {

  local update_timeout=10

  set +u
  local datasource="$1"

  if [ -n "${datasource}" ]; then
    
    local datasources="${datasource}"
  else
    local datasources=( "http://services.swpc.noaa.gov/text/ace-magnetometer.txt" "http://services.swpc.noaa.gov/text/wing-kp.txt" "http://services.swpc.noaa.gov/text/ace-swepam.txt" "http://services.swpc.noaa.gov/products/solar-wind/mag-2-hour.json" "http://services.swpc.noaa.gov/products/solar-wind/plasma-2-hour.json" )
  fi
  
  set -u

  # Extra check to ensure data directory exists.
  bp::test_access "${DATA_DIR}"

  for datasource in "${datasources[@]}" ; do
    local get_data="$( cd ${DATA_DIR} ; wget --timeout=${update_timeout} -q -N "${datasource}" )"
    if [ $? -ne 0 ]; then
      bp::abrt "unable to retrieve datasource ${datasource}"
    fi
  done
}

#######################################
# Checks if a value is in an array
# http://stackoverflow.com/a/8574392
# Globals:
#  none
# Arguments:
#  arraay
# Returns:
#   0 for present value
#   1 for absent value
#######################################
containsElement () {

  local e
  for e in "${@:2}"; do [[ "$e" == "$1" ]] && return 0; done
  return 1
}


#######################################
# Returns ACE IMF magnetometer Bz
# reading.
# Unit: nT
#######################################
m_ace_magnetometer_bz () {

  local data_f="${DATA_DIR}/ace-magnetometer.txt"
  local data="$( grep -E -v "^#|^\:" "${data_f}" | tail -n1 | awk '$7 == 0 { print $10 }' )"

  if [ -z "${data}" ]; then
    return 1
  else
    echo "${data}"
  fi
}

#######################################
# Returns ACE solar wind speed
# Unit: Km/s
#######################################
m_ace_solar_wind_speed () {


  local data_f="${DATA_DIR}/ace-swepam.txt"
  local data="$( grep -v ^# "${data_f}" | grep '^[0-9]' | awk '$7 == 0 { print $9 }' | tail -n1 )"

  if [ -z "${data}" ]; then
    return 1
  else
    echo "${data}"
  fi
}

#######################################
# Returns ACE particle density
# Unit: p/cc
#######################################
m_ace_particle_density () {


  local data_f="${DATA_DIR}/ace-swepam.txt"
  local data="$( grep -v ^# ${data_f} | grep '^[0-9]' | awk '$7 == 0 { print $8 }' | tail -n1 )"

  if [ -z "${data}" ]; then
    return 1
  else
    echo "${data}"
  fi
}

#######################################
# ETA for ACE solar wind measurements to reach Earth
# Unit: minutes
#######################################
m_ace_solar_wind_eta () {

  local wind_speed=$( m_ace_solar_wind_speed ) || return 1
  local ace_distance_to_earth=1500000
  local data="$( echo "${ace_distance_to_earth} / ${wind_speed} / 60" | bc )"

  if [ -z "${data}" ]; then
    return 1
  else
    echo "${data}"
  fi
}

#######################################
# Returns Wing Kp Index (Current USAF)
#######################################
m_wing_kp_index () {

  local data_f="${DATA_DIR}/wing-kp.txt"
  local data="$( grep -v ^# "${data_f}" | grep '^[0-9]' | awk '$15 != -1 { print $15 }' | tail -n1 )"

  if [ -z "${data}" ]; then
    return 1
  else
    echo "${data}"
  fi
}

#######################################
# Returns Wing Kp Index 1-hour Forecast
#######################################
m_wing_kp_one_hour_forecast () {

  local data_f="${DATA_DIR}/wing-kp.txt"
  local data="$( grep -v ^# "${data_f}" | grep '^[0-9]' | awk '$9 != -1 { print $9 }' | tail -n1 )"

  if [ -z "${data}" ]; then
    return 1
  else
    echo "${data}"
  fi
}

#######################################
# Returns Wing Kp Index 4-hour Forecast
#######################################
m_wing_kp_four_hour_forecast () {

  local data_f="${DATA_DIR}/wing-kp.txt"
  local data="$( grep -v ^# "${data_f}" | grep '^[0-9]' | awk '$14 != -1 { print $14 }' | tail -n1 )"

  if [ -z "${data}" ]; then
    return 1
  else
    echo "${data}"
  fi
}

#######################################
# Returns DSCOVR IMF magnetometer Bz
# (south) reading.
# Unit: nT
#######################################
m_dscovr_magnetometer_bz()
{

  local data_f="${DATA_DIR}/mag-2-hour.json"

  # Long sed statements in place of jq for now (for compatability reasons)
  local data="$( cat "${data_f}" | tr '],' '\n' | sed 's/\[//g' | tail -8 | sed 's/"//g' | head -n4 | tail -n1 )"

  if [ -z "${data}" ]; then
    return 1
  else
    echo "${data}"
  fi
}


#######################################
# Returns DSCOVR IMF magnetometer Bt
# (total field) reading.
# Unit: nT
#######################################
m_dscovr_magnetometer_bt()
{

  local data_f="${DATA_DIR}/mag-2-hour.json"
  
  # Long sed statements in place of jq for now (for compatability reasons)
  local data="$( cat "${data_f}" | tr '],' '\n' | sed 's/\[//g' | tail -8 | sed 's/"//g' | tail -n2 | head -n1 )"

  if [ -z "${data}" ]; then
    return 1
  else
    echo "${data}"
  fi
}


#######################################
# ETA for ACE solar wind measurements to reach Earth
# Unit: minutes
#######################################
m_dscovr_plasma_speed()
{

  local data_f="${DATA_DIR}/plasma-2-hour.json"

  # Long sed statements in place of jq for now (for compatability reasons)
  local data="$( cat "${data_f}" | tr '],' '\n' | sed 's/\[//g' | sed 's/"//g' | tail -5 | head -n3 | tail -n1 )"

  if [ -z "${data}" ]; then
    return 1
  else
    echo "${data}"
  fi
}


#######################################
# Returns DSCOVR particle density
# Unit: p/cc
#######################################
m_dscovr_plasma_density()
{

  local data_f="${DATA_DIR}/plasma-2-hour.json"

  # Long sed statements in place of jq for now (for compatability reasons)
  local data="$( cat "${data_f}" | tr '],' '\n' | sed 's/\[//g' | sed 's/"//g' | tail -5 | head -n2 | tail -n1 )"

  if [ -z "${data}" ]; then
    return 1
  else
    echo "${data}"
  fi
}

#######################################
# ETA for DSCOVR solar wind measurements to reach Earth
# Unit: minutes
#######################################
m_dscovr_solar_wind_eta () {

  local wind_speed=$( m_dscovr_plasma_speed ) || return 1
  local dscovr_distance_to_earth=1500000
  local data="$( echo "${dscovr_distance_to_earth} / ${wind_speed} / 60" | bc )"

  if [ -z "${data}" ]; then
    return 1
  else
    echo "${data}"
  fi
}


#######################################
# Lists defined measurements
#######################################
list_measurements () {

  measurements_list=""

  if [ -z "${measurements_list}" ]; then
    local measurements_list="$( compgen -A function | grep '^m_' )"
    if [ -z "${measurements_list}" ]; then
      return 1
    else
      echo "${measurements_list}"
    fi
  else
    echo "${measurements_list}"
  fi
}