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



# computes the checksum for all decompiled java files
# all checksums get then stored in the $FILESUMS file
initialize () {

	# (re)create file
	rm -f $FILESUMS
	touch $FILESUMS

	# compute checksum using shasum
	# remove spaces
	find $DIR_DECOMPILED_JAR -name "*.java" | xargs shasum | tr -s '[:space:]' > $FILESUMS

	exit

}


# computes the checksum for all decompiled java files to
#  compare them against the stored ones
# the temporary checksums get stored in $TMP_FILESUMS, which gets recreated every time
track () {

	# (re)create file
	rm -f $TMP_FILESUMS
	touch $TMP_FILESUMS

	# compute checksum using shasum
	# remove spaces
	find $DIR_DECOMPILED_JAR -name "*.java" | xargs shasum | tr -s '[:space:]' > $TMP_FILESUMS

	# empties the filetracker. needed/useful?
	# I don't know
	rm -f $FILETRACKER
	touch $FILETRACKER

	# iterate over every line in $TMP_FILESUMS
	# check if every line appears in $FILESUMS
	# if not, the file has changed and thus, must be recompiled
	while read line; do

		# check if the line appears in $FILESUMS using grep
		CONTAINS=$(cat $FILESUMS | grep "$line" | wc -l)

		# If it is not included (which means it has changed) it gets added to the filetracker
		if [[ $CONTAINS = "0" ]]; then
			echo "${line}"
			substrings=( $line )
			line=${substrings[1]}
			line=${line//${DIR_DECOMPILED_JAR}\//}
			echo $line >> $FILETRACKER
		fi

	done < $TMP_FILESUMS

}



# only run if the project has been initialized
if ! [[ $(${SCRIPT_GET_INITIALIZED}) = "ok" ]]; then
	echo -e "${COLOR_RED}Some directories are missing, try running ${COLOR_LIGHT_BLUE}./setup${COLOR_RESET}"
	exit 0
fi

# check arguments
# "--init" only recreates the $FILESUMS file
if [[ -n $1 ]]; then
	if [[ $1 = "--init" ]]; then
		initialize
	fi
fi

# no arguments supplied -> track gets called
track
