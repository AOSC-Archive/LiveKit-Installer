#!/bin/bash
# clinst.sh: Monkey script for AOSC LiveKit Installation
# vim: expandtab:tabstop=4:softtabstop=4:autoindent

# Too lazy to copypasta. Notes on Gettext in that file.
. "$(dirname "$0")/cliinst-base" || ! echo "Base library not found. Quit." || exit 1
# Normalization: alias p="sed -e 's/^    //g' -e '"'s/!/\\x21/g'"
# Fscking verbose.
MORE_PM=$"
${ITEM}DPKG${NORM}, or Debian Packages is the software at the base of the package management system in the free operating system Debian and its numerous derivatives. \`dpkg' is used to install, remove, and provide information about \".deb\" packages.
DPKG is known for its use in Ubuntu. Generally speaking, DPKG is more newbie friendly as it uses a simpler structure of dependencies and is usually more straightforward in dependency problem solving.
In AOSC OS3, APT and PackageKit are the default frontends for managing DPKG-based system releases.

${ITEM}RPM${NORM}, or RedHad Package Manager is a package management system. The name RPM variously refers to the .rpm file format, files in this format, software packaged in such files, and the package manager itself. RPM was in-tended primarily for Linux distributions; the file format is the baseline package format of the Linux Standard Base. RPM package management is famous for its specificity in library dependency and its use in RHEL (Red Hat Enterprise Linux), Fedora, and openSUSE, et al. 
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

# State checking
if [ -r $config ]; then
    echo $"Saved installation config file found!"
    echo $"If you want to continue with the config, press ENTER."
    echo $"Else press C-c and run \`cliinst-do' in your shell instead."
    press_enter
fi

# PRE-INSTALLATION CLEAN-UP
mv $config $config.$(date +%s)
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
select opt in $"DPKG (Debian Packages)" $"RPM (RedHat Package Manager)" $"Learn more about my choices..." $"Quit"
do
    case $opt in
        $"DPKG (Debian Packages)") select_save PM dpkg;;
        $"RPM (RedHat Package Manager)") select_save PM rpm;;
        $"Quit") exit;;
        $"Learn more about my choices...") learn_more PM;;
        *) invalid_choice;;
    esac
done

clear

block_info $"
${INFO}STOP II. Choose a Desktop Environment${NORM}

AOSC OS provides multiple desktop environment by default, choose one from below, and make good choices!
"

switch_prompt $"Choose the desktop environment of your choice:"
select opt in "GNOME" "Cinnamon" "MATE" "XFCE" "Unity" "KDE" "Kodi" $"Learn more about my choices..." $"Quit"
do
    case $opt in
        GNOME|Cinnamon|XFCE|MATE|KDE|Unity|Kodi) select_save DE $opt;;
        $"Learn more about my choices...") learn_more DE;;
        $"Quit") exit;;
        *) invalid_choice;;
    esac
done

clear

### START WHAT-THE-FUCK 0
# Anyone interested in fucking putting the choices inside select-case?
# You can have multiple choices if you don't use break.
# Make the `break' option for `End selecting'.
# Will post pseudo-code on commit comments.
### WTF-0 Test TODO
block_info $"
${INFO}STOP III. Optional Features${NORM}

AOSC OS tries to include best softwares with the system release, but sadly with some limitations like ${ERRO}licensing for redistribution${NORM} and ${ERRO}instalation sizes${NORM}, we were not able to include some great softwares with our AOSC OS releases. But with help from the Internet, you will be able to install them from our repository, and here below is some of the best ones we were to offer.
"

switch_prompt $"Choose your optional packages:"
select opt in Wine LibreOffice $"AOSC Artwork" $"Fcitx Chinese Input" "Google Chrome" $"That's All." $"Learn more about my choices..." $"Quit"
do
    case $opt in
        Wine|LibreOffice|$"AOSC Artwork"|$"Fcitx Chinese Input"|"Google Chrome")
            opttoggle "$opt" "Wine LibreOffice"\ \'$"AOSC Artwork"\'\ \'$"Fcitx Chinese Input"\'\ \'"Google Chrome"\' \
                'wine libreoffice aosc-artwork fcitx google-chrome'
            ;;
        $"That's All.") break;;
        $"Learn more about my choices...") learn_more OPT;;
        $"Quit") exit;;
        *) invalid_choice;;
    esac
    echo $"Selected $OPTPAKS."
done

var_save OPTPAKS "$OPTPAKS"

clear
### END WHAT-THE-FUCK 0

block_info $"
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
        [Yy]|[Nn]) select_save EFI "$EFI";;
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
exec cliinst_do "$@"
