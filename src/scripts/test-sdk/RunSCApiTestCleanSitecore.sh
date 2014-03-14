#!/bin/bash
#
#
#####################



IOS_VERSION=$1
CONFIGURATION=$2

APP_NAME=SCApiTestCleanSitecore
LAUNCH_DIR=$PWD

echo arg1        - $1
echo IOS_VERSION - $IOS_VERSION

cd ../
  SCRIPTS_ROOT_DIR=$PWD
cd "$LAUNCH_DIR"

cd ../../
    PROJECT_ROOT=$PWD
cd "$LAUNCH_DIR"


#GCOVR=$SCRIPTS_ROOT_DIR/coverage/gcovr
GCOVR=gcovr
TEST_SUITE_ROOT=$PROJECT_ROOT/test/FunctionalTests/$APP_NAME
cd "$TEST_SUITE_ROOT"
	pwd
	rm -rf "$PWD/build"

	xcodebuild -project $APP_NAME.xcodeproj -target SCApiTestLibs -configuration $CONFIGURATION -sdk iphonesimulator$IOS_VERSION clean build
	if [ "$?" -ne "0" ]; then
	   echo "[!!! ERROR !!!] : Build failed"
	   echo xcodebuild -project $APP_NAME.xcodeproj -target SCApiTestLibs -configuration $CONFIGURATION -sdk iphonesimulator$IOS_VERSION clean build
	   exit 1
	fi



BUILT_PRODUCTS_DIR=$( cat /tmp/SCApiTestLibsBuild/PRODUCT_DIR.txt )
cd "$BUILT_PRODUCTS_DIR/$CONFIGURATION-iphonesimulator"
	/bin/bash "$SCRIPTS_ROOT_DIR/simulator/KillSimulator.sh"
	    iphonesim launch "$PWD/SCApiTestLibs.app" $IOS_VERSION 
	/bin/bash "$SCRIPTS_ROOT_DIR/simulator/KillSimulator.sh"
cd "$TEST_SUITE_ROOT"




################  COVERAGE
echo "---Collecting coverage reports---"

cd "$PROJECT_ROOT"
    echo "$GCOVR $PWD --root=$PROJECT_ROOT --xml > $PROJECT_ROOT/Coverage.xml"
	echo "$GCOVR $PWD --root=$PROJECT_ROOT       > $PROJECT_ROOT/Coverage.txt"

	$GCOVR "$PWD" --root="$PROJECT_ROOT" --xml | tee "$PROJECT_ROOT/Coverage.xml"
	$GCOVR "$PWD" --root="$PROJECT_ROOT"       | tee "$PROJECT_ROOT/Coverage.txt"
cd "$LAUNCH_DIR"

echo "---Done---"
exit 0
##################################

cd "$LAUNCH_DIR"
