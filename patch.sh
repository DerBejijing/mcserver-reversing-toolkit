DIR_DATA=./data
DIR_SERVER=./server_jar
DIR_DECOMPILED=./decompiled
DIR_PATCHED=./patched_server

FILETRACKER=${DIR_DATA}/files.txt

CLASSPATH_JAR=""
PATCH_JAR=""
ERROR_FILES=("")

COLOR_RED='\033[0;31m'
COLOR_GREEN='\033[0;32m'
COLOR_LIGHT_BLUE='\033[1;34m'
COLOR_YELLOW='\033[1;33m'
COLOR_RESET='\033[0m'



get_path_depth () {

	echo $( echo "$1" | grep -o "/" | wc -l)

}


get_upwards_path () {

	TMP=""
	for i in $(seq $1); do
		TMP+="../"
	done
	echo "$TMP"

}


get_jar () {

	JAR_FILES=($( find ${1} -name "*.jar" -type f ))
	if [[ ${#JAR_FILES[@]} -eq 0 ]]; then
		echo ""
	else
		echo ${JAR_FILES[0]}
	fi

}


compile () {

	echo -e "${COLOR_YELLOW}Compiling... [${COLOR_RESET}"

    while read line; do
        echo -e "${COLOR_LIGHT_BLUE}${line}${COLOR_RESET}"
        {
        	echo 
            javac -cp $3 "${2}/$line"
        } || {
            ERROR_FILES+=($line)
        }
    done < $1
    echo -e "${COLOR_YELLOW}... ] Done Compiling${COLOR_RESET}"

}


patch () {
	# $1: filetracker
	# $2: dir_decompiled
	# $3: patch_jar

	CURRENTPATHDEPTH=$(get_path_depth "$2")
	WAY_BACK=$(get_upwards_path $CURRENTPATHDEPTH)

	cd $2

	PATCHED_FILES=0
    echo -e "${COLOR_YELLOW}Patching server jar${COLOR_RESET}"
    echo -e "${COLOR_YELLOW}Packing files... [${COLOR_RESET}"
    while read line; do
        #NEXT_FILE=${line//.java/.class}
        NEXT_FILE=$line
        CONTAINS=0

        for file in ${ERROR_FILES[@]}
        do
            if [[ $file = $NEXT_FILE ]]; then
                CONTAINS=1
            fi
        done

        if [[ $CONTAINS -eq 0 ]]; then
        	echo $(pwd)

            NEXT_FILE=${NEXT_FILE//.java/.class}
            echo -e "${COLOR_LIGHT_BLUE}${WAY_BACK}${2}/${NEXT_FILE}${COLOR_RESET}"
            jar -uf ${WAY_BACK}${3} ${WAY_BACK}${2}/${NEXT_FILE}
            ((PATCHED_FILES=PATCHED_FILES+1))
        fi
    done < ${WAY_BACK}${1}

	if [[ $PATCHED_FILES -eq 0 ]]; then
		echo -e "${COLOR_RED}No files have been packed${COLOR_RESET}"
	fi

	cd $WAY_BACK

    echo -e "${COLOR_YELLOW}... ] Done packing${COLOR_RESET}"

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


	CLASSPATH_JAR=$(get_jar ${DIR_SERVER})
	PATCH_JAR=$(get_jar ${DIR_PATCHED})

	if [[ $CLASSPATH_JAR = "" ]] || [[ $PATCH_JAR = "" ]]; then
		echo -e "${COLOR_RED}Missing jar files${COLOR_RESET}"
		echo -e "   classpath-jar: ${COLOR_RED}${CLASSPATH_JAR}${COLOR_RESET}"
		echo -e "   to-path-jar:   ${COLOR_RED}${PATCH_JAR}${COLOR_RESET}"
		echo -e "${COLOR_RED}Aborting${COLOR_RESET}"
		exit -1
	fi

	compile $FILETRACKER $DIR_DECOMPILED $CLASSPATH_JAR
	patch $FILETRACKER $DIR_DECOMPILED $PATCH_JAR
	

}


patch_server

