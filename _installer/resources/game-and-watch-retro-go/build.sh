run=1
[ -z "$1" ] && run="" #adapter
[ -z "$2" ] && run="" #system
[ -z "$3" ] && run="" #size_mb
[ -z "$4" ] && run="" #triple_boot
[ -z "$5" ] && run="" #clean_build

if [ ! -z "$run" ]; then
	size=$3 
	if [ $5 -ge 1 ]; then make clean; fi
	if [ $4 -ge 1 ]; then
		if [ $size -eq 4 ]; then #triple boot 4MB
			echo make -j8 GNW_TARGET=$2 INTFLASH_ADDRESS=0x08020000 EXTFLASH_SIZE=1622016 EXTFLASH_OFFSET=2572288  ADAPTER=$1 BIG_BANK=0 flash
			make -j8 GNW_TARGET=$2 INTFLASH_ADDRESS=0x08020000 EXTFLASH_SIZE=1622016 EXTFLASH_OFFSET=2572288  ADAPTER=$1 BIG_BANK=0 flash
		else 
			((size=size-6))
			echo make -j8 GNW_TARGET=$2 INTFLASH_ADDRESS=0x08020000 EXTFLASH_SIZE_MB=$size EXTFLASH_OFFSET=6291456  ADAPTER=$1 BIG_BANK=0 flash
			make -j8 GNW_TARGET=$2 INTFLASH_ADDRESS=0x08020000 EXTFLASH_SIZE_MB=$size EXTFLASH_OFFSET=6291456  ADAPTER=$1 BIG_BANK=0 flash
		fi
	else
		if [ $size -eq 4 ]; then #dual boot 4MB
			echo make -j8 GNW_TARGET=$2 INTFLASH_BANK=2 EXTFLASH_SIZE=3325952 EXTFLASH_OFFSET=868352 COVERFLOW=1 ADAPTER=$1 flash
			make -j8 GNW_TARGET=$2 INTFLASH_BANK=2 EXTFLASH_SIZE=3325952 EXTFLASH_OFFSET=868352 COVERFLOW=1 ADAPTER=$1 flash
		else 
			((size=size-4))
			echo make -j8 GNW_TARGET=$2 INTFLASH_BANK=2 EXTFLASH_SIZE_MB=$size EXTFLASH_OFFSET=4194304 COVERFLOW=1 ADAPTER=$1 flash
			make -j8 GNW_TARGET=$2 INTFLASH_BANK=2 EXTFLASH_SIZE_MB=$size EXTFLASH_OFFSET=4194304 COVERFLOW=1 ADAPTER=$1 flash
		fi
	fi
else
	echo "missing parameters. Run with ./build.sh [pico|stlink] [mario|zelda] [4 ... 512] [0|1]"
fi