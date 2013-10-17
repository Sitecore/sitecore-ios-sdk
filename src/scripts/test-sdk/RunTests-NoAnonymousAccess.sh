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


rm -rf "$PROJECT_ROOT/deployment"
mkdir -p "$PROJECT_ROOT/deployment/test-results"

/bin/bash "$SCRIPTS_ROOT_DIR/simulator/CleanTestReports.sh"
    /bin/bash "$PWD/RunSCApiTestCleanSitecore-NoAnonymous.sh" "$IOS_VERSION" "$CONFIGURATION"
    if [ "$?" -ne "0" ]; then 
       echo "[!!! ERROR !!!] : RunSCApiTestCleanSitecore.sh failed"
       exit 1
    fi
/bin/bash "$SCRIPTS_ROOT_DIR/simulator/CopyTestReports.sh"

#restore settings
#sudo xcode-select -switch "$OLD_XCODE_PATH"