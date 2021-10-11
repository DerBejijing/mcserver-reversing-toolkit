#!/bin/bash

DIR_TOOL=./tool
DIR_PATCHED_JAR=./patched_jar
DIR_SERVER_JAR=./server_jar

DIR_UTILS=${DIR_TOOL}/utils
DIR_INSTALLERS=${DIR_TOOL}/server_installers

SCRIPT_GET_INITIALIZED=${DIR_UTILS}/get_initialized.sh

INSTALLERS=("")
SPECIFIED_INSTALLER=""
VERSION=""

COLOR_RED='\033[0;31m'
COLOR_GREEN='\033[0;32m'
COLOR_LIGHT_BLUE='\033[1;34m'
COLOR_YELLOW='\033[1;33m'
COLOR_RESET='\033[0m'



list_available_installers () {

	COUNT=($( find $DIR_INSTALLERS -name "*.sh" -type f | wc -l))
	if ! [[ $COUNT = "0" ]]; then
		INSTALLERS=($( find $DIR_INSTALLERS -name "*.sh" -type f ))

		echo -e "${COLOR_YELLOW}---------------------------${COLOR_RESET}"
		for installer in ${INSTALLERS[@]}; do
			echo -e "${COLOR_YELLOW}${installer//${DIR_INSTALLERS}\//}${COLOR_RESET}"
		done
		echo -e "${COLOR_YELLOW}---------------------------${COLOR_RESET}"
	fi

	echo -e "${COLOR_GREEN}${COUNT} avialable installers(s)${COLOR_RESET}"

	exit

}



install () {

	SPECIFIED_INSTALLER=${SPECIFIED_INSTALLER//.sh/}
	SPECIFIED_INSTALLER=${SPECIFIED_INSTALLER//${DIR_INSTALLERS}/}
	SPECIFIED_INSTALLER=${SPECIFIED_INSTALLER}.sh
	SPECIFIED_INSTALLER=${DIR_INSTALLERS}/${SPECIFIED_INSTALLER}

	if test -f ${SPECIFIED_INSTALLER}; then
		echo -e "${COLOR_YELLOW}Running installer: ${COLOR_LIGHT_BLUE}${SPECIFIED_INSTALLER//${DIR_INSTALLERS}\//}${COLOR_RESET}"
		chmod +x $SPECIFIED_INSTALLER
		${SPECIFIED_INSTALLER} "$(pwd)" "${DIR_PATCHED_JAR}" "${DIR_SERVER_JAR}" "${VERSION}"
		exit
	fi

	echo -e "${COLOR_RED}Installer not found: ${COLOR_LIGHT_BLUE}${SPECIFIED_INSTALLER}${COLOR_RESET}"
	exit
}


print_help () {

    echo "Run with: $0 + [OPTION]"
    echo -e "\nOptions:"
    echo "h / ?                      : prints help menu"
    echo "--list                     : list all avialable server-installers"
    echo "--install <name> <version> : installs the supplied server-installer"
   
}



if ! [[ $(${SCRIPT_GET_INITIALIZED}) = "ok" ]]; then
	echo -e "${COLOR_RED}Some directories are missing, try running ${COLOR_LIGHT_BLUE}./setup${COLOR_RESET}"
	exit 0
fi


if [[ -n $1 ]]; then
	if [[ $1 = "--list" ]]; then
		list_available_installers
	elif [[ $1 = "--install" ]] && [[ -n $2 ]] && [[ -n $3 ]]; then
		SPECIFIED_INSTALLER=$2
		VERSION=$3
		install
	fi
fi

print_help