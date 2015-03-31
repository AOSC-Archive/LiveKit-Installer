#!/bin/bash
# clinst.sh: Monkey script for AOSC LiveKit Installation
# vim: expandtab:tabstop=4:softtabstop=4:autoindent

# Gettext magic: bash --dump-po-strings $0 > ${0/sh/po}


# Pre-escaped Formatting
NOTE=$'\e[1;32m'
ITEM=$'\e[1;34m'
ERRO=$'\e[1;31m'
INFO=$'\e[1;36m'
AHEY=$'\e[1;33m'
NORM=$'\e[0m'
PROM=$'\e[36m'

# Functions
pad(){ local i; for ((i=0;i<$1;i++)); do echo -ne "${2:- }"; done; }
SEP="$(pad $((COLUMNS>120?120:COLUMNS)) '*')"
sep(){ echo "$SEP"; }
indprint(){ echo -e "$*" | fold -sw $(((COLUMNS>120?120:COLUMNS)-4)) | sed 's/^/  /g'; }
press_enter () { read -p "${PROM}    "$"-> Press [Enter] to continue...""${NORM}  "; }
block_info(){ sep; indprint "$*"; sep; echo; }
switch_prompt(){ PS3="${PROM}    -> $1   ${NORM}"; }

install_die () {
    block_info $"The installation of AOSC OS has failed. Please file a bug to http://bugs.anthonos.org, or find one of our developers at #anthon."
    press_enter
}

learn_more(){ [ "$1" ] || return 1; declare -n ptr="MORE_$1"; indprint "$ptr"; }

# Normalization: alias p="sed -e 's/^    //g' -e '"'s/!/\\x21/g'"
# Fscking verbose.

