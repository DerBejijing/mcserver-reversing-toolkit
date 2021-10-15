#!/bin/bash

DIR_SERVER_JAR=""
DIR_PATCHED_JAR=""

V01_17_01=https://download.getbukkit.org/spigot/spigot-1.17.1.jar
V01_17_00=https://download.getbukkit.org/spigot/spigot-1.17.jar

V01_16_05=https://cdn.getbukkit.org/spigot/spigot-1.16.5.jar
V01_16_04=https://cdn.getbukkit.org/spigot/spigot-1.16.4.jar
V01_16_03=https://cdn.getbukkit.org/spigot/spigot-1.16.3.jar
V01_16_02=https://cdn.getbukkit.org/spigot/spigot-1.16.2.jar
V01_16_01=https://cdn.getbukkit.org/spigot/spigot-1.16.1.jar

V01_15_02=https://cdn.getbukkit.org/spigot/spigot-1.15.2.jar
V01_15_01=https://cdn.getbukkit.org/spigot/spigot-1.15.1.jar
V01_15_00=https://cdn.getbukkit.org/spigot/spigot-1.15.jar

V01_14_04=https://cdn.getbukkit.org/spigot/spigot-1.14.4.jar
V01_14_03=https://cdn.getbukkit.org/spigot/spigot-1.14.3.jar
V01_14_02=https://cdn.getbukkit.org/spigot/spigot-1.14.2.jar
V01_14_01=https://cdn.getbukkit.org/spigot/spigot-1.14.1.jar
V01_14_00=https://cdn.getbukkit.org/spigot/spigot-1.14.jar

V01_13_02=https://cdn.getbukkit.org/spigot/spigot-1.13.2.jar
V01_13_01=https://cdn.getbukkit.org/spigot/spigot-1.13.1.jar
V01_13_00=https://cdn.getbukkit.org/spigot/spigot-1.13.jar

V01_12_02=https://cdn.getbukkit.org/spigot/spigot-1.12.2.jar
V01_12_01=https://cdn.getbukkit.org/spigot/spigot-1.12.1.jar
V01_12_00=https://cdn.getbukkit.org/spigot/spigot-1.12.jar

V01_11_02=https://cdn.getbukkit.org/spigot/spigot-1.11.2.jar
V01_11_01=https://cdn.getbukkit.org/spigot/spigot-1.11.1.jar
V01_11_00=https://cdn.getbukkit.org/spigot/spigot-1.11.jar

V01_10_02=https://cdn.getbukkit.org/spigot/spigot-1.10.2-R0.1-SNAPSHOT-latest.jar
V01_10_00=https://cdn.getbukkit.org/spigot/spigot-1.10-R0.1-SNAPSHOT-latest.jar

V01_09_04=https://cdn.getbukkit.org/spigot/spigot-1.9.4-R0.1-SNAPSHOT-latest.jar
V01_09_02=https://cdn.getbukkit.org/spigot/spigot-1.9.2-R0.1-SNAPSHOT-latest.jar
V01_09_00=https://cdn.getbukkit.org/spigot/spigot-1.9-R0.1-SNAPSHOT-latest.jar

V01_08_08=https://cdn.getbukkit.org/spigot/spigot-1.8.8-R0.1-SNAPSHOT-latest.jar
V01_08_07=https://cdn.getbukkit.org/spigot/spigot-1.8.7-R0.1-SNAPSHOT-latest.jar
V01_08_06=https://cdn.getbukkit.org/spigot/spigot-1.8.6-R0.1-SNAPSHOT-latest.jar
V01_08_05=https://cdn.getbukkit.org/spigot/spigot-1.8.5-R0.1-SNAPSHOT-latest.jar
V01_08_04=https://cdn.getbukkit.org/spigot/spigot-1.8.4-R0.1-SNAPSHOT-latest.jar
V01_08_03=https://cdn.getbukkit.org/spigot/spigot-1.8.3-R0.1-SNAPSHOT-latest.jar
V01_08_00=https://cdn.getbukkit.org/spigot/spigot-1.8-R0.1-SNAPSHOT-latest.jar

V01_07_10=https://cdn.getbukkit.org/spigot/spigot-1.7.10-SNAPSHOT-b1657.jar
V01_07_09=https://cdn.getbukkit.org/spigot/spigot-1.7.9-R0.2-SNAPSHOT.jar
V01_07_08=https://cdn.getbukkit.org/spigot/spigot-1.7.8-R0.1-SNAPSHOT.jar
V01_07_05=https://cdn.getbukkit.org/spigot/spigot-1.7.5-R0.1-SNAPSHOT-1387.jar
V01_07_02=https://cdn.getbukkit.org/spigot/spigot-1.7.2-R0.4-SNAPSHOT-1339.jar

V01_06_04=https://cdn.getbukkit.org/spigot/spigot-1.6.4-R1.1-SNAPSHOT.jar
V01_06_02=https://cdn.getbukkit.org/spigot/spigot-1.6.2-R1.1-SNAPSHOT.jar

V01_05_01=https://cdn.getbukkit.org/spigot/spigot-1.5.1-R0.1-SNAPSHOT.jar

V01_04_07=https://cdn.getbukkit.org/spigot/spigot-1.4.7-R1.1-SNAPSHOT.jar
V01_04_06=https://cdn.getbukkit.org/spigot/spigot-1.4.6-R0.4-SNAPSHOT.jar



VERSION=""



beautify_version () {
	SUPPLIED_VERSION=""

	version_array=$(echo $1 | grep -o .)
	for item in ${version_array[@]}; do
		if [ "$item" -eq "$item" ] 2>/dev/null || [[ $item = "." ]] || [[ $item = "_" ]]; then
			SUPPLIED_VERSION=${SUPPLIED_VERSION}${item}
		fi
	done

	VERSION_BUILDER="V"

	version_array=($(echo $SUPPLIED_VERSION | tr "." "\n"))
	for version_part in ${version_array[@]}; do
		version_part=${version_part//./}

		check_done="0"
		version_part_array=$(echo $version_part | grep -o .)
		for version_part_array_part in ${version_part_array[@]}; do
			if ! [[ $check_done = "0" ]]; then break; fi

			if [[ "$version_part_array_part" -eq "0" ]]; then
				version_part=${version_part/"0"/}
			else
				check_done="1"
			fi
		done

		if [[ "$version_part" -lt "10" ]]; then
			version_part="0"${version_part}
		fi

		if [[ $version_part = "0" ]]; then version_part="00"; fi

		if [[ $VERSION_BUILDER = "V" ]]; then
			VERSION_BUILDER=${VERSION_BUILDER}${version_part}
		else
			VERSION_BUILDER=${VERSION_BUILDER}_${version_part}
		fi
	done


	echo $VERSION_BUILDER

}



install () {

	VERSION=$(beautify_version $VERSION)

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
