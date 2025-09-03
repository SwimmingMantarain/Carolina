# Source: https://github.com/Arnau478/ytos/blob/master/scripts/limine.sh
echo ""
qemu-system-x86_64 -M q35 -m 4G -cdrom Carolina.iso -boot d -debugcon stdio
