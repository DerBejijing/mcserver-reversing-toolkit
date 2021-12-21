#!/bin/bash

DIR_SERVER_JAR=""
DIR_PATCHED_JAR=""

V01_18_01=125e5adf40c659fd3bce3e66e67a16bb49ecc1b9
V01_18_00=3cf24a8694aca6267883b17d934efacc5e44440d

V01_17_01=a16d67e5807f57fc4e550299cf20226194497dc2
V01_17_00=0a269b5f2c5b93b1712d0f5dc43b6182b9ab254e

V01_16_05=1b557e7b033b583cd9f66746b7a9ab1ec1673ced
V01_16_04=35139deedbd5182953cf1caa23835da59ca3d7cd
V01_16_03=f02f4473dbf152c23d7d484952121db0b36698cb
V01_16_02=c5f6fb23c3876461d46ec380421e42b289789530
V01_16_01=a412fd69db1f81db3f511c1463fd304675244077
V01_16_00=a0d03225615ba897619220e256a266cb33a44b6b

V01_15_02=bb2b6b1aefcd70dfd1892149ac3a215f6c636b07
V01_15_01=4d1826eebac84847c71a77f9349cc22afd0cf0a1
V01_15_00=e9f105b3c5c7e85c7b445249a93362a22f62442d

V01_14_04=3dc3d84a581f14691199cf6831b71ed1296a9fdf
V01_14_03=d0d0fe2b1dc6ab4c65554cb734270872b72dadd6
V01_14_02=808be3869e2ca6b62378f9f4b33c946621620019
V01_14_01=ed76d597a44c5266be2a7fcd77a8270f1f0bc118
V01_14_00=f1a0073671057f01aa843443fef34330281333ce

V01_13_02=3737db93722a9e39eeada7c27e7aca28b144ffa7
V01_13_01=fe123682e9cb30031eae351764f653500b7396c9
V01_13_00=d0caafb8438ebd206f99930cfaecfa6c9a13dca0

V01_12_02=886945bfb2b978778c3a0288fd7fab09d315b25f
V01_12_01=561c7b2d54bae80cc06b05d950633a9ac95da816
V01_12_00=8494e844e911ea0d63878f64da9dcc21f53a3463

V01_11_02=f00c294a1576e03fddcac777c3cf4c7d404c4ba4
V01_11_01=1f97bd101e508d7b52b3d6a7879223b000b5eba0
V01_11_00=48820c84cb1ed502cb5b2fe23b8153d5e4fa61c0

V01_10_02=3d501b23df53c548254f5e3f66492d178a48db63
V01_10_01=cb4c6f9f51a845b09a8861cdbe0eea3ff6996dee
V01_10_00=a96617ffdf5dabbb718ab11a9a68e50545fc5bee

V01_09_04=edbb7b1758af33d365bf835eb9d13de005b1e274
V01_09_03=8e897b6b6d784f745332644f4d104f7a6e737ccf
V01_09_02=2b95cc7b136017e064c46d04a5825fe4cfa1be30
V01_09_01=bf95d9118d9b4b827f524c878efd275125b56181
V01_09_00=b4d449cf2918e0f3bd8aa18954b916a4d1880f0d

V01_08_09=b58b2ceb36e01bcd8dbf49c8fb66c55a9f0676cd
V01_08_08=5fafba3f58c40dc51b5c3ca72a98f62dfdae1db7
V01_08_07=35c59e16d1f3b751cd20b76b9b8a19045de363a9
V01_08_06=2bd44b53198f143fb278f8bec3a505dad0beacd2
V01_08_05=ea6dd23658b167dbc0877015d1072cac21ab6eee
V01_08_04=dd4b5eba1c79500390e0b0f45162fa70d38f8a3d
V01_08_03=163ba351cb86f6390450bb2a67fafeb92b6c0f2f
V01_08_02=a37bdd5210137354ed1bfe3dac0a5b77fe08fe2e
V01_08_01=68bfb524888f7c0ab939025e07e5de08843dac0f
V01_08_00=a028f00e678ee5c6aef0e29656dca091b5df11c7

V01_07_10=952438ac4e01b4d115c5fc38f891710c4941df29
V01_07_09=4cec86a928ec171fdc0c6b40de2de102f21601b5
V01_07_08=c69ebfb84c2577661770371c4accdd5f87b8b21d
V01_07_07=a6ffc1624da980986c6cc12a1ddc79ab1b025c62
V01_07_06=41ea7757d4d7f74b95fc1ac20f919a8e521e910c
V01_07_05=e1d557b2e31ea881404e41b05ec15c810415e060
V01_07_04=61220311cef80aecc4cd8afecd5f18ca6b9461ff
V01_07_03=707857a7bc7bf54fe60d557cca71004c34aa07bb
V01_07_02=3716cac82982e7c2eb09f83028b555e9ea606002

# why does subl mark these in a different color??
V01_06_04=050f93c1f3fe9e2052398f7bd6aca10c63d64a87
V01_06_02=01b6ea555c6978e6713e2a2dfd7fe19b1449ca54
V01_06_01=0252918a5f9d47e3c6eb1dfec02134d1374a89b4

V01_05_02=f9ae3f651319151ce99a0bfad6b34fa16eb6775f
V01_05_01=d07c71ee2767dabb79fb32dad8162e1b854d5324

V01_04_07=2f0ec8efddd2f2c674c77be9ddb370b727dec676
V01_04_06=a0aeb5709af5f2c3058c1cf0dc6b110a7a61278c
V01_04_05=c12fd88a8233d2c517dbc8196ba2ae855f4d36ea
V01_04_04=4215dcadb706508bf9d6d64209a0080b9cee9e71
V01_04_02=5be700523a729bb78ef99206fb480a63dcd09825

V01_03_02=3de2ae6c488135596e073a9589842800c9f53bfe
V01_03_01=82563ce498bfc1fc8a2cb5bf236f7da86a390646

V01_02_05=d8321edc9470e56b8ad5c67bbd16beba25843336


VERSION=V1_17_01



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

	URL_pt1=https://launcher.mojang.com/v1/objects/
	URL_pt2=${!VERSION}/
	URL_pt3=server.jar

	URL=${URL_pt1}${URL_pt2}${URL_pt3}
	curl $URL -o $DIR_SERVER_JAR/server.jar
	cp ${DIR_SERVER_JAR}/server.jar ${DIR_PATCHED_JAR}/server.jar

}


if [[ -n $1 ]] && [[ -n $2 ]] && [[ -n $3 ]] && [[ -n $4 ]]; then
	PWD=$1
	DIR_PATCHED_JAR=${PWD}/$2
	DIR_SERVER_JAR=${PWD}/$3
	VERSION=$4
	install
fi
