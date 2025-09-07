# Source: https://github.com/Arnau478/ytos/blob/master/scripts/limine.sh
rm -rf limine
git clone https://github.com/limine-bootloader/limine.git limine --branch=v5.x-branch-binary --depth=1 
make -C limine
