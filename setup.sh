#!/bin/bash

DIR_TOOL=./tool
DIR_SERVER_JAR=./server_jar
DIR_DECOMPILED_JAR=./decompiled_jar
DIR_PATCHED_JAR=./patched_jar

DIR_INSTALLERS=${DIR_TOOL}/server_installers
DIR_DECOMPILERS=${DIR_TOOL}/decompilers
DIR_DECOMPILERS_BIN=${DIR_DECOMPILERS}/bin
DIR_UTILS=${DIR_TOOL}/utils
DIR_TMP=${DIR_TOOL}/tmp

FILESUMS=${DIR_TOOL}/sha_sums.txt
FILETRACKER=${DIR_TOOL}/files.txt
SERVER_ARGS=${DIR_TOOL}/args.txt

COLOR_RED='\033[0;31m'
COLOR_GREEN='\033[0;32m'
COLOR_LIGHT_BLUE='\033[1;34m'
COLOR_YELLOW='\033[1;33m'
COLOR_RESET='\033[0m'



setup_files () {

	# delete all directorys
	# no matter whether or not they actually exist
	rm -rf $DIR_PATCHED_JAR
	rm -rf $DIR_SERVER_JAR
	rm -rf $DIR_DECOMPILED_JAR
	rm -rf $DIR_TMP
	rm -rf $DIR_DECOMPILERS_BIN
	rm -f $FILESUMS
	rm -f $FILETRACKER
	rm -f $SERVER_ARGS

	# (re)create all directorys
	mkdir $DIR_PATCHED_JAR
	mkdir $DIR_SERVER_JAR
	mkdir $DIR_DECOMPILED_JAR
	mkdir $DIR_TMP
	mkdir $DIR_DECOMPILERS_BIN

	# (re)create all files necessary to use the tool
	touch $FILESUMS
	touch $FILETRACKER
	touch $SERVER_ARGS

	# set the executable bit for all scripts in the root directory
	#  of the project
	chmod +x *.sh

	TMP_LOC=$(pwd)
	
	# set the executable bit for all utility-scripts
	cd $DIR_UTILS
	chmod +x *.sh
	cd $TMP_LOC

	# set the executable bit for all decompiler-scripts
	cd $DIR_DECOMPILERS
	chmod +x *.sh
	cd $TMP_LOC

	# set the executable bit for all server-installer-scripts
	cd $DIR_INSTALLERS
	chmod +x *.sh
	cd $TMP_LOC

}



# check flags for "--confirm"
# this will skip the prompt asking the user whether or not they accept
#  deletion and recreation of all files and directorys
if [[ $1 = "--confirm" ]]; then
	CONTINUE=yes
else
	read -r -p "This will setup all files / folders and delete existing. Are you sure you want to continue? [y/n]" CONTINUE
fi

# only run setup_files if the user agrees
if [[ $CONTINUE =~ ^(yes|y)$ ]]; then
	setup_files
	exit 0
else
	echo -e "${COLOR_RED}Aborted${COLOR_RESET}"
	exit 0
fi
