#!/bin/bash

if [ $# -lt 1 ]; then
echo "
Usage:
    ./build.sh [0|1]
        0: don't do cross compile for arm
        1: do cross compile for arm
"
exit
fi

#define constant variable
#LINUX_ARMV7L=$PWD/../libs/linux-armv7l
#LINUX_X86_64=$PWD/../libs/linux-x86_64
#LINUX_I686=$PWD/../libs/linux-i686
#MINGW=$PWD/../libs/mingw32-i586
#MACOS=$PWD/../libs/darwin-x86_64
LINUX_ARMV7L=../libs/linux-armv7l
LINUX_X86_64=../libs/linux-x86_64
LINUX_I686=../libs/linux-i686
MINGW=../libs/mingw32-i586
MACOS=../libs/darwin-x86_64
EXT=""
ARM=$1
#MACOS
uname -a | grep "Darwin"
if [ $? == 0 ]; then
	INSTALL_DIR=$MACOS
	EXT="x86_64-apple-darwin12.5.0"
    echo "
    #include <pj/config_site_sample.h>
    " > pjlib/include/pj/config_site.h
fi
#MINGW
uname -a | grep "MINGW32"
if [ $? == 0 ]; then
	INSTALL_DIR=$MINGW
	EXT="i586-pc-mingw32"
    echo "
    #define PJMEDIA_AUDIO_DEV_HAS_PORTAUDIO 1
    #define PJMEDIA_AUDIO_DEV_HAS_ALSA 1
    #include <pj/config_site_sample.h>
    " > pjlib/include/pj/config_site.h
fi
#MSYS
uname -a | grep "MSYS"
if [ $? == 0 ]; then
	ARCHITECTURE=`uname -m`
	if [ $ARCHITECTURE = "i686" ]; then
		INSTALL_DIR=$MSYS
		EXT="i686-pc-msys"
	fi
    echo "
    #define PJMEDIA_AUDIO_DEV_HAS_PORTAUDIO 1
    #define PJMEDIA_AUDIO_DEV_HAS_ALSA 1
    #include <pj/config_site_sample.h>
    " > pjlib/include/pj/config_site.h
fi
#Linux
uname -a | grep "Linux"
if [ $? == 0 ]; then
	ARCHITECTURE=`uname -m`
	if [ $ARCHITECTURE = "i686" ]; then
		INSTALL_DIR=$LINUX_I686
		EXT="i686-pc-linux-gnu"
	elif [ $ARCHITECTURE = "x86_64" ]; then
		INSTALL_DIR=$LINUX_X86_64
		EXT="x86_64-unknown-linux-gnu"
	fi
    echo "
    #define PJMEDIA_AUDIO_DEV_HAS_PORTAUDIO 1
    #define PJMEDIA_AUDIO_DEV_HAS_ALSA 1
    #include <pj/config_site_sample.h>
    " > pjlib/include/pj/config_site.h
fi

if [ $ARM == 1 ]; then
        #build for arm first
        rm -rf $LINUX_ARMV7L/include/pj*
        rm -rf $LINUX_ARMV7L/lib/libpj*
        rm -rf $LINUX_ARMV7L/lib/libg7221codec-arm-unknown-linux-gnueabihf.a
        rm -rf $LINUX_ARMV7L/lib/libgsmcodec-arm-unknown-linux-gnueabihf.a
        rm -rf $LINUX_ARMV7L/lib/libilbccodec-arm-unknown-linux-gnueabihf.a
        rm -rf $LINUX_ARMV7L/lib/libportaudio-arm-unknown-linux-gnueabihf.a
        rm -rf $LINUX_ARMV7L/lib/libresample-arm-unknown-linux-gnueabihf.a
        rm -rf $LINUX_ARMV7L/lib/libspeex-arm-unknown-linux-gnueabihf.a
		rm -rf $LINUX_ARMV7L/lib/libsrtp-arm-unknown-linux-gnueabihf.a
        make distclean
		echo "
		#include <pj/config_site_sample.h>
		#define PJMEDIA_AUDIO_DEV_HAS_PORTAUDIO 0
		#define PJMEDIA_AUDIO_DEV_HAS_ALSA 1
		" > pjlib/include/pj/config_site.h
        #./configure --host=arm-none-linux-gnueabi --target=arm-none-linux-gnueabi --prefix=$LINUX_ARMV7L CFLAGS=-I$LINUX_ARMV7L/include LDFLAGS=-L$LINUX_ARMV7L/lib
        ./configure --host=arm-linux-gnueabihf --target=arm-linux-gnueabihf --prefix=$LINUX_ARMV7L CFLAGS=-I$LINUX_ARMV7L/include LDFLAGS=-L$LINUX_ARMV7L/lib
        #./configure --host=arm-none-linux-gnueabi --target=arm-none-linux-gnueabi --prefix=$LINUX_ARMV7L CFLAGS=-I$LINUX_ARMV7L/include LDFLAGS=-L$LINUX_ARMV7L/lib
        make dep
        make
        make install
fi

#build for intel
rm -rf $INSTALL_DIR/include/pj*
rm -rf $INSTALL_DIR/lib/libpj*
rm -rf $INSTALL_DIR/libportaudio-$EXT.a
rm -rf $INSTALL_DIR/libresample-$EXT.a
rm -rf $INSTALL_DIR/libspeex-$EXT.a
rm -rf $INSTALL_DIR/libg7221codec-$EXT.a
rm -rf $INSTALL_DIR/libgsmcodec-$EXT.a
rm -rf $INSTALL_DIR/libilbccodec-$EXT.a
make distclean
./configure --disable-ssl --prefix=$INSTALL_DIR CFLAGS=-I$PWD/$LINUX_I686/include LDFLAGS=-L$PWD/$LINUX_I686/lib
make dep
make
make install
