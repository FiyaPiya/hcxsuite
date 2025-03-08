#!/bin/bash
##
#
# https://github.com/ZerBea/hcxdumptool/archive/refs/heads/master.zip
# https://github.com/ZerBea/hcxtools/archive/refs/heads/master.zip
#
###
#
# Possibly check all deps are installed in later revisions
#
##
doCleanUp=0
compileDebug=0
compileHeadless=0

help_all_out () {
	echo "$0 - Downloads and Compiles 'hcxdumptool' and 'hcxtools' into one folder ('hcxsuite')"
	echo "hcxtools and hcxdumptool by ZeoBea: https://github.com/ZerBea/"
	echo "https://github.com/ZerBea/hcxtools/ \nhttps://github.com/ZerBea/hcxdumptool/"
	echo "
-h		Displays this message

-c		Cleans up after compile and move
-f		Fresh downloads (Deletes files before starting)

-d		Enable Debug logging in 'hcxdumptool'
-s 		Supresses output of 'hcxdumptool' for Headless operation
"  
exit
}

deleteDownloads () {
	echo "Cleaning up..."
	rm -f hcxtools.zip
	rm -f hcxdumptool.zip
	rm -rf hcxtools-master/
	rm -rf hcxdumptool-master/
	echo "Done"
}


while getopts "cdfhs" flag; do
	case "${flag}" in
		c)
			echo "Cleaning up on completion"
			doCleanUp=1
		;;
		d)
			echo "Will enable Debug flag in Makefile"
			compileDebug=1
		;;
		f)
			deleteDownloads
		;;
		s)
			echo "Will suppress output of 'hcxdumptool'"
			compileHeadless=1
		;;
		h) help_all_out	;;
		*) help_all_out ;;
	esac
done


if [ ! -d hcxsuite ]; then
	echo "Making 'hcxsuite' directory"
	mkdir hcxsuite;
	mkdir hcxsuite/scripts;
fi


####
#   hcxdumptool & hcxnmealog
####
echo "Downloading latest 'hcxdumptool'"
wget -q -O hcxdumptool.zip "https://github.com/ZerBea/hcxdumptool/archive/refs/heads/master.zip"
echo "Unzipping and compiling 'hcxdumptool'"
unzip -o -q hcxdumptool.zip
cd hcxdumptool-master
if [ $compileHeadless -eq 1 ]; then
	sed -i 's/DEFS		+= -DHCXSTATUSOUT/#DEFS		+= -DHCXSTATUSOUT/' Makefile
fi
if [ $compileDebug -eq 1 ]; then
	sed -i 's/#DEFS		+= -DHCXDEBUG/DEFS		+= -DHCXDEBUG/' Makefile
fi
make clean
make --silent
echo "Moving files to 'hcxsuite'"
mv -f hcxdumptool ../hcxsuite/hcxdumptool
mv -f hcxnmealog ../hcxsuite/hcxnmealog
mv -f usefulscripts/* ../hcxsuite/scripts
cd ..
echo "Done"


####
# hcxtools
####
echo "Downloading latest 'hcxtools'"
wget -q -O hcxtools.zip "https://github.com/ZerBea/hcxtools/archive/refs/heads/master.zip"
echo "Unzipping and compiling 'hcxtools'"
unzip -o -q hcxtools.zip
cd hcxtools-master
make clean
make --silent
echo "Moving files to 'hcxsuite'"
mv -f hcxeiutool ../hcxsuite/hcxeiutool
mv -f hcxhash2cap ../hcxsuite/hcxhash2cap
mv -f hcxhashtool ../hcxsuite/hcxhashtool
mv -f hcxpcapngtool ../hcxsuite/hcxpcapngtool
mv -f hcxpmktool ../hcxsuite/hcxpmktool
mv -f hcxpsktool ../hcxsuite/hcxpsktool
mv -f hcxwltool ../hcxsuite/hcxwltool
mv -f whoismac ../hcxsuite/whoismac
mv -f wlancap2wpasec ../hcxsuite/wlancap2wpasec
mv -f usefulscripts/* ../hcxsuite/scripts
cd ..
echo "Done"

# At the end of all, delete sources?
# Will do with -c supplied
if [ $doCleanUp -eq 1 ]; then
	echo "test"
	deleteDownloads
fi


