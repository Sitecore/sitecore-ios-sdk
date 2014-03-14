#!/bin/bash
#
#
#####################

LAUNCH_DIR=$PWD


# @adk : comment this if no RVM is installed on build server
#rvm use system

echo "----ruby info----"
which ruby
which rvm
echo "-----------------"

cd ../
  SCRIPTS_ROOT_DIR=$PWD
cd "$LAUNCH_DIR"

cd ../../
    PROJECT_ROOT=$PWD
cd "$LAUNCH_DIR"


CUSTOM_DERIVED_DATA_DIR=~/tmp/Dashboard.build
rm -rf "$CUSTOM_DERIVED_DATA_DIR"
mkdir -p "$CUSTOM_DERIVED_DATA_DIR"



REPORT_DIR=$PROJECT_ROOT/deployment/test-results
COVERAGE_REPORT_DIR=$PROJECT_ROOT/deployment/coverage-results

IOS_VERSION=7.0
CONFIGURATION=Coverage
KILL_SIMULATOR=$SCRIPTS_ROOT_DIR/simulator/KillSimulator.sh
TEST_CONVERTER=ocunit2junit.rb
GCOVR=$SCRIPTS_ROOT_DIR/coverage/gcovr
TEST_WORKSPACE=DashboardUnitTests.xcworkspace
DEVICE=iPad

rm -rf "$PROJECT_ROOT/deployment"
mkdir -p "$REPORT_DIR"
mkdir -p "$COVERAGE_REPORT_DIR"



cd "$PROJECT_ROOT/lib/SCAllDashboardLibs"
TMP_REPORT_DIR=$PWD/test-reports
WORKSPACE_DIR=$PWD



echo "========[BEGIN] iAsyncUrlSession-XCTest========"
    INTERMEDIATES_DIR=${CUSTOM_DERIVED_DATA_DIR}/iAsyncUrlSession

    /bin/bash "$KILL_SIMULATOR"
    xcodebuild test \
        -scheme iAsyncUrlSession-XCTest \
        -workspace $TEST_WORKSPACE \
        -configuration $CONFIGURATION \
        -destination OS=$IOS_VERSION,name=$DEVICE \
        OBJROOT="$INTERMEDIATES_DIR" \
        | $TEST_CONVERTER

    cd "$TMP_REPORT_DIR"
    cp *.xml "$REPORT_DIR"
    cd "$WORKSPACE_DIR"
echo "========[END] iAsyncUrlSession-SenTest========"


echo "========[BEGIN] SDFavouritesAsync-XCTest========"
    INTERMEDIATES_DIR=${CUSTOM_DERIVED_DATA_DIR}/SDFavouritesAsync

    /bin/bash "$KILL_SIMULATOR"
    xcodebuild test \
        -scheme SDFavouritesAsync-XCTest \
        -workspace $TEST_WORKSPACE \
        -configuration $CONFIGURATION \
        -destination OS=$IOS_VERSION,name=$DEVICE \
        OBJROOT="$INTERMEDIATES_DIR" \
        | $TEST_CONVERTER

    cd "$TMP_REPORT_DIR"
    cp *.xml "$REPORT_DIR"
    cd "$WORKSPACE_DIR"
echo "========[END] SDFavouritesAsync-SenTest========"



echo "========[BEGIN] CsvToSqlite-SenTest========"
    INTERMEDIATES_DIR=${CUSTOM_DERIVED_DATA_DIR}/CsvToSqlite

    /bin/bash "$KILL_SIMULATOR"
    xcodebuild test \
        -scheme CsvToSqlite-SenTest \
        -workspace $TEST_WORKSPACE \
        -configuration $CONFIGURATION \
        -destination OS=$IOS_VERSION,name=$DEVICE \
        OBJROOT="$INTERMEDIATES_DIR" \
        | $TEST_CONVERTER

    cd "$TMP_REPORT_DIR"
    cp *.xml "$REPORT_DIR"
    cd "$WORKSPACE_DIR"
