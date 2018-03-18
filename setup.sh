#!/bin/bash

# clean up previously set env
if [[ -z $FORCE_MYSW_DIR ]]; then
    where="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
    export MYSW_DIR=${where}
else
    export MYSW_DIR=$FORCE_MYSW_DIR
fi
export MYSW_BINDIR=$MYSW_DIR/bin

# set the build dir
unset MYSW_BUILDDIR
if [[ -z $MYSW_BUILDDIR ]]; then
    export MYSW_BUILDDIR=$MYSW_DIR/build
fi
export MYSW_LIBDIR=$MYSW_BUILDDIR/lib
export MYSW_INCDIR=$MYSW_BUILDDIR/include
mkdir -p $MYSW_BUILDDIR;
mkdir -p $MYSW_LIBDIR;
mkdir -p $MYSW_BINDIR;

# Abort if ROOT not installed. Let's check rootcint for this.
if [ `command -v rootcling` ]; then
    export MYSW_ROOT6=1
else
    echo
    echo Looks like you do not have ROOT6 installed.
    echo You cannot use LArLite w/o ROOT6!
    echo Aborting.
    echo
    return 1;
fi

# Check Numpy
export MYSW_NUMPY=`$MYSW_DIR/bin/check_numpy`

# warning for missing support
missing=""
if [ $MYSW_NUMPY -eq 0 ]; then
    missing+=" Numpy"
else
    MYSW_INCLUDES="${MYSW_INCLUDES} -I`python -c\"import numpy; print(numpy.get_include())\"`"
fi
if [[ $missing ]]; then
    printf "\033[93mWarning\033[00m ... missing$missing support. Build without them.\n";
fi

echo
printf "\033[93mLArCV\033[00m FYI shell env. may useful for external packages:\n"
printf "    \033[95mMYSW_INCDIR\033[00m   = $MYSW_INCDIR\n"
printf "    \033[95mMYSW_LIBDIR\033[00m   = $MYSW_LIBDIR\n"
printf "    \033[95mMYSW_BUILDDIR\033[00m = $MYSW_BUILDDIR\n"

export PATH=$MYSW_BINDIR:$PATH
export LD_LIBRARY_PATH=$MYSW_LIBDIR:$LD_LIBRARY_PATH
export DYLD_LIBRARY_PATH=$MYSW_LIBDIR:$DYLD_LIBRARY_PATH
export PYTHONPATH=$MYSW_DIR/python:$PYTHONPATH

export MYSW_CXX=clang++
if [ -z `command -v $MYSW_CXX` ]; then
    export MYSW_CXX=g++
    if [ -z `command -v $MYSW_CXX` ]; then
        echo
        echo Looks like you do not have neither clang or g++!
        echo You need one of those to compile LArCaffe... Abort config...
        echo
        return 1;
    fi
fi

echo
echo "Finish configuration. To build, type:"
echo "> make "
echo
