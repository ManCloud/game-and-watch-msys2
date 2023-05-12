echo ""> ./run_again.txt
pacman -Syuu --noconfirm
pacman -S python mingw-w64-x86_64-python-lz4 mingw-w64-x86_64-python-pillow mingw-w64-x86_64-python-tqdm mingw-w64-x86_64-python-yaml mingw-w64-x86_64-python-pyzopfli mingw-w64-x86_64-python-pyelftools mingw-w64-x86_64-python-pycryptodome mingw-w64-x86_64-python-keystone mingw-w64-x86_64-python-colorama mingw-w64-x86_64-python-numpy --noconfirm
pacman -S mingw-w64-x86_64-arm-none-eabi-toolchain --noconfirm
pacman -S make --noconfirm
pacman -S git --noconfirm
pacman -S mingw-w64-x86_64-openocd --noconfirm
pacman -S mingw-w64-x86_64-SDL2 --noconfirm

rm /mingw64/bin/openocd.exe
cp ./resources/openocd.exe /mingw64/bin/openocd.exe
rm ./run_again.txt