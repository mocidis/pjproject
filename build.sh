#!/bin/bash
#define constant variable
LINUX_ARMV7L=$PWD/../libs/linux-armv7l
LINUX_X86_64=$PWD/../libs/linux-x86_64
LINUX_I686=$PWD/../libs/linux-i686
MINGW=$PWD/../libs/mingw32-i586
MACOS=$PWD/../libs/darwin-x86_64

#MACOS
uname -a | grep "Darwin"
if [ $? == 0 ]; then
	INSTALL_DIR=$MACOS
fi
#MINGW
uname -a | grep "MINGW32"
if [ $? == 0 ]; then
	INSTALL_DIR=$MINGW
fi
#Linux
uname -a | grep "Linux"
if [ $? == 0 ]; then
	ARCHITECTURE=`uname -m`
	if [ $ARCHITECTURE = "i686" ]; then
		INSTALL_DIR=$LINUX_I686
	elif [ $ARCHITECTURE = "x86_64" ]; then
		INSTALL_DIR=$LINUX_X86_64
	fi
fi

echo $INSTALL_DIR
#build for arm first
#make distclean
./configure --host=arm-none-linux-gnueabi --target=arm-none-linux-gnueabi --prefix=$LINUX_ARMV7L CFLAGS=-I$LINUX_ARMV7L/include LDFLAGS=-L$LINUX_ARMV7L/lib
make -j4
make install

#build for intel
make distclean
./configure --disable-ssl --prefix=$INSTALL_DIR CFLAGS=-I/$INSTALL_DIR/include LDFLAGS=-L/$INSTALL_DIR/lib
make dep
make
make install
