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

cd $1

for line in $(ls)
do
	#detect the cropping area for the video file
	cropping_area ${line}
	echo "\n\n++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
	echo ${CROP}" - "${1}${line}
	echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n\n"

	ffmpeg -y -i "${line}"  -map 0:1 -vn "vo_audiofile_tmp.wav"
	ffmpeg -y -i "${line}"  -pass 1 -an -threads 0 -vf crop="${CROP}" -c:v libx264 -bf 0 -qcomp 0.7 -g 15 -keyint_min 25 -refs 5 -flags +loop+mv4 -cmp 256 -coder 1 -me_range 16 -sc_threshold 40 -i_qfactor 0.71 -qmin 10 -qmax 51 -qdiff 4  -b:v 12M -pix_fmt yuv420p -subq 6 -me_method umh -partitions parti4x4+parti8x8+partp4x4+partp8x8+partb8x8 -refs 3 -trellis 1 -vsync 1 "${line}_no_audio.mp4"
	ffmpeg -y -i "${line}_no_audio.mp4" -i "vo_audiofile_tmp.wav" -c:v copy -c:a ac3 -b:a 192k -ar 44100 "${line}.mp4"
	mv ${line}.mp4 /work/work3/warn_trailers_done/
	rm vo_audiofile_tmp.wav
	rm ${line}_no_audio.mp4
	rm ffmpeg*
done
