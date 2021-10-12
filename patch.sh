#!/bin/bash

DIR_TOOL=./tool
DIR_PATCHED_JAR=./patched_jar
DIR_DECOMPILED_JAR=./decompiled_jar

DIR_UTILS=${DIR_TOOL}/utils

FILETRACKER=${DIR_TOOL}/files.txt
SCRIPT_TRACK=./track.sh
SCRIPT_GET_JAR=${DIR_UTILS}/get_jar.sh
SCRIPT_GET_INITIALIZED=${DIR_UTILS}/get_initialized.sh

PATCH_JAR=""
ERROR_FILES=("")

COLOR_RED='\033[0;31m'
COLOR_GREEN='\033[0;32m'
COLOR_LIGHT_BLUE='\033[1;34m'
COLOR_YELLOW='\033[1;33m'
COLOR_RESET='\033[0m'



compile () {

	echo -e "${COLOR_YELLOW}Compiling... [${COLOR_RESET}"

	while read line; do
        echo -e "${COLOR_LIGHT_BLUE}${line}${COLOR_RESET}"
        {
            javac -cp $PATCH_JAR "${DIR_DECOMPILED_JAR}/$line"
        } || {
            ERROR_FILES+=($line)
        }
    done < $FILETRACKER

	echo -e "${COLOR_YELLOW}... ] Done Compiling${COLOR_RESET}"

}


patch () {

	TMP_LOC=$(pwd)

	cd $DIR_DECOMPILED_JAR

	PATCHED_FILES=0
	echo -e "${COLOR_YELLOW}Patching server jar${COLOR_RESET}"
    echo -e "${COLOR_YELLOW}Packing files... [${COLOR_RESET}"
    while read line; do
        NEXT_FILE=$line
        CONTAINS=0

        for file in ${ERROR_FILES[@]}
        do
            if [[ $file = $NEXT_FILE ]]; then
                CONTAINS=1
            fi
        done

        if [[ $CONTAINS -eq 0 ]]; then
            NEXT_FILE=${NEXT_FILE//.java/.class}

            echo -e "${COLOR_LIGHT_BLUE}${NEXT_FILE}${COLOR_RESET}"
            jar -uf ${TMP_LOC}/${PATCH_JAR} ${NEXT_FILE}
            ((PATCHED_FILES=PATCHED_FILES+1))
        fi
    done < ${TMP_LOC}/${FILETRACKER}

    cd $TMP_LOC

	if [[ $PATCHED_FILES -eq 0 ]]; then
		echo -e "${COLOR_RED}No files have been packed${COLOR_RESET}"
	fi

}


patch_server () {

	FILETRACKER_LINES=0
	while read line; do
		((FILETRACKER_LINES=FILETRACKER_LINES+1))
	done < $FILETRACKER

	if [[ FILETRACKER_LINES -eq 0 ]]; then
		echo -e "${COLOR_RED}No files have been specified${COLOR_RESET}"
		exit -1
	fi
	
	PATCH_JAR=$($SCRIPT_GET_JAR)

	if [[ $PATCH_JAR = "" ]]; then
		echo -e "${COLOR_RED}Jar to be patched is missing (should be in ${PATCH_JAR})${COLOR_RESET}"
		exit -1
	fi

	compile
	patch

}



if ! [[ $(${SCRIPT_GET_INITIALIZED}) = "ok" ]]; then
	echo -e "${COLOR_RED}Some directories are missing, try running ${COLOR_LIGHT_BLUE}./setup${COLOR_RESET}"
	exit 0
fi

if [[ -n $1 ]]; then
	if [[ $1 = "--tracked" ]]; then
		${SCRIPT_TRACK}
	fi
fi

patch_server
