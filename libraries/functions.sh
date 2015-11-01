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
  msg "Usage: $( basename $0 ) <measurement> <options>"
  echo "Options: "
  echo "--help     shows this usage info"
  echo "--verbose  prints verbose output"
  echo "--update   updates datasources and exits"
  msg "Measurements: "
  list_measurements
}

#######################################
# Ensures directory exists and is
# writeable.
# Globals:
#  none
# Arguments:
#  none
# Returns:
#   0 for sucess
#######################################
check_directory_access() {
  local dirs=( $@ )
  local access_errors=0

  for dir in "${dirs[@]}" ; do
    [ ! -d "${dir}" ] && mkdir -p "${dir}"
    [ ! -w "${dir}" ] && ((access_errors++))
  done

  if [ $access_errors -ne 0 ]; then
    return 1
  fi
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
update_datasources() {
  local datasources=( "http://services.swpc.noaa.gov/text/ace-magnetometer.txt" "http://services.swpc.noaa.gov/text/wing-kp.txt" "http://services.swpc.noaa.gov/text/ace-swepam.txt" )
  local update_timeout=10

  vmsg "Updating datasources..." >&2

  # Extra check to ensure data directory exists.
  check_directory_access "${data_d}"

  for datasource in "${datasources[@]}" ; do
    local get_data="$( cd ${data_d} ; wget --timeout=${update_timeout} -q -N "${datasource}" )"
    if [ $? -ne 0 ]; then
      abrt "ERROR: unable to retrieve datasource ${datasource}. Exiting."
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
