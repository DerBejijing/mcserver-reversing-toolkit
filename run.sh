DIR_DATA=./data
DIR_PATCHED=./patched_server

SERVER_ARGS=${DIR_DATA}/args.txt

SERVER_JAR=""

COLOR_RED='\033[0;31m'
COLOR_GREEN='\033[0;32m'
COLOR_LIGHT_BLUE='\033[1;34m'
COLOR_YELLOW='\033[1;33m'
COLOR_RESET='\033[0m'



get_jar () {

	JAR_FILES=($( find ${1} -name "*.jar" -type f ))
	if [[ ${#JAR_FILES[@]} -eq 0 ]]; then
		echo ""
	else
		echo ${JAR_FILES[0]}
	fi

}


run_server () {

	SERVER_JAR=$(get_jar $DIR_PATCHED)
	if [[ $SERVER_JAR = "" ]]; then
		echo -e "${COLOR_RED}No server-jar found${COLOR_RESET}"
		exit -1
	fi

	echo -e "${COLOR_YELLOW}Running Server...${COLOR_RESET}"
	echo -e "${COLOR_GREEN}${@}${COLOR_RESET}"
	java -jar $SERVER_JAR ${@}

}


if [[ -n $1 ]]; then
	ARGUMENTS="$@"
	run_server $ARGUMENTS
else
	echo -e "${COLOR_YELLOW}Using arguments from file: ${COLOR_LIGHT_BLUE}${SERVER_ARGS}${COLOR_RESET}"
	ARGUMENTS=""
	run_server $ARGUMENTS
fi
