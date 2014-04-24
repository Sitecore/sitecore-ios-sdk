#!/bin/bash
#
#
#####################



IOS_VERSION=$1
CONFIGURATION=$2

APP_NAME=SCContactsTest
TARGET_NAME=${APP_NAME}Libs
LAUNCH_DIR=$PWD

echo arg1        - $1
echo IOS_VERSION - $IOS_VERSION

cd ../
  SCRIPTS_ROOT_DIR=$PWD
cd "$LAUNCH_DIR"

cd ../../
    PROJECT_ROOT=$PWD
cd "$LAUNCH_DIR"



KILL_SIMULATOR=$SCRIPTS_ROOT_DIR/simulator/KillSimulator.sh
LAUNCH_SIMULATOR="/usr/local/bin/ios-sim launch"
if [ -n "$IOS_VERSION" ]; then
    LAUNCH_SIMULATOR_IOS_VERSION="--sdk $IOS_VERSION"
else
	LAUNCH_SIMULATOR_IOS_VERSION=""
fi



cd "$PROJECT_ROOT/test/FunctionalTests/$APP_NAME"
pwd

xcodebuild -project $APP_NAME.xcodeproj -target ${TARGET_NAME} -configuration $CONFIGURATION -sdk iphonesimulator$IOS_VERSION clean build
if [ "$?" -ne "0" ]; then
   echo "[!!! ERROR !!!] : Build failed"
   echo xcodebuild -project $APP_NAME.xcodeproj -alltargets -configuration $CONFIGURATION -sdk iphonesimulator$IOS_VERSION clean build
   exit 1
fi


BUILT_PRODUCTS_DIR=$( cat /tmp/${TARGET_NAME}Build/PRODUCT_DIR.txt )
cd "$BUILT_PRODUCTS_DIR/$CONFIGURATION-iphonesimulator"
/bin/bash "$KILL_SIMULATOR"
    $LAUNCH_SIMULATOR "$PWD/$APP_NAME.app" $LAUNCH_SIMULATOR_IOS_VERSION
/bin/bash "$KILL_SIMULATOR"

cd "$LAUNCH_DIR"
