#!/bin/bash

DIR_TOOL=./tool
DIR_PATCHED_JAR=./patched_jar

DIR_UTILS=${DIR_TOOL}/utils

SERVER_ARGS=${DIR_TOOL}/args.txt
SCRIPT_GET_JAR=${DIR_UTILS}/get_jar.sh
SCRIPT_GET_INITIALIZED=${DIR_UTILS}/get_initialized.sh

COLOR_RED='\033[0;31m'
COLOR_GREEN='\033[0;32m'
COLOR_LIGHT_BLUE='\033[1;34m'
COLOR_YELLOW='\033[1;33m'
COLOR_RESET='\033[0m'



# runs the first valid server-jar in $DIR_PATCHED_JAR
# idealy, there is only one
run_server () {

	# save the location the script was called from to cd back to it later
	TMP_LOC=$(pwd)

	cd ${DIR_PATCHED_JAR}

	# use the SCRIPT_GET_JAR script to find a valid jar-file in $DIR_PATCHED_JAR
	SERVER_JAR=$(${TMP_LOC}/${SCRIPT_GET_JAR} "${TMP_LOC}/${DIR_PATCHED_JAR}")

	# if there is no jar-file, abort
	if [[ $SERVER_JAR = "" ]]; then
		echo -e "${COLOR_RED}No server-jar found${COLOR_RESET}"
		exit -1
	fi

	# run the jar-file using the arguments supplied to the function
	echo -e "${COLOR_YELLOW}Running Server...${COLOR_RESET}"
	echo -e "${COLOR_GREEN}${@}${COLOR_RESET}"
	java -jar $SERVER_JAR ${@}

	# cd back to where the script was called
	cd $TMP_LOC

}



# only run if the project has been initialized
if ! [[ $(${SCRIPT_GET_INITIALIZED}) = "ok" ]]; then
	echo -e "${COLOR_RED}Some directories are missing, try running ${COLOR_LIGHT_BLUE}./setup${COLOR_RESET}"
	exit 0
fi

# check arguments
# if arguments are supplied, the script uses them to call the server
# if not, the arguments in $SERVER_ARGS are used
if [[ -n $1 ]]; then
	echo -e "${COLOR_YELLOW}Using arguments: ${COLOR_LIGHT_BLUE}${@}${COLOR_RESET}"
	ARGUMENTS="$@"
	run_server $ARGUMENTS
else
	echo -e "${COLOR_YELLOW}Using arguments from file: ${COLOR_LIGHT_BLUE}${SERVER_ARGS}${COLOR_RESET}"
	ARGUMENTS=$(cat $SERVER_ARGS)
	run_server $ARGUMENTS
fi