echo "========[END] CsvToSqlite-SenTest========"


echo "========[BEGIN] ESDotnetFormatter-SenTest========"
    INTERMEDIATES_DIR=${CUSTOM_DERIVED_DATA_DIR}/ESDotnetFormatter

    /bin/bash "$KILL_SIMULATOR"
    xcodebuild test \
        -scheme ESDotnetFormatter-SenTest \
        -workspace $TEST_WORKSPACE \
        -configuration $CONFIGURATION \
        -destination OS=$IOS_VERSION,name=$DEVICE \
        OBJROOT="$INTERMEDIATES_DIR" \
        | $TEST_CONVERTER
    cd "$TMP_REPORT_DIR"
    cp -v *.xml "$REPORT_DIR"
    cd "$WORKSPACE_DIR"
echo "========[END] ESDotnetFormatter-SenTest========"


echo "========[BEGIN] ESLocale-SenTest========"
    INTERMEDIATES_DIR=${CUSTOM_DERIVED_DATA_DIR}/ESLocale

    /bin/bash "$KILL_SIMULATOR"
    xcodebuild test \
        -scheme ESLocale-SenTest \
        -workspace $TEST_WORKSPACE \
        -configuration $CONFIGURATION \
        -destination OS=$IOS_VERSION,name=$DEVICE \
        OBJROOT="$INTERMEDIATES_DIR" \
        | $TEST_CONVERTER
    cd "$TMP_REPORT_DIR"
    cp -v  *.xml "$REPORT_DIR"
    cd "$WORKSPACE_DIR"
echo "========[END] ESLocale-SenTest========"


echo "========[BEGIN] JFFUtils-SenTest========"
    INTERMEDIATES_DIR=${CUSTOM_DERIVED_DATA_DIR}/JFFUtils

    /bin/bash "$KILL_SIMULATOR"
    xcodebuild test \
        -scheme JFFUtils-SenTest \
        -workspace $TEST_WORKSPACE \
        -configuration $CONFIGURATION \
        -destination OS=$IOS_VERSION,name=$DEVICE \
        OBJROOT="$INTERMEDIATES_DIR" \
        | $TEST_CONVERTER
    cd "$TMP_REPORT_DIR"
    cp -v  *.xml "$REPORT_DIR"
    cd "$WORKSPACE_DIR"
echo "========[END] JFFUtils-SenTest========"


echo "========[BEGIN] ObjcScopedGuard-SenTest========"
    INTERMEDIATES_DIR=${CUSTOM_DERIVED_DATA_DIR}/ObjcScopedGuard

    /bin/bash "$KILL_SIMULATOR"
    xcodebuild test \
        -scheme ObjcScopedGuard-SenTest \
        -workspace $TEST_WORKSPACE \
        -configuration $CONFIGURATION \
        -destination OS=$IOS_VERSION,name=$DEVICE \
        OBJROOT="$INTERMEDIATES_DIR" \
        | $TEST_CONVERTER
    cd "$TMP_REPORT_DIR"
    cp -v  *.xml "$REPORT_DIR"
    cd "$WORKSPACE_DIR"
echo "========[END] ObjcScopedGuard-SenTest========"


echo "========[BEGIN] SCChart-SenTest========"
    INTERMEDIATES_DIR=${CUSTOM_DERIVED_DATA_DIR}/SCChart

    /bin/bash "$KILL_SIMULATOR"
    xcodebuild test \
        -scheme SCChart-SenTest \
        -workspace $TEST_WORKSPACE \
        -configuration $CONFIGURATION \
        -destination OS=$IOS_VERSION,name=$DEVICE \
        OBJROOT="$INTERMEDIATES_DIR" \
        | $TEST_CONVERTER
    cd "$TMP_REPORT_DIR"
    cp -v  *.xml "$REPORT_DIR"
    cd "$WORKSPACE_DIR"
