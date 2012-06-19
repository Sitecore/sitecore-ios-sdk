BUILT_PRODUCTS_DIR=$1
LAUNCH_DIR=$PWD


cd "$BUILT_PRODUCTS_DIR"

find . -type d -name "*.app" -exec zip -r Dashboard.zip {} \;  -print

cd "$LAUNCH_DIR"
