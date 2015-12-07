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

#build for arm first
rm -rf $LINUX_ARMV7L/include/pj*
rm -rf $LINUX_ARMV7L/lib/libpj*
rm -rf $LINUX_ARMV7L/lib/libg7221codec-arm-none-linux-gnueabi.a
rm -rf $LINUX_ARMV7L/lib/libgsmcodec-arm-none-linux-gnueabi.a
rm -rf $LINUX_ARMV7L/lib/libilbccodec-arm-none-linux-gnueabi.a
rm -rf $LINUX_ARMV7L/lib/libportaudio-arm-none-linux-gnueabi.a
rm -rf $LINUX_ARMV7L/lib/libresample-arm-none-linux-gnueabi.a
rm -rf $LINUX_ARMV7L/lib/libspeex-arm-none-linux-gnueabi.a
make distclean
./configure --host=arm-none-linux-gnueabi --target=arm-none-linux-gnueabi --prefix=$LINUX_ARMV7L CFLAGS=-I$LINUX_ARMV7L/include LDFLAGS=-L$LINUX_ARMV7L/lib
make -j4
make install

#build for intel
rm -rf $INSTALL_DIR/include/pj*
rm -rf $INSTALL_DIR/lib/libpj*
rm -rf $INSTALL_DIR/libportaudio-i686-pc-linux-gnu.a
rm -rf $INSTALL_DIR/libresample-i686-pc-linux-gnu.a
rm -rf $INSTALL_DIR/libspeex-i686-pc-linux-gnu.a
rm -rf $INSTALL_DIR/libg7221codec-i686-pc-linux-gnu.a
rm -rf $INSTALL_DIR/libgsmcodec-i686-pc-linux-gnu.a
rm -rf $INSTALL_DIR/libilbccodec-i686-pc-linux-gnu.a

make distclean
./configure --disable-ssl --prefix=$INSTALL_DIR CFLAGS=-I/$INSTALL_DIR/include LDFLAGS=-L/$INSTALL_DIR/lib
make dep
make
make install