echo "========[END] SCChart-SenTest========"


echo "========[BEGIN] SCUIComponents-SenTest========"
    INTERMEDIATES_DIR=${CUSTOM_DERIVED_DATA_DIR}/SCUIComponents

    /bin/bash "$KILL_SIMULATOR"
    xcodebuild test \
        -scheme SCUIComponents-SenTest \
        -workspace $TEST_WORKSPACE \
        -configuration $CONFIGURATION \
        -destination OS=$IOS_VERSION,name=$DEVICE \
        OBJROOT="$INTERMEDIATES_DIR" \
        | $TEST_CONVERTER
    cd "$TMP_REPORT_DIR"
    cp -v  *.xml "$REPORT_DIR"
    cd "$WORKSPACE_DIR"
echo "========[END] SCUIComponents-SenTest========"


echo "========[BEGIN] SDApi-SenTest========"
    INTERMEDIATES_DIR=${CUSTOM_DERIVED_DATA_DIR}/SDApi

    /bin/bash "$KILL_SIMULATOR"
    xcodebuild test \
        -scheme SDApi-SenTest \
        -workspace $TEST_WORKSPACE \
        -configuration $CONFIGURATION \
        -destination OS=$IOS_VERSION,name=$DEVICE \
        OBJROOT="$INTERMEDIATES_DIR" \
        | $TEST_CONVERTER
    cd "$TMP_REPORT_DIR"
    cp -v  *.xml "$REPORT_DIR"
    cd "$WORKSPACE_DIR"
echo "========[END] SDApi-SenTest========"


echo "========[BEGIN] SDDatabase-SenTest========"
    INTERMEDIATES_DIR=${CUSTOM_DERIVED_DATA_DIR}/SDDatabase

    /bin/bash "$KILL_SIMULATOR"
    xcodebuild test \
        -scheme SDDatabase-SenTest \
        -workspace $TEST_WORKSPACE \
        -configuration $CONFIGURATION \
        -destination OS=$IOS_VERSION,name=$DEVICE \
        OBJROOT="$INTERMEDIATES_DIR" \
        | $TEST_CONVERTER
    cd "$TMP_REPORT_DIR"
    cp -v  *.xml "$REPORT_DIR"
    cd "$WORKSPACE_DIR"
echo "========[END] SDDatabase-SenTest========"


echo "========[BEGIN] SDFavourites-SenTest========"
    INTERMEDIATES_DIR=${CUSTOM_DERIVED_DATA_DIR}/SDFavourites

    /bin/bash "$KILL_SIMULATOR"
    xcodebuild test \
        -scheme SDFavourites-SenTest \
        -workspace $TEST_WORKSPACE \
        -configuration $CONFIGURATION \
        -destination OS=$IOS_VERSION,name=$DEVICE \
        OBJROOT="$INTERMEDIATES_DIR" \
        | $TEST_CONVERTER
    cd "$TMP_REPORT_DIR"
    cp -v  *.xml "$REPORT_DIR"
    cd "$WORKSPACE_DIR"
echo "========[END] SDFavourites-SenTest========"


echo "========[BEGIN] SDHelpProvider-SenTest========"
    INTERMEDIATES_DIR=${CUSTOM_DERIVED_DATA_DIR}/SDHelpProvider

    /bin/bash "$KILL_SIMULATOR"
    xcodebuild test \
        -scheme SDHelpProvider-SenTest \
        -workspace $TEST_WORKSPACE \
        -configuration $CONFIGURATION \
        -destination OS=$IOS_VERSION,name=$DEVICE \
        OBJROOT="$INTERMEDIATES_DIR" \
        | $TEST_CONVERTER
    cd "$TMP_REPORT_DIR"
    cp -v  *.xml "$REPORT_DIR"
    cd "$WORKSPACE_DIR"
echo "========[END] SDHelpProvider-SenTest========"


