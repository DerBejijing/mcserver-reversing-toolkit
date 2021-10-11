#!/bin/bash

DIR_TOOL=./tool
DIR_DECOMPILED_JAR=./decompiled_jar
DIR_SERVER_JAR=./server_jar

DIR_TMP=${DIR_TOOL}/tmp
DIR_UTILS=${DIR_TOOL}/utils
DIR_DECOMPILERS=${DIR_TOOL}/decompilers
DIR_DECOMPILERS_BIN=${DIR_DECOMPILERS}/bin

SCRIPT_GET_JAR=${DIR_UTILS}/get_jar.sh
SCRIPT_GET_INITIALIZED=${DIR_UTILS}/get_initialized.sh
TMPFILE_DECOMPILER_INFO=${DIR_TMP}/decompiler_info.txt

DECOMPILERS=("")
SPECIFIED_DECOMPILER=""

COLOR_RED='\033[0;31m'
COLOR_GREEN='\033[0;32m'
COLOR_LIGHT_BLUE='\033[1;34m'
COLOR_YELLOW='\033[1;33m'
COLOR_RESET='\033[0m'



list_available_decompilers () {

	COUNT=($( find $DIR_DECOMPILERS -name "*.sh" -type f | wc -l))
	if ! [[ $COUNT = "0" ]]; then
		DECOMPILERS=($( find $DIR_DECOMPILERS -name "*.sh" -type f ))

		echo -e "${COLOR_YELLOW}---------------------------${COLOR_RESET}"
		for decomp in ${DECOMPILERS[@]}; do
			echo -e "${COLOR_YELLOW}${decomp//${DIR_DECOMPILERS}\//}${COLOR_RESET}"
		done
		echo -e "${COLOR_YELLOW}---------------------------${COLOR_RESET}"
	fi

	echo -e "${COLOR_GREEN}${COUNT} avialable decompiler(s)${COLOR_RESET}"

}


install_decompiler () {

	SPECIFIED_DECOMPILER=${SPECIFIED_DECOMPILER//.sh/}
	SPECIFIED_DECOMPILER=${SPECIFIED_DECOMPILER//${DIR_DECOMPILERS}/}
	SPECIFIED_DECOMPILER=${SPECIFIED_DECOMPILER}.sh
	SPECIFIED_DECOMPILER=${DIR_DECOMPILERS}/${SPECIFIED_DECOMPILER}

	if test -f ${SPECIFIED_DECOMPILER}; then
		echo -e "${COLOR_YELLOW}Installing decompiler: ${COLOR_LIGHT_BLUE}${SPECIFIED_DECOMPILER//${DIR_DECOMPILERS}\//}${COLOR_RESET}"
		chmod +x $SPECIFIED_DECOMPILER
		${SPECIFIED_DECOMPILER} "install" "$(pwd)" "${DIR_TOOL}" "${DIR_TMP}"
		exit
	fi

	echo -e "${COLOR_RED}Decompiler not found: ${COLOR_LIGHT_BLUE}${SPECIFIED_DECOMPILER}${COLOR_RESET}"
}


run_decompiler () {

	SPECIFIED_DECOMPILER=${SPECIFIED_DECOMPILER//.sh/}
	SPECIFIED_DECOMPILER=${SPECIFIED_DECOMPILER//${DIR_DECOMPILERS}/}
	SPECIFIED_DECOMPILER=${SPECIFIED_DECOMPILER}.sh
	SPECIFIED_DECOMPILER=${DIR_DECOMPILERS}/${SPECIFIED_DECOMPILER}

	if test -f ${SPECIFIED_DECOMPILER}; then
		echo -e "${COLOR_YELLOW}Running decompiler: ${COLOR_LIGHT_BLUE}${SPECIFIED_DECOMPILER//${DIR_DECOMPILERS}\//}${COLOR_RESET}"
		chmod +x $SPECIFIED_DECOMPILER

		SERVER_JAR_ABS=$(pwd)/$(${SCRIPT_GET_JAR} ${DIR_SERVER_JAR})
		DIR_DECOMPILED_ABS=$(pwd)/${DIR_DECOMPILED_JAR}

		${SPECIFIED_DECOMPILER} "decompile" "$(pwd)" "${DIR_TOOL}" "${SERVER_JAR_ABS}" "${DIR_DECOMPILED_ABS}"
		
		exit
	fi

	echo -e "${COLOR_RED}Decompiler not found: ${COLOR_LIGHT_BLUE}${SPECIFIED_DECOMPILER}${COLOR_RESET}"

}


print_help () {

    echo "Run with: $0 + [OPTION]"
    echo -e "\nOptions:"
    echo "h / ?              : prints help menu"
    echo "--list             : list all avialable decompilers"
    echo "--install   <name> : installs the supplied decompiler"
    echo "--decompile <name> : decompiles using the supplied decompiler name"
    
}



if ! [[ $(${SCRIPT_GET_INITIALIZED}) = "ok" ]]; then
	echo -e "${COLOR_RED}Some directories are missing, try running ${COLOR_LIGHT_BLUE}./setup${COLOR_RESET}"
	exit 0
fi


if [[ -n $1 ]]; then
    if [[ $1 = "?" ]]; then
        print_help
    elif [[ $1 = "h" ]]; then
    	print_help
    elif [[ $1 = "--list" ]]; then
    	list_available_decompilers
	elif [[ $1 = "--install" ]] && [[ -n $2 ]]; then
    	SPECIFIED_DECOMPILER=$2
    	install_decompiler
    elif [[ $1 = "--decompile" ]] && [[ -n $2 ]]; then
    	SPECIFIED_DECOMPILER=$2
    	run_decompiler
    else
	    print_help
    fi
else
    print_help
fi
