#!/usr/bin/ruby
# ============================================================
#  CUI Install (Ruby version, offline install option hasn't support yet)
#  2015.7 bobcao3 AOSC
# ============================================================

def install_fail
`whiptail --title "AOSC OS Installation" --msgbox "The installation is failed .." 10 60 3>&1 1>&2 2>&3`
exit
end

# ============================================================

def install_end
`whiptail --title "AOSC OS Installation" --msgbox "The installation is ended" 10 60 3>&1 1>&2 2>&3`
exit
end

# ============================================================

def check
	if $? != 0 then
    	puts "[FAILED]"
    	install_fail
	else
    	puts "[OK]"
	end
end

# ============================================================

def enter_to_continue
`whiptail --title "AOSC OS Installation" --msgbox "Press enter to continue" 10 60 3>&1 1>&2 2>&3`
end

# ============================================================

def pre_install
`umount -Rf /mnt/target
mkdir -p /mnt/target`
end

# ============================================================

def learn_more_pm
`whiptail --title "AOSC OS Installation" --scrolltext "DPKG, or Debian Packages is the software at the base of the package management system in the free operating system Debian and its numerous derivatives. dpkg is used to install, remove, and provide information about \".deb\" packages.
DPKG is known for its use in Ubuntu. Generally speaking, DPKG is more newbie friendly as it uses a simpler structure of dependencies and is usually more straight forward in dependency problem solving.
In AOSC OS3, APT and PackageKit are the default frontends for managing DPKG-based system releases.
RPM, or RedHad Package Manager is a package management system. 
The name RPM variously refers to the .rpm file format, files in this format, software packaged in such files, and the package manager itself. RPM was intended primarily for Linux distributions; the file format is the baseline package format of the Linux Standard Base.
RPM package management is famous for its specificity in library dependency and its use in RHEL (Red Hat Enterprise Linux), Fedora, and openSUSE, et al. 
Although RPM is usually more reliable as it detects dependency problems inside of pacakges (unlike DPKG, which just reads package names), however, this feature can bring in difficulties for new users.
In AOSC OS3, Zypper and PackageKit are the default frontends for managing RPM-based system releases." 10 60 3>&1 1>&2 2>&3`
end

# ============================================================

def learn_more_de
`whiptail --title "AOSC OS Installation" --scrolltext "\
GNOME (pronounced /ɡˈnoʊm/ or /ˈnoʊm/) is a desktop environment which 
    is composed entirely of free and open-source software and targets to be 
    cross-platform, i.e. run on multiple operating systems, its main focus 
    being those based on the GNU/Linux system.
    * GNOME needs about 1GB RAM and a dual core processor to run smoothly.
Cinnamon is a GTK+ 3-based desktop environment. The project originally 
    started as a fork of the GNOME Shell, i.e. a mere graphical shell. 
    Cinnamon was initially developed by (and for) Linux Mint. 
    * Cinnamon needs about 1GB RAM and a dual core processor to run 
      smoothly.
MATE (Spanish pronunciation: [ˈmate]) is a desktop environment forked 
    from the now-unmaintained code base of GNOME 2.
    * MATE needs about 512MB RAM to run smoothly.
XFCE (pronounced as four individual letters ) is a free software desktop
    environment for Unix and Unix-like platforms, such as Linux, Solaris, 
    and BSD. It aims to be fast and lightweight, while still being visually 
    appealing and easy to use. It consists of separately packaged compo-
    nents that together provide the full functionality of the desktop envi-
    ronment, but can be selected in subsets to suit user needs and 
    preference. 
    * XFCE needs about 512MB RAM to run smoothly.
Unity is a graphical shell for the GNOME desktop environment developed by
    Canonical Ltd. for its Ubuntu operating system. It was initially designed 
    to make more efficient use of space given the limited screen sizes.
    * Unity needs about 2GB RAM and a dual core processor to run smoothly.
KDE is fully based on Qt technologies, and provides a significant range
    of FOSS (Free and Open Source Software) to sum up Plasma's complete 
    integrated experience. 
    * KDE needs more than 2GB of RAM, dual core processor, at least Intel HD
      Graphics (or equivalent), and about 10GB of HDD space to run.
" 10 60 3>&1 1>&2 2>&3`
end

