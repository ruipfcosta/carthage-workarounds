#!/bin/bash

DEFAULT_COMMAND="carthage update --no-use-binaries --platform iOS"
WORKING_DIR=$(pwd)

NORMAL='\033[0m'
RED='\033[0;31m'
GREEN='\033[0;32m'

function remember_dependency {
    # check if Cartfile exists
    if [ -f "$WORKING_DIR/Cartfile" ]; then
        # Cartfile exists but does not contain the dependency
        if ! grep -Fxq "$DEPENDENCY" "$WORKING_DIR/Cartfile" ; then
            echo -e "\n$DEPENDENCY" >> "$WORKING_DIR/Cartfile"
            printf "${GREEN}*** INFO: *** ${NORMAL}Dependency added to your Cartfile!\n"
        fi
    else
       echo $DEPENDENCY > $WORKING_DIR/Cartfile
       printf "${GREEN}*** INFO: *** ${NORMAL}Cartfile created!\n"
    fi
}

function cleanup {
    cd "$WORKING_DIR"

    if [ -d $TEMP_DIR ]; then
        rm -rf $TEMP_DIR    
    fi
    
    printf "${GREEN}*** INFO: *** ${NORMAL}Cleaning up the mess... done!\n"
    exit
}

# make sure all the mess is cleaned up on exit
trap cleanup EXIT

# parse input arguments
while [[ $# > 1 ]]
do
    key="$1"

    case $key in
        -d|--dependency)
        DEPENDENCY="$2"
        shift
        ;;
        -c|--command)
        COMMAND="$2"
        shift
        ;;
    esac
    shift
done

if [ -z "$DEPENDENCY" ]; then printf "${RED}*** ERROR: *** ${NORMAL}No dependency specified, use --dependency specify it.\n"
    exit 1
fi

if [ -z "$COMMAND" ]; then
    COMMAND=$DEFAULT_COMMAND
fi

# check if Carthage directory exists
if [ ! -d "Carthage" ]; then
    printf "${RED}*** ERROR: *** ${NORMAL}Carthage directory does not exist. Use 'carthage' instead.\n"
    exit 2
fi

printf "${GREEN}*** INFO: *** ${NORMAL}Building dependency ${GREEN}${DEPENDENCY}${NORMAL} with command ${GREEN}${COMMAND}${NORMAL}.\n"

# create temporary directory and move there
TEMP_DIR=$(date | md5).tmp
mkdir $TEMP_DIR
cd "$TEMP_DIR"

# create temporary Cartfile with the specified dependency
echo $DEPENDENCY > Cartfile

# execute the actual command
eval "$COMMAND"

if [ $? -eq 0 ]; then
    # merge new Carthage directory with the existing one
    rsync -a "Carthage/" "$WORKING_DIR/Carthage/"
    remember_dependency
    printf "${GREEN}*** INFO ***${NORMAL} Add the following to your project input files:\n\n"
    find . -name "*.framework" | sed "s/.\/Carthage/\$\{SRCROOT\}\/Carthage/g" | xargs echo "    $1"
    printf "\n"
else
    printf "${RED}*** ERROR: *** ${NORMAL}Command execution failed!\n"
    exit 3
fi
