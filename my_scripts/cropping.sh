#! /bin/bash

cropping_area() {
	# DETECT CROPPING AREA:

	# 1st redirect STDERR to STDOUT
	# 2nd Filter per autocrop:
	# 3rd use AWK to split by space and print the third

	CMD="HandBrakeCLI --scan -i ${1}"

	OUTPUT1=`${CMD} 2>&1 | grep 'autocrop:'| awk '/ / { print $3 }'`
	OUTPUT2=`${CMD} 2>&1 | grep 'size:'| awk '/ / { print $3 }'`

	TOP=`echo ${OUTPUT1} | awk -F'/' '{print $1}'`
	BOTTOM=`echo ${OUTPUT1} | awk -F'/' '{print $2}'`
	LEFT=`echo ${OUTPUT1} | awk -F'/' '{print $3}'`
	RIGHT=`echo ${OUTPUT1} | awk -F'/' '{print $4}'`

	WIDTH=`echo ${OUTPUT2} | awk -F'x' '{print $1}'`
	C_HEIGHT=`echo ${OUTPUT2} | awk -F'x' '{print $2}'`
	HEIGHT=`echo ${C_HEIGHT} | awk -F',' '{print $1}'`

	C_F=`expr $(expr ${WIDTH} - ${LEFT}) - ${RIGHT}`
	C_S=`expr $(expr ${HEIGHT} - ${TOP}) - ${BOTTOM}`

	CROP=`echo ${C_F}':'${C_S}':'${LEFT}':'${TOP}`
}

#detect the cropping area for the video file
cropping_area ${1}
echo "\n\n++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo ${CROP}" - "${1}${line}
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n\n"
