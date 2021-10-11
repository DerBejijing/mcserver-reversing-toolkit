#!/bin/bash


JAR_FILES=($( find ${1} -name "*.jar" -type f ))
if [[ ${#JAR_FILES[@]} -eq 0 ]]; then
	echo ""
else
	echo ${JAR_FILES[0]}
fi
