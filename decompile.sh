DIR_DECOMPILERS=./decompilers
DIR_DECOMPILERS_BIN=${DIR_DECOMPILERS}/bin

COLOR_RED='\033[0;31m'
COLOR_GREEN='\033[0;32m'
COLOR_LIGHT_BLUE='\033[1;34m'
COLOR_YELLOW='\033[1;33m'
COLOR_RESET='\033[0m'


# !right now useless!
# This script will allow you to automate downloading and running different decompilers
# For each decompiler, there will be a script holding instructions on how to install and run it
# That way you can easily add own decompilers


get_available_decompilers () {

	COUNT=$(find decompilers/ -name "*.sh" -type f | wc -l)
	echo "${COUNT} avialable decompilers"

}


get_available_decompilers