#!/bin/bash

# Basic definitions.
SYSREL="beta2_obsidian"

# PRE-INSTALLATION CLEAN-UP
rm /tmp/installation-config 
umount -Rf /mnt/target
unset OPTFEATURES

# DIRECTORY TREE CREATION
mkdir -p /mnt/target

clear

install_fail () {
    printf "\nThe installation of AOSC OS has failed. Please file a bug to http://bugs.anthonos.org,
    or find one of our developers at #anthon.\n"
    read -p "Press [Enter] to exit installation."
    exit
}

enter_to_continue () {
    printf "\033[36m-> Press [Enter] to continue...\033[0m"
    read -p ""
    clear
}


echo "***********************************************************************************"
printf "\n\t\033[33mFellow Beta testers...\033[0m\n\n"
printf "\tFirstly, a big thank you for choosing to test our newest system release.
\tWe are ready to take your issue reports so please feel free to file them 
\tto our bug tracker, http://bugs.anthonos.org.\n"
printf "\n\n\tAOSC OS developers\n\n"
echo "***********************************************************************************"
printf "\n"
enter_to_continue

printf "As of why you are using this CLI based installer instead of the fancy QtQuick one,
well sadly, as a matter of fact for now, we are not yet ready to ship it with our 
LiveKit release. This is a \033[1;31mtransitional\033[0m installer for our Beta testing.\n\n"

printf "\033[1;37mBefore you start, make sure...\033[0m
1. You need a working (probably a fast one if you are impatient) Internet 
   connection for installation;
2. You will need a > 10GB partition for some desktop environment to be installed;
3. Think twice before you proceed, this is a \033[1;31mBETA\033[0m release and it probably 
   contains multiple bugs that may affect your daily drive;\n\n"

enter_to_continue

printf "\033[1;36mSTOP I. Choose a Package Manager\033[0m

AOSC OS supports DPKG and RPM as system package manager. \033[1;31mDPKG\033[0m and \033[1;31mRPM\033[0m now provide 
equal support, they both now support PackageKit and all of its graphical frontends. 

* As of Beta 1, RPM builds did not ship with packagekit support.\n\n"

PS3='Choose the package manager of your choice: '
options=("DPKG (Debian Packages)" "RPM (RedHat Package Manager)" "Quit")
select opt in "${options[@]}"
do
    case $opt in
        "DPKG (Debian Packages)")
            echo PM=dpkg >> /tmp/installation-config
            break
            ;;
        "RPM (RedHat Package Manager)")
            echo PM=rpm >> /tmp/installation-config
            break
            ;;
        "Quit")
            exit
            ;;
        *)
            printf "\033[1;31mHey! invalid choice!\033[0m\n"
            ;;
    esac
done

clear

printf "\033[1;36mSTOP II. Choose a Desktop Environment\033[0m

AOSC OS provides multiple desktop environment by default, choose one from below, and
make good choices!\n\n"

PS3='Choose the desktop environment of your choice: '
options=("GNOME" "Cinnamon" "MATE" "XFCE" "Unity" "KDE" "Quit")
select opt in "${options[@]}"
do
    case $opt in
        "GNOME")
            echo DE=gnome >> /tmp/installation-config
            break
            ;;
        "Cinnamon")
            echo DE=cinnamon >> /tmp/installation-config
            break
            ;;
        "XFCE")
            echo DE=xfce >> /tmp/installation-config
            break
            ;;
        "MATE")
            echo DE=mate >> /tmp/installation-config
            break
            ;;
        "Unity")
            echo DE=unity >> /tmp/installation-config
            break
            ;;
        "KDE")
            echo DE=kde >> /tmp/installation-config
            break
            ;;
        "Quit")
            exit
            ;;
        *)https://gi
            printf "\033[1;31mHey! invalid choice!\033[0m\n"
            ;;
    esac
done

clear

printf "\033[1;36mSTOP III. Optional Features\033[0m

