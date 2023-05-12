run=1
[ -z "$1" ] && run="" #adapter
[ -z "$2" ] && run="" #system
[ -z "$3" ] && run="" #size_mb

if [ ! -z "$run" ]; then
	
	if [ $3 -eq 4 ]; then #boot on 4MByte flash
		make -j8 INTFLASH_BANK=2 EXTFLASH_SIZE=1703936 EXTFLASH_OFFSET=868352 ADAPTER=$1 GNW_TARGET=$2 flash
	else
		if [ $3 -ge 64 ]; then LARGE_FLASH=1; else LARGE_FLASH=0; fi
		make -j8 INTFLASH_BANK=2 EXTFLASH_SIZE=2097152 EXTFLASH_OFFSET=4194304 GNW_TARGET=$2 flash ADAPTER=$1 LARGE_FLASH=%LARGE_FLASH
	fi
else
	echo "missing parameters. Run with ./build.sh [pico|stlink] [mario|zelda] [4 ... 512]"
fi