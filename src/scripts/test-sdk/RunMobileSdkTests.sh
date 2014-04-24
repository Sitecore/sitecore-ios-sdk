#!/bin/bash
#
#
#####################

LAUNCH_DIR=$PWD

cd ../
  SCRIPTS_ROOT_DIR=$PWD
cd "$LAUNCH_DIR"

cd ../../
    PROJECT_ROOT=$PWD
cd "$LAUNCH_DIR"


GCOVR=$SCRIPTS_ROOT_DIR/coverage/gcovr
LAUNCH_SIMULATOR_WITHOUT_APP="/usr/local/bin/ios-sim start"


#IOS_VERSION=5.1
CONFIGURATION=Debug

OLD_XCODE_PATH=$(xcode-select -print-path)
#latest stable xcode
#sudo xcode-select -switch "/Applications/Xcode/Contents/Developer"

rm -rf "$PROJECT_ROOT/deployment"
mkdir -p "$PROJECT_ROOT/deployment/test-results"

/bin/bash "$SCRIPTS_ROOT_DIR/simulator/CleanTestReports.sh"
	$LAUNCH_SIMULATOR_WITHOUT_APP
    /bin/bash "$PWD/RunSCContactTest.sh" "$IOS_VERSION" "$CONFIGURATION"
    if [ "$?" -ne "0" ]; then 
       echo "[!!! ERROR !!!] : RunSCContactTest.sh failed"
       exit 1
    fi


#    /bin/bash "$PWD/RunSCMapViewTests.sh" "$IOS_VERSION" "$CONFIGURATION"
#    if [ "$?" -ne "0" ]; then 
#       echo "[!!! ERROR !!!] : RunSCMapViewTests.sh failed"
#       exit 1
#    fi

/bin/bash "$SCRIPTS_ROOT_DIR/simulator/CopyTestReports.sh"

#restore settings
#sudo xcode-select -switch "$OLD_XCODE_PATH"

################  COVERAGE
echo "---Collecting coverage reports---"

cd "$PROJECT_ROOT"
    echo "$GCOVR $PWD --root=$PWD --xml > $PWD/Coverage.xml"
	echo "$GCOVR $PWD --root=$PWD       > $PWD/Coverage.txt"

	$GCOVR "$PWD" --root="$PWD" --xml | tee "$PWD/Coverage.xml"
	$GCOVR "$PWD" --root="$PWD"       | tee "$PWD/Coverage.txt"
cd "$LAUNCH_DIR"

echo "---Done---"
exit 0
##################################
