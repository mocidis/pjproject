# build/os-auto.mak.  Generated from os-auto.mak.in by configure.

export OS_CFLAGS   := $(CC_DEF)PJ_AUTOCONF=1 -I//root/workspace/ics-project/pjproject/../libs/linux-i686/include -DPJ_IS_BIG_ENDIAN=0 -DPJ_IS_LITTLE_ENDIAN=1

export OS_CXXFLAGS := $(CC_DEF)PJ_AUTOCONF=1 -I//root/workspace/ics-project/pjproject/../libs/linux-i686/include 

export OS_LDFLAGS  := -L//root/workspace/ics-project/pjproject/../libs/linux-i686/lib -lm -lrt -lpthread  -lasound -L/usr/local/lib -Wl,-rpath,/usr/local/lib -lSDL2 -lpthread  -pthread -L/usr/local/lib -lavformat -lavcodec -ldl -lrt -lswscale -lavutil -lm  

export OS_SOURCES  := 


