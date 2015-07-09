#!/bin/bash
# OFFICAL INSTALLATION PROCESS
# Read the variables in installation-config
printf "Reading installation configuration..."
source /tmp/installation-config
printf "\t\t\t\033[1;32m[OK]\033[0m\n"

# Mount the partition
printf "Mounting target partition..."
mount $TARGETPART /mnt/target
if [ $? -ne 0 ]; then
    printf "\t\t\t\t\033[1;31m[FAILED]\033[0m\n"
    install_fail
else
    printf "\t\t\t\t\033[1;32m[OK]\033[0m\n"
fi

# For you lazy people who do not want to clean your partition...
printf "Making sure the partition is empty..."
rm -rf /mnt/target/*
printf "\t\t\t\033[1;32m[OK]\033[0m\n"

# Retrieve latest release
printf "Starting to download list of system releases...\t\t\033[1;36m[INFO]\033[0m\n"
pushd /tmp
axel -a http://mirrors.anthonos.org/os3-releases/LATEST_SYSTEM_TARBALLS
popd

# new code
if [ "$NETB" = "yes" ] then
    # Download the tarball
    printf "Starting to download the system release...\t\t\033[1;36m[INFO]\033[0m\n"
    pushd /mnt/target > /dev/null
    # Automatic mirror for the community.
    axel -a `grep $DE /tmp/LATEST_SYSTEM_TARBALLS | grep $PM`
    popd > /dev/null
    if [ $? -ne 0 ]; then
    	printf "\nStarting to download the system release...\t\t\033[1;31m[FAILED]\033[0m\n"
    	install_fail
    else
    	printf "\nStarting to download the system release...\t\t\033[1;32m[OK]\033[0m\n"
    fi
else
    #
    # Copy the tarball from the disk
    # But I don't know how, so ...
    #
fi
# ended

# Extract this buggar
printf "Unpacking the system image...\t\t\t\t\033[1;36m[INFO]\033[0m\n"
pushd /mnt/target > /dev/null
pv aosc-os3_"${DE}"-"${SYSREL}"_"${PM}"_en-US.tar.xz | tar xfJ -
popd > /dev/null
if [ $? -ne 0 ]; then
    printf "Unpacking the system image...\t\t\t\t\033[1;31m[FAILED]\033[0m\n"
    install_fail
else
    printf "Unpacking the system image...\t\t\t\t\033[1;32m[OK]\033[0m\n"
fi

# Prepare chroot
printf "Preparing system for chroot..."
pushd /mnt/target > /dev/null
cp /etc/resolv.conf etc/
mount --bind /dev dev
mount --bind /proc proc
mount --bind /sys sys
genfstab -p /mnt/target >> /mnt/target/etc/fstab
if [ "$EFI" = "yes" ]; then
    mkdir /mnt/target/efi
    mount $ESP /mnt/target/efi
else
    true
fi
popd > /dev/null
if [ $? -ne 0 ]; then
    printf "\t\t\t\t\033[1;31m[FAILED]\033[0m\n"
    install_fail
else
    printf "\t\t\t\t\033[1;32m[OK]\033[0m\n"
fi

# fc-cache ensure
printf "Regenerating system fontconfig cache..\t\t\t\033[1;36m[INFO]\033[0m\n"
fc-cache

# GRUB
printf "Configuring GRUB...\t\t\t\t\t\033[1;36m[INFO]\033[0m\n"
if [ "$EFI" = "no" ]; then
    chroot /mnt/target grub-install ${TARGETPART::-1}
elif [ "$EFI" = "yes" ]; then
    chroot /mnt/target grub-install --target=x86_64-efi --efi-directory=/efi --bootloader-id=AOSC-GRUB 
fi
chroot /mnt/target grub-mkconfig -o /boot/grub/grub.cfg
if [ $? -ne 0 ]; then
    printf "Configuring GRUB...\t\t\t\t\t\033[1;31m[FAILED]\033[0m\n"
    install_fail
else
    printf "Configuring GRUB...\t\t\t\t\t\033[1;32m[OK]\033[0m\n"
fi

clear

# DONE!
whiptail --title "AOSC OS Installation" --msgbox "Installation has successfully completed! Now we will perform some clean up. We will reboot your machine and jump right into your fresh installation of AOSC OS soon.

Default username is \"aosc\", password is \"anthon\"
Default root password is \"anthon\", although using sudo is recommended." 15 60

pushd /mnt/target > /dev/null
umount -Rf dev proc sys
popd > /dev/null
umount -Rf /mnt/target

whiptail --title "AOSC OS Installation" --msgbox "Please remove your installation media and press Enter to reboot"

reboot
exit
