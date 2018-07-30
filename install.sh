#!/bin/bash
#
# Created by: Westley K
# email: westley@sylabs.io
# Date: Jul 30, 2018
# version-1.0.2
#
# MIT License
#
# Copyright (c) 2018 WestleyK
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#

OPTION=$1
SCRIPT_NAME="hubget"
PATH_INSTALL="/usr/local/bin/"


IS_ROOT=$( id -u )

if [ $IS_ROOT != 0 ]; then
	echo "Please run as root!"
	echo "try: sudo ./install.sh"
	exit
fi


if [ -z $OPTION ]; then
	if [ -e $PATH_INSTALL$SCRIPT_NAME ]; then
		echo $SCRIPT_NAME "is already installed to" $PATH_INSTALL
		echo "Continuing will overide the existing script"
		echo "Do you want to continue?"
		echo -n "[y,n]:"
		read INPUT
		if [ $INPUT = "y" ] || [ $INPUT = "Y" ]; then
			echo "Installing" $SCRIPT_NAME\ "..."
			chmod +x $SCRIPT_NAME
			cp $SCRIPT_NAME $PATH_INSTALL
			source ~/easy-clone/auto-complete.sh
			echo "source ~/easy-clone/auto-complete.sh >> ~/.bashrc"
			echo "Installed to" $PATH_INSTALL
			exit
		fi
	fi

	echo "Installing" $SCRIPT_NAME\ "..."
	chmod +x $SCRIPT_NAME
	cp $SCRIPT_NAME $PATH_INSTALL
	source ~/easy-clone/auto-complete.sh
	echo "source ~/easy-clone/auto-complete.sh >> ~/.bashrc"
	echo "Installed to" $PATH_INSTALL
	exit

fi

if [ "$OPTION" = "-u" ] || [ "$OPTION" = "-update" ]; then
	echo "This will update the existing script if theres one present"
	echo "Are you sure you want to continue?"
	echo -n "[y,n]:"
	read INPUT
	if [ $INPUT = "y" ] || [ $INPUT = "Y" ]; then
		echo "Updating..."
		git pull origin master
		echo "Installing" $SCRIPT_NAME\ "..."
		chmod +x $SCRIPT_NAME
		cp $SCRIPT_NAME $PATH_INSTALL
		echo "Installed to" $PATH_INSTALL
		exit
	else
		echo "Aborting."
		exit
	fi
elif [ "$OPTION" = "-r" ] || [ "$OPTION" = "-uninstall" ]; then
		if [ -e $PATH_INSTALL$SCRIPT_NAME ]; then
			echo "This will uninstall" $SCRIPT_NAME "from" $PATH_INSTALL
			echo "Are you sure you want to continue?"
			echo -n "[y,n]:"
			read INPUT
			if [ $INPUT = "y" ] || [ $INPUT = "Y" ]; then
				echo "Uninstalling" $SCRIPT_NAME "from" $PATH_INSTALL
				rm $PATH_INSTALL$SCRIPT_NAME
				echo "Done."
				exit
			else
				echo "Aborting."
				exit
			fi
		else
			echo \'$SCRIPT_NAME\' "not installed to" \'$PATH_INSTALL\'
			exit
		fi
else
	echo "Usage: sudo ./install [OPTION]
		-u | -update (update command and repo)
		-r | -uninstall (uninstall command)"
	exit
fi


#
# End install script
#


