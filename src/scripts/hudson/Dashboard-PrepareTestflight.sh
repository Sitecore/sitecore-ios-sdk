
LAUNCH_DIR=$PWD
BUILT_PRODUCTS_DIR=$LAUNCH_DIR/app/Dashboard/build/Release-iphoneos/


cd "$LAUNCH_DIR/scripts"
   /bin/bash "$PWD/UploadToTestFlight.sh" "$BUILT_PRODUCTS_DIR"
cd "$LAUNCH_DIR"