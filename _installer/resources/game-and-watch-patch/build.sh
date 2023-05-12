run=1
[ -z "$1" ] && run="" #adapter
[ -z "$2" ] && run="" #system
[ -z "$3" ] && run="" #size_mb
[ -z "$4" ] && run="" #triple_boot
[ -z "$5" ] && run="" #clean_build

if [ ! -z "$run" ] 
then
	if [ $3 -ge 64 ]; then LARGE_FLASH=1; else LARGE_FLASH=0; fi
	echo "download sdk"
	make download_sdk
	if [ $5 -ge 1 ]; then make clean; fi
	if [ $4 -ge 1 ]; then triple_boot=--triple-boot; else triple_boot=; fi
	if [$3 -eq 4 ]; then #boot 4MB
		echo make PATCH_PARAMS="--device="$2" --no-la --no-sleep-images "$triple_boot"" LARGE_FLASH=$LARGE_FLASH ADAPTER=$1 flash
		make PATCH_PARAMS="--device="$2" --no-la --no-sleep-images "$triple_boot"" LARGE_FLASH=$LARGE_FLASH ADAPTER=$1 flash
	else
		
		echo make PATCH_PARAMS=\"--device=$2 $triple_boot\" LARGE_FLASH=$LARGE_FLASH ADAPTER=$1 flash
		make PATCH_PARAMS="--device="$2" "$triple_boot"" LARGE_FLASH=$LARGE_FLASH ADAPTER=$1 flash
	fi
else
	echo "missing parameters. Run with ./build.sh [pico|stlink] [mario|zelda] [4 ... 512]"
fi