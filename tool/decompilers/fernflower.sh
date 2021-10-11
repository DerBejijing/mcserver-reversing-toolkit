#!/bin/bash

DIR_BIN=""
PWD=""
DIR_TOOL=""
DIR_TMP=""
SERVER_JAR=""
DIR_DECOMPILED_JAR=""


COLOR_RED='\033[0;31m'
COLOR_GREEN='\033[0;32m'
COLOR_LIGHT_BLUE='\033[1;34m'
COLOR_YELLOW='\033[1;33m'
COLOR_RESET='\033[0m'



faster_clone () {

	git init
	git remote add -f origin https://github.com/JetBrains/intellij-community/
	git config core.sparseCheckout true

	echo "/plugins/java-decompiler/engine" >> .git/info/sparse-checkout

	git pull origin master

}


run_tests () {

	if ! [[ -x $(command -v "git") ]]; then
		echo -e "${COLOR_RED}Error: ${COLOR_LIGHT_BLUE}\"git\" ${COLOR_RED}could not be found on your system${COLOR_RESET}"
		exit -1
	fi

	if ! [[ -x $(command -v "java") ]]; then
		echo -e "${COLOR_RED}Error: ${COLOR_LIGHT_BLUE}\"java\" ${COLOR_RED}could not be found on your system${COLOR_RESET}"
		exit -1
	fi

}


install () {

	OPT="R"

	if [[ -d ${DIR_TMP}/fernflower ]]; then
		echo -e "${COLOR_RED}Fernflower source already exists${COLOR_RESET}"
		echo -e "${COLOR_YELLOW}Do you want to [R]eplace it, [A]bort or re[B]uild the jar? [R/A/B]${COLOR_RESET}"
		read -r OPT
	fi

	if [[ $OPT = "R" ]]; then
		run_tests

		TMP_LOC=$(pwd)
		cd $DIR_TMP
		mkdir fernflower
		cd ./fernflower
		faster_clone
		cd plugins/java-decompiler/engine
		./gradlew build -x test
		cd $TMP_LOC

		cp ${DIR_TMP}/fernflower/plugins/java-decompiler/engine/build/libs/fernflower.jar ${DIR_BIN}/
		exit
	elif [[ $OPT = "B" ]]; then
		TMP_LOC=$(pwd)

		cd ${DIR_TMP}/fernflower/plugins/java-decompiler/engine
		./gradlew build -x test
		cd $TMP_LOC

		cp ${DIR_TMP}/fernflower/plugins/java-decompiler/engine/build/libs/fernflower.jar ${DIR_BIN}/
		exit
	fi
	exit

}


decompile () {

	if ! test -f ${DIR_BIN}fernflower.jar; then
		echo -e "${COLOR_RED}Decompiler is not installed yet${COLOR_RESET}"
		exit
	fi

	run_tests

	java -jar ${DIR_BIN}fernflower.jar $SERVER_JAR $DIR_DECOMPILED_JAR
	unzip $DIR_DECOMPILED_JAR/*.jar -d $DIR_DECOMPILED_JAR
	rm $DIR_DECOMPILED_JAR/*.jar

}



if [[ -n $1 ]]; then
    if [[ $1 = "install" ]] && [[ -n $2 ]] && [[ -n $3 ]] && [[ -n $4 ]]; then
    	# $2: directory the decompiler-script is called from
    	# $3: data directory path relative to location, the decompiler-script is called from
    	# $4: tmp-data directory path relative to location, the decompiler-script is called from
		# $5: decompilers directory path relative to location, the decompiler-script is called from

    	PWD=$2
    	DIR_TOOL=${PWD}/${3}
    	DIR_TMP=${PWD}/${4}
    	DIR_BIN=${DIR_TOOL}/decompilers/bin
    	install
    elif [[ $1 = "decompile" ]] && [[ -n $2 ]] && [[ -n $3 ]]  && [[ -n $4 ]]  && [[ -n $5 ]]; then
    	# $2: directory the decompiler-script is called from
		# $3: data directory path relative to location, the decompiler-script is called from
		# $4: absolute path of server-jar
		# $5: absolute path of the jar's decompiled directory
		# I do not know why I picked such a stupid implementation. Maybe some day I'll refactor it again

    	PWD=$2
    	DIR_TOOL=${PWD}/${3}
    	DIR_BIN=${DIR_TOOL}/decompilers/bin/
    	SERVER_JAR=$4
    	DIR_DECOMPILED_JAR=$5
		decompile        
    fi
fi
