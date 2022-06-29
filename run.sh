#!/bin/bash
clear
echo "Launching..." && sleep 1
#User Defined CPP Exercise 02
USRPATH="../Module-1/EX02"
NAME="Accounts"
#Launch Path
USRPROG="$USRPATH/$NAME"
#Tester Executable
EXEC="GBU_tester"
CORE="_core"
LAUNCH="$CORE/$EXEC"
#Log files
STOCK="stock.log"
COMPARE="compare.log"

function clearLogs () {
	if [ $2 ]; then
		rm $2
	fi
	if [ $1 ]; then
		rm $1
	fi
}

if [ ! -d $CORE ]; then
	echo " => Cloning Source Files"
	git clone https://github.com/lmells98/CPP-BankTester-SOURCE $CORE
fi

if [ -f $LAUNCH ]; then
	echo " => Found: $EXEC"
else
	echo " => Building: $EXEC"
	if [ -d $CORE ]; then
		make -s -C $CORE
		if [ -f $LAUNCH ]; then
			sleep 1 && echo "Done!" && sleep 1
		fi
	else
		echo " => Git Repo coming soon!"
	fi
fi

if [ -d $USRPATH ]; then
	if [ -f $USRPROG ]; then
		echo " => Found: $NAME"
	else
		echo " => Building: $NAME"
		make -s -C $USRPATH
		sleep 1 && echo "Done!" && sleep 1
	fi
	if [[ -f $USRPROG && -f $LAUNCH ]]; then
		if [ ! -f $STOCK ]; then
			echo " => Getting File: $STOCK"
			curl --silent -o $STOCK https://projects.intra.42.fr/uploads/document/document/8467/19920104_091532.log
		fi
		echo " => Getting File: $COMPARE" && sleep 1
		echo "Done!" && sleep 1
		clear && echo "Test launching..." && sleep 1
		$USRPROG > $COMPARE
		$LAUNCH $STOCK $COMPARE
	fi
	if [[ -f $USRPROG || -f $LAUNCH ]]; then
		if [ -d $USRPATH ]; then
			make -s -C $USRPATH fclean
		fi
		if [ -f $LAUNCH ]; then
			make -s -C $CORE fclean
		fi
	fi
	clearLogs $STOCK $COMPARE
	rm -rf $CORE
else
	echo "Error!"
	echo " => Directory: $USRPATH: does not exist..."
fi
