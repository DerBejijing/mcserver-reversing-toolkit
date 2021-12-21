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



# get all .sh files in the $DIR_INSTALLERS directory
# this assumes that all sh files follow the structure of the fernflower example
list_available_installers () {

	# count all .sh files using wc
	COUNT=($( find $DIR_INSTALLERS -name "*.sh" -type f | wc -l))

	# if the count is not 0 print all installers in a table
	if ! [[ $COUNT = "0" ]]; then

		# create an array containing all installer scripts
		INSTALLERS=($( find $DIR_INSTALLERS -name "*.sh" -type f ))

		echo -e "${COLOR_YELLOW}---------------------------${COLOR_RESET}"

		# iterate over the $INSTALLERS array created above and print its contents
		for installer in ${INSTALLERS[@]}; do

			# to show only the filename the directory part of the string is removed
			echo -e "${COLOR_YELLOW}${installer//${DIR_INSTALLERS}\//}${COLOR_RESET}"

		done
		echo -e "${COLOR_YELLOW}---------------------------${COLOR_RESET}"
	fi

	# echo count of available installers
	echo -e "${COLOR_GREEN}${COUNT} avialable installers(s)${COLOR_RESET}"

	exit

}


# run the installer set in $SPECIFIED_INSTALLER
# the version must be stored in $VERSION
install () {

	# to get a consistant path the string gets made prettier
	# that way the $SPECIFIED_INSTALLER is always $DIR_INSTALLERS + NAME + .sh
	#  eventhough the string originally only was the filename (example)
	SPECIFIED_INSTALLER=${SPECIFIED_INSTALLER//.sh/}
	SPECIFIED_INSTALLER=${SPECIFIED_INSTALLER//${DIR_INSTALLERS}/}
	SPECIFIED_INSTALLER=${SPECIFIED_INSTALLER}.sh
	SPECIFIED_INSTALLER=${DIR_INSTALLERS}/${SPECIFIED_INSTALLER}

	# if the specified installer exists, run it
	if test -f ${SPECIFIED_INSTALLER}; then

		# cut away parts of the string to only display the filename
		echo -e "${COLOR_YELLOW}Running installer: ${COLOR_LIGHT_BLUE}${SPECIFIED_INSTALLER//${DIR_INSTALLERS}\//}${COLOR_RESET}"
		
		# make it executable
		chmod +x $SPECIFIED_INSTALLER

		# run it with the information about paths and files it needs
		${SPECIFIED_INSTALLER} "$(pwd)" "${DIR_PATCHED_JAR}" "${DIR_SERVER_JAR}" "${VERSION}"

		exit
	fi

	# installer not found, echo an error message
	echo -e "${COLOR_RED}Installer not found: ${COLOR_LIGHT_BLUE}${SPECIFIED_INSTALLER}${COLOR_RESET}"

	exit
}


# print a help menu listing all the arguments
print_help () {

    echo "Run with: $0 + [OPTION]"
    echo -e "\nOptions:"
    echo "h / ?                      : prints help menu"
    echo "--list                     : list all avialable server-installers"
    echo "--install <name> <version> : installs the supplied server-installer"
   
}


# only run if the project has been initialized
if ! [[ $(${SCRIPT_GET_INITIALIZED}) = "ok" ]]; then
	echo -e "${COLOR_RED}Some directories are missing, try running ${COLOR_LIGHT_BLUE}./setup${COLOR_RESET}"
	exit 0
fi


# check arguments
# all arguments are explained above in print_help and the README.md
if [[ -n $1 ]]; then
	if [[ $1 = "--list" ]]; then
		list_available_installers
	elif [[ $1 = "--install" ]] && [[ -n $2 ]] && [[ -n $3 ]]; then
		SPECIFIED_INSTALLER=$2
		VERSION=$3
		install
	fi
fi

# invalid arguments, print help menu
print_help
