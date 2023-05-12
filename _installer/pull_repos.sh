S_DIR=$(cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P)
cd $S_DIR

#--------------- game-and-watch-backup ----------------------------------------------
folder=game-and-watch-backup
#rm -r ./../$folder
if [ -d "./../$folder" ]; then
	cd ./../$folder
	git pull
	cd $S_DIR
else
    git clone https://github.com/ghidraninja/game-and-watch-backup.git ./../$folder
    cp -r ./resources/$folder/* ./../$folder/
fi


#--------------- game-and-watch-patch -----------------------------------------------
folder=game-and-watch-patch
#rm -r ./../$folder
if [ -d "./../$folder" ]; then
	cd ./../$folder
	git pull
	cd $S_DIR
else
    git clone https://github.com/BrianPugh/game-and-watch-patch.git ./../$folder
    cp -r ./resources/$folder/* ./../$folder/
fi


#--------------- game-and-watch-retro-go --------------------------------------------
folder=game-and-watch-retro-go
#rm -r ./../$folder
if [ -d "./../$folder" ]; then
	cd ./../$folder
	git pull
	cd $S_DIR
else
    git clone --recurse-submodules https://github.com/sylverb/game-and-watch-retro-go ./../$folder
    cp -r ./resources/$folder/* ./../$folder/
fi

#--------------- game-and-watch-zelda3 ----------------------------------------------
folder=game-and-watch-zelda3
#rm -r ./../$folder
if [ -d "./../$folder" ]; then
	cd ./../$folder
	git pull
	cd $S_DIR
else
    git clone --recurse-submodules https://github.com/marian-m12l/game-and-watch-zelda3.git ./../$folder
    cp -r ./resources/$folder/* ./../$folder/
fi