# ============================================================

def step0
`whiptail --title "AOSC OS Installation Confirm" --msgbox  "Fellow Beta testers...

    Firstly, a big thank you for choosing to test our newest system release.
    We are ready to take your issue reports so please feel free to file themto our b11ug tracker, http://bugs.anthonos.org.

    AOSC OS developers
" 15 60 3>&1 1>&2 2>&3`

`whiptail --title "AOSC OS Installation Confirm" --msgbox  "    Before you start, make sure...

    1.  You need a working (probably a fast one if you are impatient) Internet connection for installation if you want to install your system by netboot;
    2.  You will need a > 10GB partition for some desktop environment to be installed (Hopefully we will fix this before the final debut);" 15 60 3>&1 1>&2 2>&3`
end

# ============================================================

def step1
`whiptail --title "AOSC OS Installation" --msgbox  "STEP I. Choose a Package Manager

    AOSC OS supports DPKG and RPM as system package manager. DPKG and RPM now provide equal support, they both now support PackageKit and all of its graphical frontends." 13 60 3>&1 1>&2 2>&3`
catch :step1 do
@option = `whiptail --title "AOSC OS Installation"  --menu "Choose the package manager of your choice" 15 60 3 \
"DPKG" "Debian Packages" \
"RPM" "RedHat Package Manager" \
"?" "Learn more about package manager" 3>&1 1>&2 2>&3`
if @option == "?" then
	learn_more_pm	
	step1
end
if $? == 0 then
	$PM=@option
else
	install_end
end
end
end

# ============================================================

def step2
`whiptail --title "AOSC OS Installation" --msgbox  "STEP II. Choose a Desktop Environment

    AOSC OS provides multiple desktop environment by default, choose one from below, and make good choices!" 10 60 3>&1 1>&2 2>&3`
@option = `whiptail --title "AOSC OS Installation"  --menu "Choose the desktop environment of your choice" 16 74 6 \
"GNOME" "Gnome-shell, stable and fancy with heavy load" \
"Cinnamon" "A gnome-shell fork, mainly used in Linux Mint" \
"XFCE" "Light weight but useful" \
"MATE" "A Gnome2 fork, classical and stable" \
"Unity" "Desktop environment designed for netbook but with heavy load" \
"KDE" "As stable as KDE" \
"?" "Learn more about desktop environment" 3>&1 1>&2 2>&3`
if @option == "?" then
	learn_more_de	
	step2
end
if $? == 0 then
	$DE=@option
else
	install_end
end
end

# ============================================================

def runcfdisk
`cfdisk 3>&1 1>&2 2>&3`
end

def step3_1
`whiptail --title "AOSC OS Installation" --msgbox "STEP III. Target Customization

    In this stop you will need to decide on your partition setup, filesystem choice (and not yet implemented user settings). Please get a cup of coffee if you are feeling drowsynow. You would need to be extremely cautious at this step, any changes that would be made here are not amendable." 15 60 3>&1 1>&2 2>&3`
@option = `whiptail --title "AOSC OS Installation" --menu "Are you using a EFI based system or GUID partition table?" 10 70 2 \
"Yes" "I want to use EFI and GUID" \
"No" "My motherboard wasn't support it or I don't want to use it" 3>&1 1>&2 2>&3`
if $? == 0 then
	$EFI=@option
else
	install_end
end
end

