#!/bin/bash

# clean up previously set env
me="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)"
export MYSW_DIR=$me;
export MYSW_LIBDIR=$me/lib
mkdir -p $MYSW_LIBDIR;
# Abort if ROOT not installed. Let's check rootcint for this.
if [ `command -v rootcling` ]; then
    export MYSW_ROOT6=1
else 
    if [[ -z `command -v rootcint` ]]; then
	echo
	echo Looks like you do not have ROOT installed.
	echo You cannot use LArLite w/o ROOT!
	echo Aborting.
	echo
	return;
    fi
fi
MYSW_OS=`uname -s`

# Check compiler availability for clang++ and g++
if [ -x "$GCC_FQ_DIR" ] ; then
  # We're running a UPS distribution, likely build root with it. So let's use GCC
  MYSW_CXX=g++
else
  # Try the OSX default install
  MYSW_CXX=clang++
fi

if [ `command -v $MYSW_CXX` ]; then
    export MYSW_CXX="$MYSW_CXX -std=c++11";
else
    MYSW_CXX=g++
    if [[ -z `command -v $MYSW_CXX` ]]; then
	echo
	echo Looks like you do not have neither clang or g++!
	echo You need one of those to compile LArLite... Abort config...
	echo
	return;
    fi
    export MYSW_CXX;
    if [ $MYSW_OS = 'Darwin' ]; then
	echo $MYSW_OS
	echo
	echo "***************** COMPILER WARNING *******************"
	echo "*                                                    *"
	echo "* You are using g++ on Darwin to compile LArLite.    *"
	echo "* Currently LArLite assumes you do not have C++11    *"
	echo "* in this combination. Contact the author if this is *"
	echo "* not the case. At this rate you have no ability to  *"
	echo "* compile packages using C++11 in LArLite.           *"
	echo "*                                                    *"
	echo "* Help to install clang? See manual/contact author!  *"
	echo "*                                                    *"
	echo "******************************************************"
	echo 
    fi
fi
if [[ -z $ROOTSYS ]]; then
    echo
    echo "****************** PyROOT WARNING ********************"
    echo "*                                                    *"
    echo "* Did not find your \$ROOTSYS. To use PyROOT feature, *"
    echo "* Make sure ROOT.py is installed (comes with ROOT).  *"
    echo "* You need to export \$PYTHONPATH to include the dir  *"
    echo "* where ROOT.py exists.                              *"
    echo "*                                                    *"
    echo "* Help to install PyROOT? See manual/contact author! *"
    echo "*                                                    *"
    echo "******************************************************"
    echo
else
    export MYSW_CXXSTDFLAG=`python $MYSW_DIR/config/get_stdflag.py`
    export PYTHONPATH=$ROOTSYS/lib:$PYTHONPATH;
fi

export PATH=$MYSW_DIR/bin:$PATH
export LD_LIBRARY_PATH=$MYSW_LIBDIR:$LD_LIBRARY_PATH
if [ $MYSW_OS = 'Darwin' ]; then
    export DYLD_LIBRARY_PATH=$MYSW_LIBDIR:$DYLD_LIBRARY_PATH
fi
echo
echo "Finish configuration. To build, type:"
echo "> cd \$MYSW_DIR"
echo "> make"
echo
