#!/bin/bash

#NAME: fernflower
#RATE: good
#INST: fernflower.jar

DIR_DECOMPILERS=./decompilers
DIR_DECOMPILERS_BIN=${DIR_DECOMPILERS}/bin
DIR_SERVER_DECOMPILED=""

SERVER_JAR=""
TMP_DATA=./tmp_fernflower

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

	cd $DIR_DECOMPILERS

	echo -e "${COLOR_YELLOW}To my knowledge, it is not possible to clone only a part of a repository using git\nIf you have any Idea on how to solve this, I would appreciate any help :)${COLOR_RESET}"
	mkdir $TMP_DATA
	cd $TMP_DATA
	faster_clone
	cd plugins/java-decompiler/engine
	./gradlew build -x test
	cd ../../../../
	mv ${TMP_DATA}/plugins/java-decompiler/engine/build/libs/fernflower.jar  ../${DIR_DECOMPILERS_BIN}/fernflower.jar

	read -r -p "Do you want to keep the fernflower-decompiler-source? [y/n]" CONTINUE
	if [[ $CONTINUE =~ ^(no|n)$ ]]; then
		rm -rf $TMP_DATA
	fi

	cd ../

	if test -f "${DIR_DECOMPILERS_BIN}/fernflower.jar"; then
		echo -e "\n${COLOR_GREEN}Successfully installed the fernflower decompiler${COLOR_RESET}"
		exit 0
	fi

	echo -e "\n${COLOR_RED}Could not install fernflower decompiler${COLOR_RESET}"


}

run () {

	java -jar ${DIR_DECOMPILERS_BIN}/fernflower.jar $SERVER_JAR $DIR_SERVER_DECOMPILED	

}


if [[ -n $1 ]]; then
    if [[ $1 = "install" ]]; then
    	run_tests
        install
        exit 0
    elif [[ $1 = "run" ]]; then
        if [[ -n $2 ]]; then
        	if [[ -n $3 ]]; then
	        	SERVER_JAR=$2
	        	DIR_SERVER_DECOMPILED=$3
    	    	run_tests
        		run
        		exit 0
        	fi
        fi
    fi
fi

echo -e "${COLOR_RED}Something terrible happened${COLOR_RESET}"
exit -1