def step3_2
	`whiptail --title "AOSC OS Installation" --yesno "Partition the disk now (by CFdisk)?" 10 60 3>&1 1>&2 2>&3`
	if $? == 0 then 
		runcfdisk
	end
	
	@partname = `lsblk -ro NAME`
	@partsize = `lsblk -ro SIZE`
	@parts = []
	@parts = @partname.split("\n")
	@sizes = []
	@sizes = @partsize.split("\n")
	@partshuman = []
	@partshuman = `lsblk`.split("\n")
	@partsfinal = []
	j = 0
	f = 0
	part = @parts
	for i in part do
		begin		
			@partsfinal[f] = j
			f += 1
		end if (@parts[j] != "NAME")#&(@sizes[j].to_f > 1000000000)
		j += 1
	end
	@cmdline = "\`whiptail --title \"AOSC OS Installation\" --menu \"These partitions could be used for AOSC install, Please choose one for AOSC, If you want to re-partition the disk, press cancel. All datas on this partition will lost.\" 15 80 "
	@cmdline += sprintf("%d \\", f)
	j = 0
	for i in @partsfinal do
		a = (@partsfinal[j]).to_i
		@cmdline += sprintf("\n\"/dev/%s\" \"%s\" \\", @parts[a], @partshuman[a])
		j += 1
	end
	@cmdline += " 3>&1 1>&2 2>&3 \`"
	@option=eval(@cmdline)
	if $? == 0 then
		$TARGETPART = @option
		@diskaosc = @option
	else
		step3_2
	end
	
	@fs = `whiptail --title "AOSC OS Installation" --menu "Which filesystem do you like to be used as the root filesystem?" 15 60 5 "ext4" "" "ext3" "" "ext2" "" "btrfs" "" "xfs" "" "jfs" "" 3>&1 1>&2 2>&3`
	cmdline = sprintf("`mkfs.%s -f %s 3>&1 1>&2 2>&3`", @fs, $TARGETPART)
	eval(cmdline)
end

def step3_3
	@partname = `lsblk -ro NAME`
	@partsize = `lsblk -bro SIZE`
	@parts = []
	@parts = @partname.split("\n")
	@sizes = []
	@sizes = @partsize.split("\n")
	@partshuman = []
	@partshuman = `lsblk`.split("\n")
	@partsfinal = []
	j = 0
	f = 0
	part = @parts
	for i in part do
		begin		
			@partsfinal[f] = j
			f += 1
		end if ((@parts[j] != "NAME")&(@parts[j] != @diskaosc)&(@sizes[j].length >= 11))
		j += 1
	end
	@cmdline = "\`whiptail --title \"AOSC OS Installation\" --menu \"These partitions could be used for AOSC install, Please choose one for ESP which needed by EFI system, If you want to re-partition the disk, press cancel\" 15 80 "
	@cmdline += sprintf("%d \\", f)
	j = 0
	for i in @partsfinal do
		a = (@partsfinal[j]).to_i
		@cmdline += sprintf("\n\"/dev/%s\" \"%s\" \\", @parts[a], @partshuman[a])
		j += 1
	end
	@cmdline += " 3>&1 1>&2 2>&3 \`"
	@option=eval(@cmdline)
	
	if $? == 0 then
		$ESP = @option
	else
		install_end
	end
	
	`whiptail --title "AOSC OS Installation" --yesno "Do you want to rebuild the filesystem of ESP? If you are shared ESP with other systems, you shouldn't rebuild it."`
	if $? == 0 then
		cmdline = sprintf("`mkfs.fat -F 32 %s 3>&1 1>&2 2>&3`", @option)
		eval(cmdline)
	end 
	
end

def step3
	step3_1
	step3_2
	if $EFI == "Yes" then
		step3_3
	end
end

# ============================================================

def confirm
	enter_to_continue

	`whiptail --msgbox "Ready?
Now, you shall take a deep breath before we officially start the installation...
" 10 60 3>&1 1>&2 2>&3`

	`clear 3>&1 1>&2 2>&3`
end

# ============================================================

