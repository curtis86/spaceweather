####################################################
# MEASUREMENTS
# Prefix measurement functions with m_
####################################################


#######################################
# Returns ACE IMF magnetometer Bz
# reading.
# Unit: nT
#######################################
m_ace_magnetometer_bz () {
  local data_f="${data_d}/ace-magnetometer.txt"
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
  local data_f="${data_d}/ace-swepam.txt"
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
  local data_f="${data_d}/ace-swepam.txt"
  local data="$( grep -v ^# ${data_f} | grep '^[0-9]' | awk '$7 == 0 { print $8 }' | tail -n1 )"

  if [ -z "${data}" ]; then
    return 1
  else
    echo "${data}"
  fi
}

#######################################
# ETA for solar wind to reach Eaerth
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
# Returns Wing Kp Index
#######################################
m_wing_kp_index () {
  local data_f="${data_d}/wing-kp.txt"
  local data="$( grep -v ^# "${data_f}" | grep '^[0-9]' | awk '$5 == 0 { print $18 }' | tail -n1 )"

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