MORE_PM=$"
${ITEM}DPKG${NORM}, or Debian Packages is the software at the base of the package management system in the free operating system Debian and its numerous derivatives. \`dpkg' is used to install, remove, and provide information about \".deb\" packages.
DPKG is known for its use in Ubuntu. Generally speaking, DPKG is more newbie friendly as it uses a simpler structure of dependencies and is usually more straightforward in dependency problem solving.
In AOSC OS3, APT and PackageKit are the default frontends for managing DPKG-based system releases.

${ITEM}RPM${NORM}, or RedHad Package Manager is a package management system. The name RPM variously refers to the .rpm file format, files in this format, software packaged in such files, and the package manager itself. RPM was in-tended primarily for Linux distributions; the file format is the baseline 
package format of the Linux Standard Base. RPM package management is famous for its specificity in library dependency and its use in RHEL (Red Hat Enterprise Linux), Fedora, and openSUSE, et al. 
Although RPM is usually more reliable as it detects dependency problems in-side of pacakges (unlike DPKG, which just reads package names), however, this feature can bring in difficulties for new users.
In AOSC OS3, Zypper and PackageKit are the default frontends for managing 
RPM-based system releases.

${NOTE}\x21${NORM}  (Some contents were quoted from Wikipedia, and authors of article titles in light blue)

${NOTE}*${NORM}  You might want to scroll up if you are using a smaller screen.
"

MORE_DE=$"
${ITEM}GNOME${NORM} (pronounced /ɡˈnoʊm/ or /ˈnoʊm/) is a desktop environment which is composed entirely of free and open-source software and targets to be cross-platform, i.e. run on multiple operating systems, its main focus being those based on the GNU/Linux system. GNOME may provide better touchscreen support.
${NOTE}*${NORM} GNOME needs about 1GB RAM and a dual core processor to run smoothly.

${ITEM}Cinnamon${NORM} is a GTK+ 3-based desktop environment. The project originally started as a fork of the GNOME Shell, i.e. a mere graphical shell. Cinnamon was initially developed by (and for) Linux Mint. 
${NOTE}*${NORM} Cinnamon needs about 1GB RAM and a dual core processor to run 
  smoothly.

${ITEM}MATE${NORM} (Spanish pronunciation: [ˈmate]) is a desktop environment forked from the now-unmaintained code base of GNOME 2.
${NOTE}*${NORM} MATE needs about 512MB RAM to run smoothly.

${ITEM}XFCE${NORM} (pronounced as four individual letters ) is a free software desktop environment for Unix and Unix-like platforms, such as Linux, Solaris, and BSD. It aims to be fast and lightweight, while still being visually appealing and easy to use. It consists of separately packaged components that together provide the full functionality of the desktop envi-ronment, but can be selected in subsets to suit user needs and preference. 
${NOTE}*${NORM} XFCE needs about 512MB RAM to run smoothly.

${ITEM}Unity${NORM} is a graphical shell for the GNOME desktop environment developed by Canonical Ltd. for its Ubuntu operating system. It was initially designed to make more efficient use of space given the limited screen sizes.
${NOTE}*${NORM} Unity needs about 2GB RAM and a dual core processor to run smoothly.

${ITEM}KDE${NORM} is fully based on Qt technologies, and provides a significant range of FOSS (Free and Open Source Software) to sum up Plasma's complete 
integrated experience. KDE is more Windows7-like.
${NOTE}*${NORM} KDE needs more than 2GB of RAM, dual core processor, at least Intel HD Graphics (or equivalent), and about 10GB of HDD space to run.

${ITEM}Kodi${NORM}, formerly known as XBMC (XBox Media Center), while maintaining a small footprint, it's probably the most powerful media center solution you can find in all of the UNIX/Linux computing world. 
${NOTE}*${NORM} A dedicated graphics card or decoder is recommended for Kodi.

${NOTE}\x21${NORM}  (Some contents were quoted from Wikipedia, and authors of article titles in light blue; System requirements provided by AOSC TechBase)

${NOTE}*${NORM}  You might want to scroll up if you are using a smaller screen.
"

MORE_OPT=$"
${ITEM}Wine${NORM}, or Wine Is Not an Emulator is a free and open source compatibility layer software application that aims to allow applications designed for Microsoft Windows to run on Unix-like operating systems. Wine also provides a software library, known as Winelib, against which developers can compile Windows applications to help port them to Unix-like systems. 
${NOTE}*${NORM} Installation size: 1.3GB.

${ITEM}Google Chrome${NORM} is a freeware web browser developed by Google. Added upon Chromium, from which it is based on, Google Chrome provides support for Flash, proprietary media formats, and connection to Google proprietary services.
${NOTE}*${NORM} Installation size: 183MB.

${ITEM}AOSC Artwork${NORM} is a collection of community provided wallpapers designed for use with AOSC OS (with no brandings).
${NOTE}*${NORM} Installation size: 89MB.

${ITEM}LibreOffice${NORM} is a free and open source office suite, developed by The Document Foundation. It was forked from OpenOffice.org in 2010, which was an open-sourced version of the earlier StarOffice. The LibreOffice suite comprises programs to do word processing, spread-sheets, slideshows, diagrams and drawings, maintain databases, and compose mathematical formulae.
${NOTE}*${NORM} Installation size: 1019MB.

${ITEM}Fcitx${NORM} ([ˈfaɪtɪks], Chinese: 小企鹅输入法) is an input method framework with extension support for X Window that supports multiple input method engines for CJK language users.
${NOTE}*${NORM} Installation size: 41MB.

${NOTE}\x21${NORM} (Some contents were quoted from Wikipedia, and authors of article titles in light blue)

${NOTE}*${NORM} You might want to scroll up if you are using a smaller screen.
"

# PRE-INSTALLATION CLEAN-UP
umount -Rf /mnt/target
unset OPTFEATURES

# DIRECTORY TREE CREATION
mkdir -p /mnt/target

clear

block_info $"
\e[33mFellow Beta testers...${NORM}

Firstly, a big thank you for choosing to test our newest system release. We are ready to take your issue reports so please feel free to file them to our bug tracker, http://bugs.anthonos.org.

\tAOSC OS developers
"

press_enter

block_info $"
As of why you are using this CLI based installer instead of the fancy QtQuick one, well sadly, as a matter of fact, we are not yet ready to ship it with our LiveKit release. 

This is a ${ERRO}transitional${NORM} installer for our Beta testing.

${INFO}Before you start, make sure...${NORM}

1.  You need a working (probably a fast one if you are impatient) Internet connection for installation;
2.  You will need a > 10GB partition for some desktop environment to be installed (Hopefully we will fix this before the final debut);
3.  Think twice before you proceed, this is a ${ERRO}BETA${NORM} release and it probably contains multiple bugs that may affect your daily drive;
"

press_enter

block_info $"
${INFO}STOP I. Choose a Package Manager${NORM}

AOSC OS supports DPKG and RPM as system package manager. ${ERRO}DPKG${NORM} and ${ERRO}RPM${NORM} now provide equal support, they both now support PackageKit and all of its graphical frontends. 

${NOTE}*${NORM} As of Beta 1, RPM builds did not ship with packagekit support.
"

switch_prompt $"Choose the package manager of your choice:"
select opt in "DPKG (Debian Packages)" "RPM (RedHat Package Manager)" "Learn more about my choices..." "Quit"
do
    case $opt in
        "DPKG (Debian Packages)")
            echo PM=dpkg > /tmp/installation-config
            break
            ;;
        "RPM (RedHat Package Manager)")
            echo PM=rpm > /tmp/installation-config
            break
            ;;
        "Quit")
            exit
            ;;
        "Learn more about my choices...")
            learn_more PM
            ;;
        *)
            printf $"${ERRO}Hey! Invalid choice!${NORM}\n"
            ;;
    esac
done

clear

block_info $"
${INFO}STOP II. Choose a Desktop Environment${NORM}

AOSC OS provides multiple desktop environment by default, choose one from below, and make good choices!
"

switch_prompt $"Choose the desktop environment of your choice:"
select opt in "GNOME" "Cinnamon" "MATE" "XFCE" "Unity" "KDE" "Kodi" "Learn more about my choices..." "Quit"
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
            break
            ;;
        "Learn more about my choices...")
            learn_more DE
            ;;
        "Quit")
            exit
            ;;
        *)
            printf "${ERRO}Hey! invalid choice!${NORM}\n"
            ;;
    esac
done

clear

### START WHAT-THE-FUCK 0
# Anyone interested in fucking putting the choices inside select-case?
# You can have multiple choices if you don't use break.
# Make the `break' option for `End selecting'.
# Will post pseudo-code on commit comments.
block_info "
${INFO}STOP III. Optional Features${NORM}

