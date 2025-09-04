# Source: https://github.com/Arnau478/ytos/blob/master/scripts/iso.sh
rm -rf zig-cache/iso_root
mkdir -p zig-cache/iso_root
cp -v zig-out/bin/kernel zig-cache/iso_root/kernel.elf
cp -v limine.cfg limine/limine-bios.sys limine/limine-bios-cd.bin limine/limine-uefi-cd.bin zig-cache/iso_root
mkdir -p zig-cache/iso_root/EFI/BOOT
cp -v limine/BOOTX64.EFI zig-cache/iso_root/EFI/BOOT
cp -v limine/BOOTIA32.EFI zig-cache/iso_root/EFI/BOOT
xorriso -as mkisofs -b limine-bios-cd.bin -no-emul-boot -boot-load-size 4 -boot-info-table --efi-boot limine-uefi-cd.bin -efi-boot-part --efi-boot-image --protective-msdos-label zig-cache/iso_root -o Carolina.iso
limine/limine bios-install Carolina.iso
