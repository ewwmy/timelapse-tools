#!/bin/bash

# Timelapse script
# Generates a timelapse video in mp4 format from the set of images
# It automatically scales and crops files to fit into the needed resolution without any distortion
# 
# Uses: ffmpeg
# Version: 1.2
# Date: 2020-01-22
# Author: Andrew A. (andryx77@gmail.com)

##### Timelapse folder structure:
### /timelapse[N|DATE|ANYTHING_ELSE]
###   /src - The source images must be placed here. No other files allowed!
###   timelapse1.mp4 - Compiled timelapses will be placed at the one level with 'src'
###   timelapse2.mp4
###   timelapse3.mp4
###   ...

##### Most popular video formats with the 16:9 ratio
###												Resolution		Width		Height	Ratio
###		12K									11520x6480		11520		6480		1,777777778
###		8K Ultra HD (4320p)	7680x4320			7680		4320		1,777777778
###		5K (2880p)					5120x2880			5120		2880		1,777777778
###		4K Ultra HD (2160p)	3840x2160			3840		2160		1,777777778
###		2K									2560x1440			2560		1440		1,777777778
###		Full HD (1080p)			1920x1080			1920		1080		1,777777778
###		(768p)							1366x768			1366		768			1,778645833
###		HD (720p)						1280x720			1280		720			1,777777778
###		480p								854x480				854			480			1,779166667
###		360p								640x360				640			360			1,777777778

TIMELAPSE_DIR=$1
FILEMASK=$2
FORMAT=$3
FPS=$4
CROP=$5

if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ] || [ -z "$4" ] || [ -z "$5" ]; then
	echo "Usage: timelapse.sh <path> <filemask> <format:360p|480p|720p|768p|1080p|2K|4K|WIDTHxHEIGHT> <fps> <crop:top|middle|bottom>"
	echo "- path: root dir of the timelapse project which contains 'src' folder. The output video will be placed here."
	echo "- filemask: ffmpeg glob pattern, for ex. 'IMG_*.JPG' or 'Y*.jpg'"
	echo "- format: use the one of listed above or just WIDTHxHEIGHT, for ex. 1920x1440. Using predefined resolution is recommended for better compability."
	echo "- fps: frames per second in the output video, must be a positive integer, for ex. 30. It's recommended to use 20, 24, 30 or 60 for better compability."
	echo "- crop: defines which side of the frame (top|middle|bottom) will be used in the output video if the in and out ratio doesn't correspond of each other"
	exit 0
fi

# check if the main directory exists
if [ -d "$TIMELAPSE_DIR" ]; then

	# check if the 'src' subdirectory exists
	if [ -d "$TIMELAPSE_DIR/src" ]; then

		# getting the first image filename (for the future functionality)
		FIRST_IMAGE=`ls "$TIMELAPSE_DIR/src" | sort -n | head -1`

		# check if the first image filename is not empty and is the regular file
		if [ -n "$FIRST_IMAGE" ] && [ -f "$TIMELAPSE_DIR/src/$FIRST_IMAGE" ]; then

			# getting the width and height of the first image in 'src' directory
			IN_W=`exiftool -ImageWidth $TIMELAPSE_DIR/src/$FIRST_IMAGE | cut -d ":" -f 2 | xargs`
			IN_H=`exiftool -ImageHeight $TIMELAPSE_DIR/src/$FIRST_IMAGE | cut -d ":" -f 2 | xargs`

			EXIF_DATETIME=`exiftool -CreateDate $TIMELAPSE_DIR/src/$FIRST_IMAGE | cut -d ":" -f 2 | xargs``exiftool -CreateDate $TIMELAPSE_DIR/src/$FIRST_IMAGE | cut -d ":" -f 3 | xargs``exiftool -CreateDate $TIMELAPSE_DIR/src/$FIRST_IMAGE | cut -d ":" -f 4 | xargs``exiftool -CreateDate $TIMELAPSE_DIR/src/$FIRST_IMAGE | cut -d ":" -f 5 | xargs``exiftool -CreateDate $TIMELAPSE_DIR/src/$FIRST_IMAGE | cut -d ":" -f 6 | xargs`
			EXIF_DATE=`echo $EXIF_DATETIME | cut -d " " -f 1`
			EXIF_TIME=`echo $EXIF_DATETIME | cut -d " " -f 2`
			EXIF_DATETIME=`echo $EXIF_DATE"_"$EXIF_TIME`

			# getting the output resolution
			case "$FORMAT" in
				"360p" )
					RESOLUTION="640x360"
				;;

				"480p" )
					RESOLUTION="854x480"
				;;

				"720p" )
					RESOLUTION="1280x720"
				;;

				"768p" )
					RESOLUTION="1366x768"
				;;

				"1080p" )
					RESOLUTION="1920x1080"
				;;

				"2K" )
					RESOLUTION="2560x1440"
				;;

				"4K" )
					RESOLUTION="3840x2160"
				;;

				* )
					# otherwise, suppose the user means WIDTHxHEIGHT
					RESOLUTION=$FORMAT
				;;
			esac

			# getting the separate output sizes (for the ratio calculation in the crop filter)
			OUT_W=`echo $RESOLUTION | cut -d 'x' -f 1`
			OUT_H=`echo $RESOLUTION | cut -d 'x' -f 2`

			# getting the crop type
			case "$CROP" in
				"top" )
					CROP_Y_START="0"
				;;

				"middle" )
					CROP_Y_START="(in_h-out_h)/2"
				;;

				"bottom" )
					CROP_Y_START="in_h-out_h"
				;;

				* )
					# default crop type
					CROP_Y_START="(in_h-out_h)/2"
					CROP="middle"
				;;
			esac

			# TODO: Addition: Create/rename files using sequential file naming image###.jpg then use sequence wildcards like -i image%03d.jpg as input. Create Batch script for Windows.

			# generating the timelapse
			ffmpeg -r $FPS -f image2 -pattern_type glob -i "$TIMELAPSE_DIR/src/$FILEMASK" -filter:v "crop=in_w:in_h/($OUT_W/$OUT_H*in_h/in_w):0:$CROP_Y_START" -c:v libx264 -profile:v baseline -level 3.0 -pix_fmt yuv420p -s $RESOLUTION -q 0 "$TIMELAPSE_DIR/timelapse_"$EXIF_DATETIME"_"$RESOLUTION"x"$FPS"_"$CROP".mp4"

		else
			echo "The 'src' directory doesn't contain any matching files"
			exit 1
		fi
	else
		echo "Timelapse directory doesn't contain the 'src' subfolder"
		exit 1
	fi
else
	echo "Timelapse directory doesn't exist"
	exit 1
fi
