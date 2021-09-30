DIR_DATA=./data
DIR_SERVER=./server_jar
DIR_DECOMPILED=./decompiled
DIR_PATCHED=./patched_server
DIR_DECOMPILERS=./decompilers
DIR_DECOMPILERS_BIN=${DIR_DECOMPILERS}/bin

FILETRACKER=${DIR_DATA}/files.txt
SERVER_ARGS=${DIR_DATA}/args.txt

COLOR_RED='\033[0;31m'
COLOR_GREEN='\033[0;32m'
COLOR_LIGHT_BLUE='\033[1;34m'
COLOR_YELLOW='\033[1;33m'
COLOR_RESET='\033[0m'

echo_file () {

	echo -e "${COLOR_LIGHT_BLUE}${1}${COLOR_RESET}"

}


setup_files () {

	echo -e "${COLOR_YELLOW}Creating files...${COLOR_RESET}"
	rm -rf $DIR_DATA
	rm -rf $DIR_SERVER
	rm -rf $DIR_DECOMPILED
	rm -rf $DIR_PATCHED
	rm -rf $DIR_DECOMPILERS

	mkdir $DIR_DATA
	echo_file $DIR_DATA

	mkdir $DIR_SERVER
	echo_file $DIR_SERVER

	mkdir $DIR_DECOMPILED
	echo_file $DIR_DECOMPILED

	mkdir $DIR_PATCHED
	echo_file $DIR_PATCHED

	mkdir $DIR_DECOMPILERS
	echo_file $DIR_DECOMPILERS
	
	mkdir $DIR_DECOMPILERS_BIN
	echo_file $DIR_DECOMPILERS_BIN
	
	touch $FILETRACKER
	echo_file $FILETRACKER

	touch $SERVER_ARGS
	echo_file $SERVER_ARGS

	echo -e "${COLOR_GREEN}Done${COLOR_RESET}"


}

if [[ $1 = "--confirm" ]]; then
	CONTINUE=yes
else
	read -r -p "This will setup all files / folders and delete existing. Are you sure you want to continue? [y/n]" CONTINUE
fi


if [[ $CONTINUE =~ ^(yes|y)$ ]]; then
	setup_files
	exit 0
else
	echo -e "${COLOR_RED}Aborted${COLOR_RESET}"
	exit 0
fi