AOSC OS tries to include best softwares with the system release, but sadly with some limitations like ${ERRO}licensing for redistribution${NORM} and ${ERRO}instalation sizes${NORM}, we were not able to include some great softwares with our AOSC OS releases. But with help from the Internet, you will be able to install them from our repository, and here below is some of the best ones we were to offer.
"

switch_prompt $"Choose your option:"
select opt in "Go on and choose the options." "Learn more about my choices..." "Quit" 
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
            printf "${ERRO}Hey! invalid choice!${NORM}\n"
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
### END WHAT-THE-FUCK 0

block_info "
${INFO}STOP IV. Target Customization${NORM}

In this stop you will need to decide on your partition setup, filesystem choice ${ERRO}(and not yet implemented user settings)${NORM}. Please get a cup of coffee if you are feeling drowsynow. You would need to be extremely cautious at this step, any changes that would be made here are ${ERRO}not amendable.${NORM}
"

printf $"${AHEY}(\x21) Partition Decision${NORM}
Now, double click on the \"GParted\" icon on the desktop, ${ERRO}select${NORM} and ${ERRO}format${NORM} a partition you would want AOSC OS to be installed on.
"

# Remember, your invalid response is not requesting a re-entry of the code.
while read -n 1 -rep $"Are you using a EFI based system or GUID partition table? [y/N] " -i EFI
do
    case "$EFI" in
        [Yy]|[Nn]) echo EFI=$EFI >> /tmp/installation-config ;;
        *) printf "Invalid response!\n" ;;
    esac
done

echo -e $"
Type the partition device name /dev/sdxN ${INFO}(x is an alphabetical letter, and N is 
a natural integer)${NORM}, followed by [ENTER].
"

switch_prompt $"Partition device name: "
read -p "$PS3" TARGETPART
echo TARGETPART=$TARGETPART >> /tmp/installation-config

if [ "$EFI" = "yes" ]; then
    echo -e $"
Type in the ESP device name /dev/sdxN ${INFO}(x is an alphabetical letter, and N is 
a natural integer) ${NORM}, followed by [ENTER]:
"
    switch_prompt $"ESP device name: "
    while read -p "$PS3" ESP; do
    [[ $ESP =~ /dev/sd[a-zA-Z]\d* ]] && echo ESP=$ESP >> /tmp/installation-config && break
    read -n 1 -i N -erp $"${ERRO}My regex don't know what it is. ${NORM}Force continue? [y/N]" esp_force
    [ "$esp_force" == y ] && break;
    done
fi

echo
press_enter

block_info "
${AHEY}Ready?${NORM}

Now, you shall take a deep breath before we officially start the installation...
"

press_enter

clear

# OFFICAL INSTALLATION PROCESS
# Read the variables in installation-config
### WHAT-THE-FUCK 1
# Why are we loading such thing.. We don't even need such a file (since we rm'ed the file in the beginning
# or echo foo > file.) Shall I split the script into 2 parts and add argument for loading different ones?
# So what the filesystem check do you thing you are writing?
printf "Reading installation configuration..."
source /tmp/installation-config
printf "\t\t\t${NOTE}[OK]${NORM}\n"