echo "========[BEGIN] SDLogger-SenTest========"
    INTERMEDIATES_DIR=${CUSTOM_DERIVED_DATA_DIR}/SDLogger

    /bin/bash "$KILL_SIMULATOR"
    xcodebuild test \
        -scheme SDLogger-SenTest \
        -workspace $TEST_WORKSPACE \
        -configuration $CONFIGURATION \
        -destination OS=$IOS_VERSION,name=$DEVICE \
        OBJROOT="$INTERMEDIATES_DIR" \
        | $TEST_CONVERTER
    cd "$TMP_REPORT_DIR"
    cp -v  *.xml "$REPORT_DIR"
    cd "$WORKSPACE_DIR"
echo "========[END] SDLogger-SenTest========"


echo "========[BEGIN] SDLogic-SenTest========"
    INTERMEDIATES_DIR=${CUSTOM_DERIVED_DATA_DIR}/SDLogic

    /bin/bash "$KILL_SIMULATOR"
        xcodebuild test \
        -scheme SDLogic-SenTest \
        -workspace $TEST_WORKSPACE \
        -configuration $CONFIGURATION \
        -destination OS=$IOS_VERSION,name=$DEVICE \
        OBJROOT="$INTERMEDIATES_DIR" \
        | $TEST_CONVERTER
    cd "$TMP_REPORT_DIR"
    cp -v  *.xml "$REPORT_DIR"
    cd "$WORKSPACE_DIR"
echo "========[END] SDLogic-SenTest========"


echo "========[BEGIN] SDModel-SenTest========"
    INTERMEDIATES_DIR=${CUSTOM_DERIVED_DATA_DIR}/SDModel

    /bin/bash "$KILL_SIMULATOR"
    xcodebuild test \
        -scheme SDModel-SenTest \
        -workspace $TEST_WORKSPACE \
        -configuration $CONFIGURATION \
        -destination OS=$IOS_VERSION,name=$DEVICE \
        OBJROOT="$INTERMEDIATES_DIR" \
        | $TEST_CONVERTER
    cd "$TMP_REPORT_DIR"
    cp -v  *.xml "$REPORT_DIR"
    cd "$WORKSPACE_DIR"
echo "========[END] SDModel-SenTest========"


echo "========[BEGIN] SDModelSerialization-SenTest========"
    INTERMEDIATES_DIR=${CUSTOM_DERIVED_DATA_DIR}/SDModelSerialization

    /bin/bash "$KILL_SIMULATOR"
    xcodebuild test \
        -scheme SDModelSerialization-SenTest \
        -workspace $TEST_WORKSPACE \
        -configuration $CONFIGURATION \
        -destination OS=$IOS_VERSION,name=$DEVICE \
        OBJROOT="$INTERMEDIATES_DIR" \
        | $TEST_CONVERTER
    cd "$TMP_REPORT_DIR"
    cp -v  *.xml "$REPORT_DIR"
    cd "$WORKSPACE_DIR"
echo "========[END] SDModelSerialization-SenTest========"

    /bin/bash "$KILL_SIMULATOR"
cd "$LAUNCH_DIR"





################  COVERAGE
echo "---Collecting coverage reports---"
cd "$INTERMEDIATES_DIR"

echo "$GCOVR $CUSTOM_DERIVED_DATA_DIR --root=$PROJECT_ROOT --xml > $COVERAGE_REPORT_DIR/Coverage.xml"

"$GCOVR" "$CUSTOM_DERIVED_DATA_DIR" --root="$PROJECT_ROOT" --xml | tee "$COVERAGE_REPORT_DIR/Coverage.xml"
"$GCOVR" "$CUSTOM_DERIVED_DATA_DIR" --root="$PROJECT_ROOT"       | tee "$COVERAGE_REPORT_DIR/Coverage.txt"

cd "$LAUNCH_DIR"


echo "---Done---"
exit 0
##################################


