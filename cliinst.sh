#!/bin/bash

# Functions
install_fail () {
    printf "

***********************************************************************************

    The installation of AOSC OS has failed. Please file a bug to 
    
    ->      http://bugs.anthonos.org,

    or find one of our developers at #anthon.

***********************************************************************************

    \033[31m-> Press [Enter] to exit installation.\033[0m   "
    read -p ""
    exit
}

enter_to_continue () {
    printf "\033[36m    -> Press [Enter] to continue...\033[0m  "
    read -p ""
    clear
}

learn_more_pm () {
    printf "
    \033[1;34mDPKG\033[0m, or Debian Packages is the software at the base of the package management 
    system in the free operating system Debian and its numerous derivatives. \"dpkg\"
    is used to install, remove, and provide information about \".deb\" packages.
    DPKG is known for its use in Ubuntu. Generally speaking, DPKG is more newbie
    friendly as it uses a simpler structure of dependencies and is usually more 
    straight forward in dependency problem solving.
    In AOSC OS3, APT and PackageKit are the default frontends for managing DPKG-
    based system releases.

    \033[1;34mRPM\033[0m, or RedHad Package Manager is a package management system. 
    The name RPM variously refers to the .rpm file format, files in this format, 
    software packaged in such files, and the package manager itself. RPM was in-
    tended primarily for Linux distributions; the file format is the baseline 
    package format of the Linux Standard Base.
    RPM package management is famous for its specificity in library dependency 
    and its use in RHEL (Red Hat Enterprise Linux), Fedora, and openSUSE, et al. 
    Although RPM is usually more reliable as it detects dependency problems in-
    side of pacakges (unlike DPKG, which just reads package names), however, 
    this feature can bring in difficulties for new users.
    In AOSC OS3, Zypper and PackageKit are the default frontends for managing 
    RPM-based system releases.

    \033[1;32m!\033[0m    (Some contents were quoted from Wikipedia, and authors of article 
         titles in light blue)

    \033[1;32m*\033[0m  You might want to scroll up if you are using a smaller screen.
    "
}

learn_more_de () {
    printf "
    \033[1;34mGNOME\033[0m (pronounced /ɡˈnoʊm/ or /ˈnoʊm/) is a desktop environment which 
    is composed entirely of free and open-source software and targets to be 
    cross-platform, i.e. run on multiple operating systems, its main focus 
    being those based on the GNU/Linux system.
    \033[1;32m*\033[0m GNOME needs about 1GB RAM and a dual core processor to run smoothly.

    \033[1;34mCinnamon\033[0m is a GTK+ 3-based desktop environment. The project originally 
    started as a fork of the GNOME Shell, i.e. a mere graphical shell. 
    Cinnamon was initially developed by (and for) Linux Mint. 
    \033[1;32m*\033[0m Cinnamon needs about 1GB RAM and a dual core processor to run 
      smoothly.

    \033[1;34mMATE\033[0m (Spanish pronunciation: [ˈmate]) is a desktop environment forked 
    from the now-unmaintained code base of GNOME 2.
    \033[1;32m*\033[0m MATE needs about 512MB RAM to run smoothly.

    \033[1;34mXFCE\033[0m (pronounced as four individual letters ) is a free software desktop
    environment for Unix and Unix-like platforms, such as Linux, Solaris, 
    and BSD. It aims to be fast and lightweight, while still being visually 
    appealing and easy to use. It consists of separately packaged compo-
    nents that together provide the full functionality of the desktop envi-
    ronment, but can be selected in subsets to suit user needs and 
    preference. 
    \033[1;32m*\033[0m XFCE needs about 512MB RAM to run smoothly.

    \033[1;34mUnity\033[0m is a graphical shell for the GNOME desktop environment developed by
    Canonical Ltd. for its Ubuntu operating system. It was initially designed 
    to make more efficient use of space given the limited screen sizes.
    \033[1;32m*\033[0m Unity needs about 2GB RAM and a dual core processor to run smoothly.

    \033[1;34mKDE\033[0m is fully based on Qt technologies, and provides a significant range
    of FOSS (Free and Open Source Software) to sum up Plasma's complete 
    integrated experience. 
    \033[1;32m*\033[0m KDE needs more than 2GB of RAM, dual core processor, at least Intel HD
      Graphics (or equivalent), and about 10GB of HDD space to run.

    \033[1;34mKodi\033[0m, formerly known as XBMC (XBox Media Center), while maintaining a 
    small footprint, it's probably the most powerful media center solution 
    you can find in all of the UNIX/Linux computing world. 
    \033[1;32m*\033[0m A dedicated graphics card or decoder is recommended for Kodi.

    \033[1;32m!\033[0m    (Some contents were quoted from Wikipedia, and authors of article 
         titles in light blue; System requirements provided by 
         AOSC TechBase)

    \033[1;32m*\033[0m  You might want to scroll up if you are using a smaller screen.
"
}

learn_more_opt () {
    printf "
    \033[1;34mWine\033[0m, or Wine Is Not an Emulator is a free and open source compatibility 
    layer software application that aims to allow applications designed for 
    Microsoft Windows to run on Unix-like operating systems. Wine also 
    provides a software library, known as Winelib, against which developers
    can compile Windows applications to help port them to Unix-like 
    systems.
    \033[1;32m*\033[0m Installation size: 1.3GB.

    \033[1;34mGoogle Chrome\033[0m is a freeware web browser developed by Google. Added
    upon Chromium, from which it is based on, Google Chrome provides
    support for Flash, proprietary media formats, and connection to Google
    proprietary services.
    \033[1;32m*\033[0m Installation size: 183MB.

    \033[1;34mAOSC Artwork\033[0m is a collection of community provided wallpapers designed
    for use with AOSC OS (with no brandings).
    \033[1;32m*\033[0m Installation size: 89MB.

    \033[1;34mLibreOffice\033[0m is a free and open source office suite, developed by 
    The Document Foundation. It was forked from OpenOffice.org in 2010,
    which was an open-sourced version of the earlier StarOffice. The 
    LibreOffice suite comprises programs to do word processing, spread-
    sheets, slideshows, diagrams and drawings, maintain databases, and 
    compose mathematical formulae.
    \033[1;32m*\033[0m Installation size: 1019MB.

    \033[1;34mFcitx\033[0m ([ˈfaɪtɪks], Chinese: 小企鹅输入法) is an input method framework
    with extension support for X Window that supports multiple input 
    method engines for CJK language users.
    \033[1;32m*\033[0m Installation size: 41MB.

    \033[1;32m!\033[0m    (Some contents were quoted from Wikipedia, and authors of article 
         titles in light blue)

    \033[1;32m*\033[0m  You might want to scroll up if you are using a smaller screen.
    "
}

# PRE-INSTALLATION CLEAN-UP
rm /tmp/installation-config 
umount -Rf /mnt/target
unset OPTFEATURES

# DIRECTORY TREE CREATION
mkdir -p /mnt/target

clear

printf "***********************************************************************************

    \033[33mFellow Beta testers...\033[0m

    Firstly, a big thank you for choosing to test our newest system release.
    We are ready to take your issue reports so please feel free to file them 
    to our bug tracker, http://bugs.anthonos.org.

    AOSC OS developers

***********************************************************************************

"
enter_to_continue

printf "***********************************************************************************

    As of why you are using this CLI based installer instead of the fancy QtQuick 
    one, well sadly, as a matter of fact, we are not yet ready to ship it with our 
    LiveKit release. 

    This is a \033[1;31mtransitional\033[0m installer for our Beta testing.

    \033[1;36mBefore you start, make sure...\033[0m

    1.  You need a working (probably a fast one if you are impatient) 
        Internet connection for installation;
    2.  You will need a > 10GB partition for some desktop environment to be 
        installed (Hopefully we will fix this before the final debut);
    3.  Think twice before you proceed, this is a \033[1;31mBETA\033[0m release and 
        it probably contains multiple bugs that may affect your daily drive;

***********************************************************************************

"

enter_to_continue

printf "***********************************************************************************

    \033[1;36mSTOP I. Choose a Package Manager\033[0m

    AOSC OS supports DPKG and RPM as system package manager. \033[1;31mDPKG\033[0m and \033[1;31mRPM\033[0m now 
    provide equal support, they both now support PackageKit and all of its 
    graphical frontends. 

    * As of Beta 1, RPM builds did not ship with packagekit support.

***********************************************************************************

"

PS3=`printf "
\033[36m    -> Choose the package manager of your choice:   \033[0m"`
options=("DPKG (Debian Packages)" "RPM (RedHat Package Manager)" "Learn more about my choices..." "Quit")
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
        "Learn more about my choices...")
            learn_more_pm
            ;;
        *)
            printf "\033[1;31mHey! invalid choice!\033[0m\n"
            ;;
    esac
done

clear

printf "***********************************************************************************

    \033[1;36mSTOP II. Choose a Desktop Environment\033[0m

    AOSC OS provides multiple desktop environment by default, 
    choose one from below, and make good choices!

***********************************************************************************

"

PS3=`printf "
\033[36m    ->  Choose the desktop environment of your choice:  \033[0m"`
options=("GNOME" "Cinnamon" "MATE" "XFCE" "Unity" "KDE" "Kodi" "Learn more about my choices..." "Quit")
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
        "Kodi")
            echo DE=kodi >> /tmp/installation-config
            ;;
        "Learn more about my choices...")
            learn_more_de
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

printf "***********************************************************************************

    \033[1;36mSTOP III. Optional Features\033[0m

    AOSC OS tries to include best softwares with the system release, but sadly
    with some limitations like \033[1;31mlicensing for redistribution\033[0m and 
    \033[1;31minstalation sizes\033[0m, we were not able to include some 
    great softwares with our AOSC OS releases. But with help from the Internet, 
    you will be able to install them from our repository, and here below 
    is some of the best ones we were to offer.

***********************************************************************************

"

PS3=`printf "
\033[36m    -> Choose your option:   \033[0m"`
options=("Go on and choose the options." "Learn more about my choices..." "Quit")
select opt in "${options[@]}"
do
    case $opt in
        "Go on and choose the options.")
            break
            ;;
        "Learn more about my choices...")
            learn_more_opt
            ;;
        "Quit")
            exit
            ;;
        *)
            printf "\033[1;31mHey! invalid choice!\033[0m\n"
            ;;
    esac
done

features=("wine" "google-chrome" "aosc-artwork" "libreoffice" "fcitx" "Done")

menuitems() {
    echo "Avaliable options:"
    for i in ${!features[@]}; do
        printf "%3d%s) %s\n" $((i+1)) "${choices[i]:- }" "${features[i]}"
    done
    [[ "$msg" ]] && echo "$msg"; :
}

prompt="Enter an option (enter again to uncheck, press [ENTER] when done): "
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

printf "***********************************************************************************

    \033[1;36mSTOP IV. Target Customization\033[0m

    In this stop you will need to decide on your partition setup, filesystem 
    choice \033[1;31m(and not yet implemented user settings)\033[0m. Please get a cup of 
    coffee if you are feeling drowsynow. You would need to be extremely 
    cautious at this step, any changes that would be made here are 
    \033[1;31mnot amendable.\033[0m

***********************************************************************************

"

printf "\033[1;33m(!) Partition Decision\033[0m
Now, double click on the \"GParted\" icon on the desktop, \033[1;31mselect\033[0m and \033[1;31mformat\033[0m 
a partition you would want AOSC OS to be installed on.

"

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
a natural integer)\033[0m, followed by [ENTER].

"
read -p "    -> Partition device name: " TARGETPART
echo TARGETPART=$TARGETPART >> /tmp/installation-config

source /tmp/installation-config
if [ "$EFI" = "yes" ]; then
    printf "\nType the ESP device name /dev/sdxN \033[1;36m(x is an alphabetical letter, and N is 
a natural integer) \033[0m, followed by [ENTER]:

"
    read -p "    -> ESP device name: " ESP
    echo ESP=$ESP >> /tmp/installation-config
elif [ "$EFI" = "no" ]; then
    true
fi

echo ""
enter_to_continue

printf "***********************************************************************************

    \033[1;33mReady?\033[0m
    Now, you shall take a deep breath before we officially start
    the installation...

***********************************************************************************

"

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
       yes | chroot /mnt/target zypper install $OPTFEATURES 
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
printf "

********************************************************************************

Installation has successfully completed! Now we will perform some clean up. You may then
reboot your machine and jump right into your fresh installation of AOSC OS.

\033[36mDefault username is \033[33m\"aosc\"\033[36m, password is \033[33m\"anthon\"\033[36m
Default root password is \033[33m\"anthon\"\033[36m, although using sudo is recommended.\033[0m

********************************************************************************

"

enter_to_continue

pushd /mnt/target > /dev/null
umount -Rf dev proc sys
popd > /dev/null
umount -Rf /mnt/target

exit