# Mount the partition
printf "Mounting target partition..."
mount $TARGETPART /mnt/target
if [ $? -ne 0 ]; then
    printf "\t\t\t\t${ERRO}[FAILED]${NORM}\n"
    install_die
else
    printf "\t\t\t\t${NOTE}[OK]${NORM}\n"
fi

# For you lazy people who do not want to clean your partition...
printf "Making sure the partition is empty..."
rm -rf /mnt/target/*
printf "\t\t\t${NOTE}[OK]${NORM}\n"

# Retrieve latest release
printf "Starting to download list of system releases...\t\t${INFO}[INFO]${NORM}\n"
pushd /tmp
# You have to add anthon/
axel -a http://mirrors.anthonos.org/anthon/os3-releases/LATEST_SYSTEM_TARBALLS
popd

# Download the tarball
printf "Starting to download the system release...\t\t${INFO}[INFO]${NORM}\n"
pushd /mnt/target > /dev/null
# Automatic mirror for the community.
axel -a `grep $DE /tmp/LATEST_SYSTEM_TARBALLS | grep $PM`
popd > /dev/null
if [ $? -ne 0 ]; then
    printf "\nStarting to download the system release...\t\t${ERRO}[FAILED]${NORM}\n"
    install_die
else
    printf "\nStarting to download the system release...\t\t${NOTE}[OK]${NORM}\n"
fi

# Extract this buggar
printf "Unpacking the system image...\t\t\t\t${INFO}[INFO]${NORM}\n"
pushd /mnt/target > /dev/null
pv aosc-os3_"${DE}"-"${SYSREL}"_"${PM}"_en-US.tar.xz | tar xfJ -
popd > /dev/null
if [ $? -ne 0 ]; then
    printf "Unpacking the system image...\t\t\t\t${ERRO}[FAILED]${NORM}\n"
    install_die
else
    printf "Unpacking the system image...\t\t\t\t${NOTE}[OK]${NORM}\n"
fi

# Prepare chroot
printf "Preparing system for chroot..."
pushd /mnt/target > /dev/null
cp /etc/resolv.conf etc/ &&
mount --bind /dev dev &&
mount --bind /proc proc &&
mount --bind /sys sys &&
genfstab -p /mnt/target >> /mnt/target/etc/fstab &&
if [ "$EFI" = "yes" ]; then
    mkdir /mnt/target/efi
    mount $ESP /mnt/target/efi
fi
if [ $? -ne 0 ]; then # popd almost never fails, baka.
    printf "\t\t\t\t${ERRO}[FAILED]${NORM}\n"
    install_die
else
    printf "\t\t\t\t${NOTE}[OK]${NORM}\n"
fi
popd > /dev/null

# Install optional features
printf "Installing optional features...\t\t\t\t${INFO}[INFO]${NORM}\n"
if [ "$PM" = "dpkg" ]; then
   if [ ! -z "$OPTFEATURES" ]; then
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
    printf "Installing optional features...\t\t\t\t${ERRO}[FAILED]${NORM}\n"
    install_die
else
    printf "Installing optional features...\t\t\t\t${NOTE}[OK]${NORM}\n"
fi

# fc-cache ensure
printf "Regenerating system fontconfig cache..\t\t\t${INFO}[INFO]${NORM}\n"
fc-cache

# GRUB
printf "Configuring GRUB...\t\t\t\t\t${INFO}[INFO]${NORM}\n"
if [ "$EFI" = "no" ]; then
    chroot /mnt/target grub-install ${TARGETPART::-1}
elif [ "$EFI" = "yes" ]; then
    chroot /mnt/target grub-install --target=x86_64-efi --efi-directory=/efi --bootloader-id=AOSC-GRUB 
fi
chroot /mnt/target grub-mkconfig -o /boot/grub/grub.cfg
if [ $? -ne 0 ]; then
    printf "Configuring GRUB...\t\t\t\t\t${ERRO}[FAILED]${NORM}\n"
    install_die
else
    printf "Configuring GRUB...\t\t\t\t\t${NOTE}[OK]${NORM}\n"
fi

clear

# DONE!
echo -e "

$SEP

Installation has successfully completed! Now we will perform some clean up. You may then
reboot your machine and jump right into your fresh installation of AOSC OS.

${PROM}Default username is \e[33m\"aosc\"${PROM}, password is \e[33m\"anthon\"${PROM}
Default root password is \e[33m\"anthon\"${PROM}, although using sudo is recommended.${NORM}

$SEP
"

press_enter

pushd /mnt/target > /dev/null
umount -Rf dev proc sys
popd > /dev/null
umount -Rf /mnt/target
# Everyone exits here unless you are sourcing the script. Again, what do you…
