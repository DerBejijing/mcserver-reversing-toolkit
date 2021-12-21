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



# compile all files contained in the $FILETRACKER
# if they refuse to compile, add them to the $ERROR_FILES array
# it will use the patched jar's classpath, but at this point I am
#  unsure whether or not this will cause any problems
#  which is why I marked the location you would need to change
#  to suit your wishes
compile () {

	echo -e "${COLOR_YELLOW}Compiling... [${COLOR_RESET}"

	# iterate over every line in the $FILETRACKER file and try to compile it
	while read line; do

        echo -e "${COLOR_LIGHT_BLUE}${line}${COLOR_RESET}"
        
        # this is basically a try-catch in bash lol
        {
        	# try to compile the file
        	# if needed, change $PATCH_JAR to another jar
        	#  of which you want to use the classpath
            javac -cp $PATCH_JAR "${DIR_DECOMPILED_JAR}/$line"
        } || {
        	# does not compile, add to $ERROR_FILES so they are skipped when putting
        	#  the recompiled files back into the jar
            ERROR_FILES+=($line)
        }
    done < $FILETRACKER

	echo -e "${COLOR_YELLOW}... ] Done Compiling${COLOR_RESET}"

}


# after compiling, put all compiled files that did not throw
#  an error into the patched jar
# all files that caused an error get echoed out
patch () {

	# save the location the script was called from to cd back to it later
	TMP_LOC=$(pwd)

	cd $DIR_DECOMPILED_JAR

	# this counter gets incremented once a file is put into the jar
	#  so an error can be thrown when no files have been patched
	#  which make this script appear very professional
	PATCHED_FILES=0
	echo -e "${COLOR_YELLOW}Patching server jar${COLOR_RESET}"
    echo -e "${COLOR_YELLOW}Packing files... [${COLOR_RESET}"

    while read line; do
        
        # copy the loop-variables value into a new one that can be changed
        # I do not know if this is necessary
        # probably not
        # did it anyway
        # I'll remove it
        NEXT_FILE=$line
        
        # check if the current file is included in the error files array
        # that way it can be skipped, if it is included in the error files array
        CONTAINS=0
        for file in ${ERROR_FILES[@]}
        do
            if [[ $file = $NEXT_FILE ]]; then
                CONTAINS=1
            fi
        done

        # if it is not contained in the error files array, put it in the jar-file
        if [[ $CONTAINS -eq 0 ]]; then

        	# change .java to .class
        	# needed because the files to be put in the patched jar-file
        	#  are class files while the strings in the $FILETRACKER
        	#  file are raw java files
            NEXT_FILE=${NEXT_FILE//.java/.class}

            echo -e "${COLOR_LIGHT_BLUE}${NEXT_FILE}${COLOR_RESET}"
            
            # put in the jar using jar -uf
            jar -uf ${TMP_LOC}/${PATCH_JAR} ${NEXT_FILE}

            # increment the counter
            ((PATCHED_FILES=PATCHED_FILES+1))
        fi
    done < ${TMP_LOC}/${FILETRACKER}

    # cd back to where the script was called
    cd $TMP_LOC

    # if no files have been patched to the jar, output an error
	if [[ $PATCHED_FILES -eq 0 ]]; then
		echo -e "${COLOR_RED}No files have been packed${COLOR_RESET}"
	fi

}


# if the filetracker contains lines, try to compile them
# then, patch them to the jar-file
patch_server () {

	# temporary counter to check the number of lines in
	#  the $FILETRACKER file
	FILETRACKER_LINES=0
	while read line; do
		((FILETRACKER_LINES=FILETRACKER_LINES+1))
	done < $FILETRACKER

	# if it is empty, output an error
	if [[ FILETRACKER_LINES -eq 0 ]]; then
		echo -e "${COLOR_RED}No files have been specified${COLOR_RESET}"
		exit -1
	fi
	
	# use the SCRIPT_GET_JAR script to see if there even
	#  is a to-be-patched jar
	PATCH_JAR=$($SCRIPT_GET_JAR)

	# if there is no jar-file, output an error
	if [[ $PATCH_JAR = "" ]]; then
		echo -e "${COLOR_RED}Jar to be patched is missing (should be in ${PATCH_JAR})${COLOR_RESET}"
		exit -1
	fi

	# if there are no errors compile and patch
	compile
	patch

}



# only run if the project has been initialized
if ! [[ $(${SCRIPT_GET_INITIALIZED}) = "ok" ]]; then
	echo -e "${COLOR_RED}Some directories are missing, try running ${COLOR_LIGHT_BLUE}./setup${COLOR_RESET}"
	exit 0
fi

# check arguments
# --tracked: idk what the hell that does
if [[ -n $1 ]]; then
	if [[ $1 = "--tracked" ]]; then
		${SCRIPT_TRACK}
	fi
fi

# call patch_server
patch_server
