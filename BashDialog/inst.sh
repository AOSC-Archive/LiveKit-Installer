#!/bin/bash

ended () {
	dialog --msgbox "`cat endinst.${LANG}`" 6 30
}

welcome () {
	  dialog --msgbox	"`cat welcome.${LANG}`"	6 30
	! dialog --yesno	"`cat license.${LANG}`"	10 40 && ended
	# dialog --textbox	"LGPL.${LANG}"		10 40
	! dialog --yesno	"`cat start.${LANG}`"	6 30 && ended
}

partition () {
	  dialog --yesno	"`cat gparted.${LANG}`"	6 30 && gparted
	  partprobe
}

main () {
	welcome
	partition
}

main
