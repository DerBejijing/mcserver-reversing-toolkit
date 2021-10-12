#!/bin/bash

DIR_TOOL=./tool
DIR_DECOMPILED_JAR=./decompiled_jar

DIR_TMP=${DIR_TOOL}/tmp
DIR_UTILS=${DIR_TOOL}/utils

FILESUMS=${DIR_TOOL}/sha_sums.txt
TMP_FILESUMS=${DIR_TMP}/sha_sums.txt
FILETRACKER=${DIR_TOOL}/files.txt
SCRIPT_GET_INITIALIZED=${DIR_UTILS}/get_initialized.sh

CHANGED_FILES=("")

COLOR_RED='\033[0;31m'
COLOR_GREEN='\033[0;32m'
COLOR_LIGHT_BLUE='\033[1;34m'
COLOR_YELLOW='\033[1;33m'
COLOR_RESET='\033[0m'



initialize () {

	if test -f $FILESUMS; then
		rm $FILESUMS
	fi

	touch $FILESUMS
	find $DIR_DECOMPILED_JAR -name "*.java" | xargs shasum | tr -s '[:space:]' > $FILESUMS

	exit

}


track () {

	if test -f $TMP_FILESUMS; then
		rm $TMP_FILESUMS
	fi
	touch $TMP_FILESUMS
	find $DIR_DECOMPILED_JAR -name "*.java" | xargs shasum | tr -s '[:space:]' > $TMP_FILESUMS

	# empties the filetracker. needed/useful?
	rm $FILETRACKER
	touch $FILETRACKER

	while read line; do

		CONTAINS=$(cat $FILESUMS | grep "$line" | wc -l)
		if [[ $CONTAINS = "0" ]]; then
			echo "${line}"
			substrings=( $line )
			line=${substrings[1]}
			line=${line//${DIR_DECOMPILED_JAR}\//}
			echo $line >> $FILETRACKER
		fi

	done < $TMP_FILESUMS

}



if ! [[ $(${SCRIPT_GET_INITIALIZED}) = "ok" ]]; then
	echo -e "${COLOR_RED}Some directories are missing, try running ${COLOR_LIGHT_BLUE}./setup${COLOR_RESET}"
	exit 0
fi

if [[ -n $1 ]]; then
	if [[ $1 = "--init" ]]; then
		initialize
	fi
fi

track
