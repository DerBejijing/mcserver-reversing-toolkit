DIR_DATA=./data
DIR_PATCHED=./patched_server

SERVER_ARGS=${DIR_DATA}/args.txt

COLOR_RED='\033[0;31m'
COLOR_GREEN='\033[0;32m'
COLOR_LIGHT_BLUE='\033[1;34m'
COLOR_YELLOW='\033[1;33m'
COLOR_RESET='\033[0m'


run_server () {

	echo -e "${COLOR_YELLOW}Running Server...${COLOR_RESET}"
	echo -e "${COLOR_GREEN}${@}${COLOR_RESET}"
	echo lul

}


if [[ -n $1 ]]; then
	ARGUMENTS="$@"
	run_server $ARGUMENTS
else
	echo -e "${COLOR_YELLOW}Using arguments from file: ${COLOR_LIGHT_BLUE}${SERVER_ARGS}${COLOR_RESET}"
	ARGUMENTS=""
	run_server $ARGUMENTS
fi


