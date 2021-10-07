#!/bin/bash

DIR_DATA=./data
DIR_SERVER=./server_jar
DIR_DECOMPILED=./decompiled
DIR_DECOMPILERS=./decompilers
DIR_DECOMPILERS_BIN=${DIR_DECOMPILERS}/bin

DECOMPILERS=("")

SPACE_FILENAME="30"
SPACE_NAME="30"
SPACE_RATE="10"
SPACE_INST="10"

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


get_decompiler_info () {

	FILE=$1

	NAME=""
	DESCRIPTION=""
	RATING=""
	INSTALLED="no"

	while read line; do
		if [[ $(echo $line | grep -o "NAME" | wc -l) = "1" ]]; then
			NAME=${line//#NAME:/}
			NAME=$(fit_string_to_size $NAME $SPACE_NAME)
		fi
		if [[ $(echo $line | grep -o "RATE" | wc -l) = "1" ]]; then
			RATING=${line//#RATE:/}
			RATING=$(fit_string_to_size $RATING $SPACE_RATE)
		fi
		if [[ $(echo $line | grep -o "INST" | wc -l) = "1" ]]; then
			INSALLATION=${line//#INST:/}
			if test -f "${DIR_DECOMPILERS_BIN}/${INSALLATION}"; then
				INSTALLED="yes"
			fi
			INSTALLED=$(fit_string_to_size $INSTALLED $SPACE_INST)
		fi
	done < $1

	FILE=${FILE//${DIR_DECOMPILERS}/}
	FILE=${FILE//\//}
	FILE=$(fit_string_to_size $FILE $SPACE_FILENAME)

	echo -e ${COLOR_LIGHT_BLUE}${FILE}${COLOR_YELLOW}"|"${COLOR_LIGHT_BLUE}${NAME}${COLOR_YELLOW}"|"${COLOR_LIGHT_BLUE}${RATING}${COLOR_YELLOW}"|"${COLOR_LIGHT_BLUE}${INSTALLED}${COLOR_RESET}

}


fit_string_to_size () {

	STRING=$1
	SIZE=$2
	STRINGSIZE=$(echo "$STRING" | wc -m)
	# add an extra -2 for the indetations
	((STRINGSIZE=STRINGSIZE-3))

	if [[ ! $SIZE = $STRINGSIZE ]]; then
		STRINGBUILDER="_$STRING"

		CURRENT_LEN=$(echo "$STRINGBUILDER" | wc -m)
		
		while [[ ! $CURRENT_LEN = $SIZE ]]; do
			STRINGBUILDER=${STRINGBUILDER}"_"
			CURRENT_LEN=$(echo "$STRINGBUILDER" | wc -m)
		done
		STRINGBUILDER=${STRINGBUILDER}"_"

		echo $STRINGBUILDER
	else
		echo "_$STRING_"
	fi
}


# ugly, but padding whitespace characters to fit propperly is not that easy :/
list_available_decompilers () {

	echo -e "${COLOR_YELLOW}Available decompilers:${COLOR_RESET}"
	COUNT=$(find $DIR_DECOMPILERS -name "*.sh" -type f | wc -l)
	echo -e "${COLOR_YELLOW}_FILENAME_____________________|_NAME_________________________|_RATING___|_INSTALLED${COLOR_RESET}"
	if [[ ! $COUNT = "0" ]]; then
		DECOMPILERS=($( find $DIR_DECOMPILERS -name "*.sh" -type f ))
		for dcmp in ${DECOMPILERS[@]}; do
			get_decompiler_info $dcmp
		done
	fi

	echo -e "${COLOR_GREEN}${COUNT} avialable decompiler(s)${COLOR_RESET}"

}


install_decompiler () {

	list_available_decompilers
	echo -e "\n"
	read -r -p "Enter filename of a decompiler or Ctrl+C to exit: " CHOICE
	CHOICE=${CHOICE//" "/}
	if test -f ${DIR_DECOMPILERS}/${CHOICE}; then
		echo -e ${COLOR_YELLOW}Installing decompiler: ${COLOR_LIGHT_BLUE}${CHOICE}${COLOR_RESET}
		chmod +x ${DIR_DECOMPILERS}/${CHOICE}
		${DIR_DECOMPILERS}/${CHOICE} install
	else
		echo "Decompiler does not exist"
		read -n 1 -s -r -p "Press any key to continue"
		clear
		install_decompiler
	fi

}


run_decompiler () {

	list_available_decompilers
	echo -e "\n"
	read -r -p "Enter filename of a decompiler or Ctrl+C to exit: " CHOICE
	CHOICE=${CHOICE//" "/}
	if test -f ${DIR_DECOMPILERS}/${CHOICE}; then
		echo -e ${COLOR_YELLOW}Running decompiler: ${COLOR_LIGHT_BLUE}${CHOICE}${COLOR_RESET}
		chmod +x ${DIR_DECOMPILERS}/${CHOICE}
		${DIR_DECOMPILERS}/${CHOICE} "run" "$(get_jar ${DIR_SERVER})" "${DIR_DECOMPILED}"
	else
		echo "Decompiler does not exist"
		read -n 1 -s -r -p "Press any key to continue"
		clear
		install_decompiler
	fi

}


print_help () {

    echo "Run with: $0 + [OPTION]"
    echo -e "\nOptions:"
    echo "h / ?       : prints help menu"
    echo "--list      : list all avialable decompilers"
    echo "--install   : Opens a menu for installing different decompilers"
    echo "--decompile : run a decompiler"
    
}



if [[ ! -d "${DIR_DATA}" ]]; then
	echo -e "${COLOR_RED}Your data directory does not exist. Run ${COLOR_LIGHT_BLUE}./setup.sh${COLOR_RED} first${COLOR_RESET}"
	exit -1
fi


if [[ -n $1 ]]; then
    if [[ $1 = "?" ]]; then
        print_help
    elif [[ $1 = "h" ]]; then
    	print_help
    elif [[ $1 = "--list" ]]; then
    	list_available_decompilers
    	exit 0
	elif [[ $1 = "--install" ]]; then
    	install_decompiler
	elif [[ $1 = "--decompile" ]]; then
    	run_decompiler
    else
	    print_help
    fi
else
    print_help
fi