AOSC OS tries to include best softwares with the system release, but sadly with some 
limitations like \033[1;31mlicensing for redistribution\033[0m and \033[1;31minstalation sizes\033[0m, we were not 
able to include some great softwares with our AOSC OS releases. But with help from 
the Internet, you will be able to install them from our repository, and here below 
is some of the best ones we were to offer.\n\n"

features=("wine" "google-chrome" "aosc-artwork" "libreoffice" "fcitx" "Done")

menuitems() {
    echo "Avaliable options:"
    for i in ${!features[@]}; do
        printf "%3d%s) %s\n" $((i+1)) "${choices[i]:- }" "${features[i]}"
    done
    [[ "$msg" ]] && echo "$msg"; :
}

prompt="Enter an option (enter again to uncheck, press RETURN when done): "
while menuitems && read -rp "$prompt" num && [[ "$num" ]]; do
    [[ "$num" != *[![:digit:]]* ]] && (( num > 0 && num <= ${#features[@]} )) || {
        msg="Invalid option: $num"; continue
    }
    if [ $num == ${#features[@]} ];then
      break
    fi
    ((num--)); msg="${features[num]} was ${choices[num]:+de}selected"
    sed -i '3,3 s/$/ '`echo ${features[num]}`'/' /tmp/installation-config
    [[ "${choices[num]}" ]] && choices[num]="" || choices[num]="x"
done

for i in ${!features[@]}; do
    echo OPTFEATURES\+=\"`[[ "${choices[i]}" ]] && printf " %s" "${features[i]}"`\" >> /tmp/installation-config
done

clear

printf "\033[1;36mSTOP IV. Target Customization\033[0m

In this stop you will need to decide on your partition setup, filesystem choice
\033[1;31m(and not yet implemented user settings)\033[0m. Please get a cup of coffee if
you are dizzy by now. You would need to be extremely cautious at this step, any
changes that would be made here are \033[1;31mnot amendable.\033[0m

\033[1;33m(!) Partition Decision\033[0m
Now, double click on the \"GParted\" icon on the desktop, \033[1;31mselect\033[0m and \033[1;31mformat\033[0m 
a partition you would want AOSC OS to be installed on.\n\n"

read -r -p "Are you using a EFI based system or GUID partition table? [y/N] " response
case $response in
    Y|y) 
        echo EFI=yes >> /tmp/installation-config
        ;;
    N|n)
        echo EFI=no >> /tmp/installation-config
        ;;
    *)
        printf "Invalid response!\n"
        ;;
esac

printf "\nType the partition device name /dev/sdxN \033[1;36m(x is an alphabetical letter, and N is 
a natural integer)\033[0m, followed by [ENTER].\n\n"
read -p "    -> Partition device name: " TARGETPART
echo TARGETPART=$TARGETPART >> /tmp/installation-config

source /tmp/installation-config
if [ "$EFI" = "yes" ]; then
    printf "\nType the ESP device name /dev/sdxN \033[1;36m(x is an alphabetical letter, and N is 
a natural integer) \033[0m, followed by [ENTER]:\n\n"
    read -p "    -> ESP device name: " ESP
    echo ESP=$ESP >> /tmp/installation-config
elif [ "$EFI" = "no" ]; then
    true
fi

echo ""
enter_to_continue

printf "\033[1;33mReady?\033[0m
Now, you shall take a deep breath before we officially starts the installation...\n\n"

enter_to_continue

clear

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

# Install optional features
printf "Installing optional features...\t\t\t\t\033[1;36m[INFO]\033[0m\n"
if [ "$PM" = "dpkg" ]; then
   if [ -z "$OPTFEATURES" ]; then
       true
   else
       chroot /mnt/target apt update --yes &&
       chroot /mnt/target apt install $OPTFEATURES --yes 
   fi
elif [ "$PM" = "rpm" ]; then
   if [ -z "$OPTFEATURES" ]; then
       true
   else    
       chroot /mnt/target zypper refresh &&
       chroot /mnt/target zypper install $OPTFEATURES 
   fi
fi
if [ $? -ne 0 ]; then
    printf "Installing optional features...\t\t\t\t\033[1;31m[FAILED]\033[0m\n"
    install_fail
else
    printf "Installing optional features...\t\t\t\t\033[1;32m[OK]\033[0m\n"
fi

# fc-cache ensure
printf "Regenerating system fontconfig cache..\t\t\t\033[1;36m[INFO]\033[0m\n"
fc-cache -v

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
printf "********************************************************************************\n
Installation has successfully completed! Now we will perform some clean up. You may then
reboot your machine and jump right into your fresh installation of AOSC OS.

\033[36mDefault username is "aosc", password is "anthon"
Default root password is "anthon", although using sudo is recommended.\033[0m
********************************************************************************\n"

enter_to_continue

pushd /mnt/target > /dev/null
umount -Rf dev proc sys
popd > /dev/null
umount -Rf /mnt/target

exit
