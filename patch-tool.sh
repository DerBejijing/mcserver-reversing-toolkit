
# UNDER CONSTRUCTION !!!!!!!
# working on initializing and creating files/directories

DIR_DATA=./data
DIR_SERVER=./server_jar
DIR_DECOMPILED=./decompiled
DIR_PATCHED=./patched_server
DIR_DECOMPILERS=./decompilers

FILETRACKER=${DIR_DATA}/files.txt
SERVER_ARGS=${DIR_DATA}/args.txt

SERVER_ORIGINAL=${DIR_SERVER}/spigot-1.16.5.jar
SERVER_PATCHED=${DIR_PATCHED}/spigot-1.16.5.jar

COLOR_RED='\033[0;31m'
COLOR_GREEN='\033[0;32m'
COLOR_LIGHT_BLUE='\033[1;34m'
COLOR_YELLOW='\033[1;33m'
COLOR_RESET='\033[0m'


patch_server () {

    echo -e "${COLOR_YELLOW}Patching Server...${COLOR_RESET}"
    
    LINES=$(wc -l <$FILETRACKER)
    if [[ $LINES -gt 0 ]]; then
        cd $DIR_DECOMPILED
        echo -e "\n${COLOR_YELLOW}Compiling... [${COLOR_RESET}"
        ERROR_FILES=("")


        # compile, if possible
        while read line; do
            echo -e "${COLOR_LIGHT_BLUE}${line}${COLOR_RESET}"
            {
                javac -cp "../${SERVER_ORIGINAL}" $line
            } || {
                ERROR_FILES+=($line)
            }
        done < ../${FILETRACKER}
        echo -e "${COLOR_YELLOW}... ] Done Compiling${COLOR_RESET}"


        # echo all non-compileable files
        if [[ ! ${#ERROR_FILES[@]} -eq 1 ]]; then

            echo -e "\n${COLOR_RED}The following files could not be compiled:${COLOR_RESET}"
            for file in "${ERROR_FILES[@]}"
            do
                echo -e "${COLOR_LIGHT_BLUE}$file${COLOR_RESET}"
            done
        fi


        # put all files in the jar that were compiled
        PATCHED_FILES=0
        echo -e "\n\n\n${COLOR_YELLOW}Patching server jar${COLOR_RESET}"
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
                NEXT_FILE=${NEXT_FILE//.java/.class}
                echo -e "${COLOR_LIGHT_BLUE}${NEXT_FILE}${COLOR_RESET}"
                jar -uf ../${SERVER_PATCHED} $NEXT_FILE
                ((PATCHED_FILES=PATCHED_FILES+1))
            fi
        done < ../${FILETRACKER}

        if [[ $PATCHED_FILES -eq 0 ]]; then
            echo -e "${COLOR_RED}No files have been packed${COLOR_RESET}"
        fi

        echo -e "${COLOR_YELLOW}... ] Done packing${COLOR_RESET}"


    else
        echo -e "${COLOR_RED}No files specified${COLOR_RESET}"
        exit -1
    fi

}


run_server () {

    echo -e "${COLOR_YELLOW}Running Server jar${COLOR_RESET}"
    {
        java -jar ${SERVER_PATCHED}
    } || {
        echo -e "${COLOR_RED}Server file not found${COLOR_RESET}"
        exit -1
    }

}

ínitialize () {

    echo -e "${COLOR_YELLOW}Initializing... [${COLOR_RESET}"

    if ! test -f "$FILETRACKER"; then
        echo -e "${COLOR_LIGHT_BLUE}${FILETRACKER}${COLOR_RESET}"
        touch $FILETRACKER
    fi

    if [[ ! -d "${DIR_DECOMPILED}" ]]; then
        echo -e "${COLOR_LIGHT_BLUE}${DIR_DECOMPILED}${COLOR_RESET}"
        mkdir $DIR_DECOMPILED
    fi

    if [[ ! -d "$DIR_PATCHED" ]]; then
        echo -e "${COLOR_LIGHT_BLUE}${DIR_PATCHED}${COLOR_RESET}"
        mkdir $DIR_PATCHED
    fi

    echo -e "${COLOR_YELLOW}... ] Done initializing${COLOR_RESET}"

}


print_help () {

    echo "Run with: $0 + [OPTION]"
    echo -e "\nOptions:"
    echo "h / ?: prints help menu"
    echo "i    : creates all initial files and directories. May delete existing stuff"
    echo "r    : runs the server"
    echo "p    : compiles all classes specified in files.txt"
    echo "pr   : compiles, then runs the server"

}


if [[ -n $1 ]]; then
    if [[ $1 = "?" ]]; then
        print_help
    elif [[ $1 = "h" ]]; then
        print_help    
    elif [[ $1 = "i" ]]; then
        ínitialize
    elif [[ $1 = "r" ]]; then
        run_server
    elif [[ $1 = "p" ]]; then
	    patch_server
    elif [[ $1 = "pr" ]]; then
        patch_server
        run_server
    else
	print_help
    fi
else
    print_help
fi
