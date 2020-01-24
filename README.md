# Timelapse Tools

Shell scripts (bash) for generating and processing timelapses.  
More info (using, parameters) you can see in the particular script file.

## Restrictions
These scripts are distributed with no warranty. Please, read [LICENSE](./LICENSE) for more information.

## `timelapse.sh`

This script will generate video from the regular shots.

### Features
* free your mind from rememberring ffmpeg or using heavy video editors
* automatically crops the output video if the input and output ratio doesn't correspond of each other
* the result video is fully compatible (if predefined resolution used) with YouTube, Telegram, WhatsApp, Instagram etc.

### Requirements
* Linux OS (ffmpeg glob pattens aren't supported in Windows, see https://stackoverflow.com/a/31513542 for more information)
* `ffmpeg` utility installed.

### Usage

#### Preparing
1. Create directory for the timelapse with any name you want, e.g. `~/timelapse1`. The output videos will be saved here.
2. Create `src` directory in the main timelapse directory and put there your images you need to process (e.g. `~/timelapse1/src`). Don't put there any other files!
3. Run script with your specific parameters as described in the **Script parameters** section (you need to pass `~/timelapse1` as `path` parameter of script).
4. Enjoy a clear and magnificent timelapse video with the human-readable filename! :-)

#### Script overview

`timelapse.sh <path> <filemask> <format:360p|480p|720p|768p|1080p|2K|4K|WIDTHxHEIGHT> <fps> <crop:top|middle|bottom>`

#### Script parameters

* `path`: root dir of the timelapse project which contains `src` folder. The output video will be placed here
* `filemask`: ffmpeg `glob` pattern, for ex. 'IMG_\*.JPG' (for regular Canon EOS shots) or 'Y\*.jpg' (Xiaomi Yi Camera)
* `format`: use the one of listed above or just `WIDTHxHEIGHT`, for ex. `1920x1440`. Using predefined resolution is recommended for better compability. See
* `fps`: frames per second in the output video, must be a positive integer, for ex. `30`. It's recommended to use `20`, `24`, `30` or `60` for better compability
* `crop`: defines which side of the frame (`top`, `middle` or `bottom`) will be used in the output video if the in and out ratio doesn't correspond of each other.

### Most popular video formats with the 16:9 ratio recommended for using

Name                |   Resolution  |   Width |   Height  |   Ratio
--------------------|---------------|---------|-----------|--------------
12K								  |	  11520x6480  |   11520	|	  6480    |   1,777777778
8K Ultra HD (4320p) |   7680x4320		|   7680	|  	4320		|   1,777777778
5K (2880p)					|   5120x2880		|	  5120	|  	2880		|   1,777777778
4K Ultra HD (2160p) |   3840x2160		|  	3840	|  	2160		|   1,777777778
2K									|   2560x1440		|  	2560	|  	1440		|   1,777777778
Full HD (1080p)		  | 	1920x1080		|  	1920	|  	1080	  |	  1,777777778
(768p)						  |  	1366x768		|  	1366	|  	768		  |	  1,778645833
HD (720p)					  |  	1280x720		|  	1280	|  	720		  |	  1,777777778
480p							  |  	854x480			|  	854		|  	480		  |	  1,779166667
360p							  |  	640x360			|  	640		|  	360		  |	  1,777777778
