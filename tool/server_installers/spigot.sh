#!/bin/bash

DIR_SERVER_JAR=""
DIR_PATCHED_JAR=""

V1_17_01=https://download.getbukkit.org/spigot/spigot-1.17.1.jar
V1_17_00=https://download.getbukkit.org/spigot/spigot-1.17.jar

V1_16_05=https://cdn.getbukkit.org/spigot/spigot-1.16.5.jar
V1_16_04=https://cdn.getbukkit.org/spigot/spigot-1.16.4.jar
V1_16_03=https://cdn.getbukkit.org/spigot/spigot-1.16.3.jar
V1_16_02=https://cdn.getbukkit.org/spigot/spigot-1.16.2.jar
V1_16_01=https://cdn.getbukkit.org/spigot/spigot-1.16.1.jar

V1_15_02=https://cdn.getbukkit.org/spigot/spigot-1.15.2.jar
V1_15_01=https://cdn.getbukkit.org/spigot/spigot-1.15.1.jar
V1_15_00=https://cdn.getbukkit.org/spigot/spigot-1.15.jar

V1_14_04=https://cdn.getbukkit.org/spigot/spigot-1.14.4.jar
V1_14_03=https://cdn.getbukkit.org/spigot/spigot-1.14.3.jar
V1_14_02=https://cdn.getbukkit.org/spigot/spigot-1.14.2.jar
V1_14_01=https://cdn.getbukkit.org/spigot/spigot-1.14.1.jar
V1_14_00=https://cdn.getbukkit.org/spigot/spigot-1.14.jar

V1_13_02=https://cdn.getbukkit.org/spigot/spigot-1.13.2.jar
V1_13_01=https://cdn.getbukkit.org/spigot/spigot-1.13.1.jar
V1_13_00=https://cdn.getbukkit.org/spigot/spigot-1.13.jar

V1_12_02=https://cdn.getbukkit.org/spigot/spigot-1.12.2.jar
V1_12_01=https://cdn.getbukkit.org/spigot/spigot-1.12.1.jar
V1_12_00=https://cdn.getbukkit.org/spigot/spigot-1.12.jar

V1_11_02=https://cdn.getbukkit.org/spigot/spigot-1.11.2.jar
V1_11_01=https://cdn.getbukkit.org/spigot/spigot-1.11.1.jar
V1_11_00=https://cdn.getbukkit.org/spigot/spigot-1.11.jar

V1_10_02=https://cdn.getbukkit.org/spigot/spigot-1.10.2-R0.1-SNAPSHOT-latest.jar
V1_10_00=https://cdn.getbukkit.org/spigot/spigot-1.10-R0.1-SNAPSHOT-latest.jar

V1_09_04=https://cdn.getbukkit.org/spigot/spigot-1.9.4-R0.1-SNAPSHOT-latest.jar
V1_09_02=https://cdn.getbukkit.org/spigot/spigot-1.9.2-R0.1-SNAPSHOT-latest.jar
V1_09_00=https://cdn.getbukkit.org/spigot/spigot-1.9-R0.1-SNAPSHOT-latest.jar

V1_08_08=https://cdn.getbukkit.org/spigot/spigot-1.8.8-R0.1-SNAPSHOT-latest.jar
V1_08_07=https://cdn.getbukkit.org/spigot/spigot-1.8.7-R0.1-SNAPSHOT-latest.jar
V1_08_06=https://cdn.getbukkit.org/spigot/spigot-1.8.6-R0.1-SNAPSHOT-latest.jar
V1_08_05=https://cdn.getbukkit.org/spigot/spigot-1.8.5-R0.1-SNAPSHOT-latest.jar
V1_08_04=https://cdn.getbukkit.org/spigot/spigot-1.8.4-R0.1-SNAPSHOT-latest.jar
V1_08_03=https://cdn.getbukkit.org/spigot/spigot-1.8.3-R0.1-SNAPSHOT-latest.jar
V1_08_00=https://cdn.getbukkit.org/spigot/spigot-1.8-R0.1-SNAPSHOT-latest.jar

V1_07_10=https://cdn.getbukkit.org/spigot/spigot-1.7.10-SNAPSHOT-b1657.jar
V1_07_09=https://cdn.getbukkit.org/spigot/spigot-1.7.9-R0.2-SNAPSHOT.jar
V1_07_08=https://cdn.getbukkit.org/spigot/spigot-1.7.8-R0.1-SNAPSHOT.jar
V1_07_05=https://cdn.getbukkit.org/spigot/spigot-1.7.5-R0.1-SNAPSHOT-1387.jar
V1_07_02=https://cdn.getbukkit.org/spigot/spigot-1.7.2-R0.4-SNAPSHOT-1339.jar

V1_06_04=https://cdn.getbukkit.org/spigot/spigot-1.6.4-R1.1-SNAPSHOT.jar
V1_06_02=https://cdn.getbukkit.org/spigot/spigot-1.6.2-R1.1-SNAPSHOT.jar

V1_05_01=https://cdn.getbukkit.org/spigot/spigot-1.5.1-R0.1-SNAPSHOT.jar

V1_04_07=https://cdn.getbukkit.org/spigot/spigot-1.4.7-R1.1-SNAPSHOT.jar
V1_04_06=https://cdn.getbukkit.org/spigot/spigot-1.4.6-R0.4-SNAPSHOT.jar


VERSION=""



# some day I might make this function correct wrong version IDs supplied by the user
beautify_version () {

	SUPPLIED_VERSION=$1
	echo $SUPPLIED_VERSION

}



install () {

	if ! [[ -v $VERSION ]]; then
		echo Version does not exist!
		exit
	fi

	rm ${DIR_SERVER_JAR}/*.jar
	rm -rf ${DIR_PATCHED_JAR}
	mkdir ${DIR_PATCHED_JAR}

	curl $URL ${!VERSION} -o ${DIR_SERVER_JAR}/server.jar
	
	cp ${DIR_SERVER_JAR}/server.jar ${DIR_PATCHED_JAR}/server.jar

}

if [[ -n $1 ]] && [[ -n $2 ]] && [[ -n $3 ]] && [[ -n $4 ]]; then
	PWD=$1
	DIR_PATCHED_JAR=${PWD}/$2
	DIR_SERVER_JAR=${PWD}/$3
	VERSION=$4
	install
fi
