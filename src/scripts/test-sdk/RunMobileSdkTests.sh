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


#IOS_VERSION=5.1
CONFIGURATION=Debug

OLD_XCODE_PATH=$(xcode-select -print-path)
#latest stable xcode
#sudo xcode-select -switch "/Applications/Xcode/Contents/Developer"

##rm -rf "$PROJECT_ROOT/deployment"
##mkdir -p "$PROJECT_ROOT/deployment/test-results"

/bin/bash "$SCRIPTS_ROOT_DIR/simulator/CleanTestReports.sh"
    # /bin/bash "$PWD/RunSCApiTest.sh" "$IOS_VERSION" "$CONFIGURATION"
    # if [ "$?" -ne "0" ]; then 
    #    echo "[!!! ERROR !!!] : RunSCApiTest.sh failed"
    #    exit 1
    # fi

    /bin/bash "$PWD/RunSCApiTestCleanSitecore.sh" "$IOS_VERSION" "$CONFIGURATION"
    if [ "$?" -ne "0" ]; then 
       echo "[!!! ERROR !!!] : RunSCApiTestCleanSitecore.sh failed"
       exit 1
    fi

#    /bin/bash "$PWD/RunSCApiUnitTest.sh" "$IOS_VERSION" "$CONFIGURATION"
#    if [ "$?" -ne "0" ]; then 
#       echo "[!!! ERROR !!!] : RunSCApiUnitTest.sh failed"
#       exit 1
#    fi


    /bin/bash "$PWD/RunSCContactTest.sh" "$IOS_VERSION" "$CONFIGURATION"
    if [ "$?" -ne "0" ]; then 
       echo "[!!! ERROR !!!] : RunSCContactTest.sh failed"
       exit 1
    fi


    /bin/bash "$PWD/RunSCMapViewTests.sh" "$IOS_VERSION" "$CONFIGURATION"
    if [ "$?" -ne "0" ]; then 
       echo "[!!! ERROR !!!] : RunSCMapViewTests.sh failed"
       exit 1
    fi

/bin/bash "$SCRIPTS_ROOT_DIR/simulator/CopyTestReports.sh"

#restore settings
#sudo xcode-select -switch "$OLD_XCODE_PATH"

