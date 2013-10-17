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


REPORT_DIR=$PROJECT_ROOT/deployment/test-results

IOS_VERSION=7.0
CONFIGURATION=Coverage
KILL_SIMULATOR=$SCRIPTS_ROOT_DIR/simulator/KillSimulator.sh
TEST_CONVERTER=ocunit2junit.rb
TEST_WORKSPACE=MobileSDK-UnitTests.xcworkspace
DEVICE=iPad

rm -rf "$PROJECT_ROOT/deployment"
mkdir -p "$REPORT_DIR"



cd "$PROJECT_ROOT/lib/SCAllMobileSDKLibs"
TMP_REPORT_DIR=$PWD/test-reports
WORKSPACE_DIR=$PWD


    /bin/bash "$KILL_SIMULATOR"
    xcodebuild test \
        -scheme SCApi-SenTest \
        -workspace $TEST_WORKSPACE \
        -configuration $CONFIGURATION \
        -destination OS=$IOS_VERSION,name=$DEVICE \
        | $TEST_CONVERTER
    cd "$TMP_REPORT_DIR"
    cp -v  *.xml "$REPORT_DIR"
    cd "$WORKSPACE_DIR"



    /bin/bash "$KILL_SIMULATOR"
    xcodebuild test \
        -scheme JFFUtils-SenTest \
        -workspace $TEST_WORKSPACE \
        -configuration $CONFIGURATION \
        -destination OS=$IOS_VERSION,name=$DEVICE \
        | $TEST_CONVERTER
    cd "$TMP_REPORT_DIR"
    cp -v  *.xml "$REPORT_DIR"
    cd "$WORKSPACE_DIR"




    /bin/bash "$KILL_SIMULATOR"
    xcodebuild test \
        -scheme ObjcScopedGuard-SenTest \
        -workspace $TEST_WORKSPACE \
        -configuration $CONFIGURATION \
        -destination OS=$IOS_VERSION,name=$DEVICE \
        | $TEST_CONVERTER
    cd "$TMP_REPORT_DIR"
    cp -v  *.xml "$REPORT_DIR"
    cd "$WORKSPACE_DIR"






#    /bin/bash "$KILL_SIMULATOR"
#    xcodebuild test \
#        -scheme ZXingWidget-SenTest \
#        -workspace $TEST_WORKSPACE \
#        -configuration $CONFIGURATION \
#        -destination OS=$IOS_VERSION,name=$DEVICE \
#        | $TEST_CONVERTER
#    cd "$TMP_REPORT_DIR"
#    cp -v  *.xml "$REPORT_DIR"
#    cd "$WORKSPACE_DIR"


/bin/bash "$KILL_SIMULATOR"
cd "$LAUNCH_DIR"
