#!/bin/bash

ended () {
	  dialog --msgbox "`cat endinst.${LANG}`" 6 30
	  exit
}

welcome () {
	  dialog --msgbox	"`cat welcome.${LANG}`"	6 30
	! dialog --yesno	"`cat license.${LANG}`"	10 40 && ended
	# dialog --textbox	"LGPL.${LANG}"		10 40
	! dialog --yesno	"`cat start.${LANG}`"	6 30 && ended
}

partition () {
	  dialog --yesno	"`cat parted.${LANG}`"	6 30 && `cat parttool`
	  partprobe
}

selection_pm () {
	  echo "PM_SELECTION = \\" >> CONFIG
! eval	" dialog --menu		\"`cat pm.${LANG}`\" 10 50 7 `cat pm_menu.${LANG}` 2>> CONFIG " && ended
	  echo >> CONFIG
}

selection_de () {
	  echo "DE_SELECTION = \\" >> CONFIG
! eval	" dialog --menu		\"`cat de.${LANG}`\" 20 50 17 `cat de_menu.${LANG}` 2>> CONFIG " && ended
	  echo >> CONFIG
}

clean () {
	  rm -f CONFIG
	  umount -f /mnt/target
	  umount -f /mnt/esp
	  rm -rfd /mnt/target /mnt/esp
	  mkdir /mnt/target /mnt/esp
}

main () {
	  rm -f CONFIG

	  welcome
	  selection_pm
	  selection_de
	  partition
}

main
