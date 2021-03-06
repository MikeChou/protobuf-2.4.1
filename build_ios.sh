#!/bin/sh

XCODEDIR=`xcode-select --print-path`
IOS_SDK=$(xcodebuild -showsdks | grep iphoneos | sort | head -n 1 | awk '{print $NF}')
SIM_SDK=$(xcodebuild -showsdks | grep iphonesimulator | sort | \
	head -n 1 | awk '{print $NF}')


IPHONEOS_PLATFORM=${XCODEDIR}/Platforms/iPhoneOS.platform
IPHONEOS_SYSROOT=${IPHONEOS_PLATFORM}/Developer/SDKs/${IOS_SDK}.sdk
 
IPHONESIMULATOR_PLATFORM=${XCODEDIR}/Platforms/iPhoneSimulator.platform
IPHONESIMULATOR_SYSROOT=${IPHONESIMULATOR_PLATFORM}/Developer/SDKs/${SIM_SDK}.sdk

make distclean
export CXXFLAGS="-fPIC -fvisibility=hidden  \
	-arch armv7 -arch armv7s -arch arm64 \
	-isysroot $IPHONEOS_SYSROOT -std=c++11 -stdlib=libc++"
./configure --build=armv7-apple-darwin13.0.0  --disable-shared \
	--prefix=`pwd`/build-ios-OS --with-protoc=protoc --without-zlib
make -j3 && make install

make distclean
export CXXFLAGS="-fPIC -fvisibility=hidden -arch i386 \
	-isysroot $IPHONESIMULATOR_SYSROOT -std=c++11 -stdlib=libc++"
export LDFLAGS="-arch i386 -isysroot $IPHONESIMULATOR_SYSROOT \
-miphoneos-version-min=7.0"
./configure --build=i386-apple-darwin13.0.0  --disable-shared \
	--prefix=`pwd`/build-ios-SIMULATOR --with-protoc=protoc \
	--without-zlib
make -j3 && make install
