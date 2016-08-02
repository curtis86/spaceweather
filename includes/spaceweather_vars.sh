# Project variables and constants go here

# CONSTANTS
readonly PROJECT_NAME="spaceweather"
readonly PROGNAME="$( basename $0 )"
readonly LOG_FILE=""
readonly SCRIPT_DEPENDENCIES=( "bc" "wget" )

readonly max_args=2
readonly DATA_DIR="${HOME_DIR}/data"