def netgrab
	@options = `whiptail --title "AOSC OS Installation" --menu "Choose your mirrors to download the system" 15 60 4\
	"http://repo.anthonos.org" "Anthon repo" \
	"http://mirrors.anthonos.org/anthon" "Anthon Mirror" \
	"http://mirrors.ustc.edu.cn/anthon" "USTC Mirrors" \
	"Others" "Input your mirror"  3>&1 1>&2 2>&3`
	if @options == "Others" then
		@options = `whiptail --title "AOSC OS Installation" --inputbox "Please input your mirror," 15 60 "http://" 3>&1 1>&2 2>&3`
		$MIRRORS = @options
	else
		$MIRRORS = @options
	end

	$TARBALL = sprintf("aosc-os_%s_%s_latest.tar.xz",$DE.downcase,$PM.downcase)

	`clear 3>&1 1>&2 2>&3`
	puts "Downloading tarballs"
	cmdline = sprintf("`wget %s/aosc-os/%s/%s`", $MIRRORS, $DE.downcase, $TARBALL)
	eval(cmdline)
	puts "Downloading md5 signature"
	cmdline = sprintf("`wget %s/aosc-os/%s/%s.md5sum 3>&1 1>&2 2>&3`", $MIRRORS, $DE.downcase, $TARBALL)
	eval(cmdline)
	puts "Checking md5"
	cmdline = sprintf("`md5sum -c %s.md5sum`", $TARBALL)
	eval(cmdline)
	check
end

def install
	puts "Root target : " + $TARGETPART
	puts "EFI : " + $EFI
	if $EFI == "Yes" then
		puts "+	EFI target : " + $ESP
	end
	
#	Mounting target	
	puts "Mounting target"
	cmdline = "`mount " + $TARGETPART + " /mnt/target`"
	eval(cmdline)
	check

#	Clean target
	puts "Making sure the partition is empty..."
	`rm -rf /mnt/target/*`
	check
	
#	Check tarball
#	puts "Checking tarballs"
#	#==("./" + $TARBALL)
#	if (`[ -e "$TARBALL" ]`) then
#		puts "Checking md5"
#		cmdline = sprintf("`md5sum -c %s.md5sum`", $TARBALL)
#		eval(cmdline)
#		if $? != 0 then 
#			puts "Local md5 sum failed, download from net"
#			netgrab
#		end
#	else
#		netgrab
#	end
	

#	Decompress
	puts "Unpacking the system image..."
	cmdline = "`pv " + $TARBALL + " | tar xJf - -C /mnt/target`"
	eval(cmdline)
	check

#	Prepare chroot
	puts "Prepare for configuration"
	`pushd /mnt/target > /dev/null
	cp /etc/resolv.conf etc/
	mount --bind /dev dev
	mount --bind /proc proc
	mount --bind /sys sys
	genfstab -p /mnt/target >> /mnt/target/etc/fstab
	popd > /dev/null`
	if "$EFI" == "Yes"  then
    	`mkdir /mnt/target/efi`
    	cmdline = "`mount " + $ESP + " /mnt/target/efi`"
    	eval(cmdline)
	end
	#`fs-cache`
	check
	
	puts "Configuring GRUB..."
	targetp = $TARGETPART
	targetp[-1] = " "
	if $EFI == "No" then
 		cmdline = "`chroot /mnt/target grub-install --target=i386-pc " + targetp + " `"
 		eval(cmdline)
	elsif $EFI == "Yes" then
		`chroot /mnt/target grub-install --target=x86_64-efi --efi-directory=/efi --bootloader-id=AOSC-GRUB `
	end
	`chroot /mnt/target grub-mkconfig -o /boot/grub/grub.cfg`
	check
	
	`whiptail --title "AOSC OS Installation" --msgbox "Installation has successfully completed! Now we will perform some clean up. We will reboot your machine and jump right into your fresh installation of AOSC OS soon.

Default username is "aosc", password is "anthon"
Default root password is "anthon", although using sudo is recommended." 15 60  3>&1 1>&2 2>&3`
	`pushd /mnt/target > /dev/null
	umount -Rf dev proc sys
	popd > /dev/null`
	`umount -Rf /mnt/target`
	
	`whiptail --title "AOSC OS Installation" --msgbox "Please remove your installation media and press Enter to reboot" 3>&1 1>&2 2>&3`

end

# ============================================================

def main
	pre_install
	step0
	step1
	step2
	step3
	confirm
	netgrab
	install
end

# ============================================================

main
