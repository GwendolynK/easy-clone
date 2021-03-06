#!/bin/bash
#
# Created by: Westley K
# email: westley@sylabs.io
# Date: Sep 4, 2018
# version-1.0.8
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
IS_ROOT="$( id -u )"


help_menu() {
    echo "Usage: ./make.sh [OPTION]"
    echo "      help (print help menu)"
    echo "      install (install script)"
    echo "      update (update script and repo)"
    echo "      uninstall (uninstall script)"
    echo "source code: https://github.com/WestleyK/easy-clone"
	exit 0
}

home_directory() {
    if [[ -e home-dir.txt ]]; then
        USR_HOME="$( cat home-dir.txt )"
    else
        echo "Before installing, run:"
        echo "  $ ./make.sh  (then)" 
        echo "  $ sudo ./make.sh [OPTION]"
        exit 1
        fi
}

run_root() {
    if [ $IS_ROOT != 0 ]; then
        echo "Please run as root:"
        echo "  $ sudo ./make.sh"
        exit 1
    fi
}

is_home() {
    if [[ ! -d $USR_HOME/easy-clone ]]; then
        echo "This repo must be in your home directory: " $USR_HOME/easy-clone/
        exit 1
    fi
}

script_source() {
    IS_SOURCE="$( cat $USR_HOME/.bashrc | grep 'easy-clone/auto-complete.sh' )"
    if [[ -z $IS_SOURCE ]]; then
        echo "Adding source $USR_HOME/easy-clone/auto-complete.sh to $USR_HOME/.bashrc"
        echo "source $USR_HOME/easy-clone/auto-complete.sh" >> $USR_HOME/.bashrc
        source $USR_HOME/.bashrc
    fi
    source $USR_HOME/.bashrc
}

install_now() {
    is_home
    run_root
    echo "Installing" $SCRIPT_NAME...
    chmod +x $SCRIPT_NAME
    cp $SCRIPT_NAME $PATH_INSTALL
    script_source
    source $USR_HOME/.bashrc
    echo $SCRIPT_NAME "is installed to" $PATH_INSTALL
    echo "Done."
    exit 0
}

install_script() {
    if [ -e $PATH_INSTALL$SCRIPT_NAME ]; then
        echo $SCRIPT_NAME "is already installed to" $PATH_INSTALL
        echo "Continuing will overide the existing script"
        echo "Do you want to continue?"
        echo -n "[y,n]:"
        read INPUT
        if [[ $INPUT = "y" ]] || [[ $INPUT = "Y" ]]; then
            install_now
        else
            exit 0
        fi
    fi
    install_now
}

uninstall_script() {
    if [[ -e $PATH_INSTALL$SCRIPT_NAME ]]; then
        echo "This will uninstall" $SCRIPT_NAME "from" $PATH_INSTALL
        echo "Are you sure you want to continue?"
        echo -n "[y,n]:"
        read INPUT
        if [[ $INPUT = "y" ]] || [[ $INPUT = "Y" ]]; then
            echo "Uninstalling" $SCRIPT_NAME "from" $PATH_INSTALL
            rm $PATH_INSTALL$SCRIPT_NAME
            echo "Done."
            exit 0
        else
            echo "Aborting."
            exit 1
        fi
    else
        echo $SCRIPT_NAME "not installed to" $PATH_INSTALL
        exit 1
    fi
}

if [[ -n $OPTION ]]; then
    home_directory
    if [[ $OPTION = "help" ]]; then
        help_menu
    elif [[ $OPTION = "install" ]]; then
        install_script
    elif [[ $OPTION = "update" ]]; then
        update_script
    elif [[ $OPTION = "uninstall" ]]; then
        uninstall_script
    else
        echo "Option not found :P  " $OPTION
        echo "Try: ./make.sh help"
        exit 1
        fi
fi

if [[ -z $OPTION ]]; then
    if [ $IS_ROOT != 0 ]; then
        echo ${HOME} > home-dir.txt
        touch install
        touch update
        touch uninstall
        echo "do:"
        echo "  $ sudo ./make.sh install"
        exit 0
    else
        echo "Do not run as root!"
        exit 1
    fi
fi



#
# End install script
#


